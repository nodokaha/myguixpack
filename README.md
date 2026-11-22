# polkit-ck: seatd のまま polkit 認証を通す

## 背景

Guix の polkit はセッション照合に elogind を使う前提でビルドされている
(`-Dsession_tracking=elogind`)。elogind を消して seatd 運用にすると、
`pkexec true` がパスワード入力まで進んでも最後に

```
polkit-agent-helper-1: error response to PolicyKit daemon:
GDBus.Error:org.freedesktop.PolicyKit1.Error.Failed: No session for cookie
```

で落ちる (2026-11-22、desktop で実証)。polkit が「この認証はどのログイン
セッションのものか」を引くための台帳係がいないためで、認証エージェントを
足しても直らない。

elogind を戻すと seatd と席 (seat0) の取り合いになるので、代わりに
**台帳係だけを ConsoleKit2 に任せる**のがこの構成。

- ConsoleKit2 はセッションとシートの台帳だけを担い、デバイスの仲介は
  しない。だから seatd と衝突しない
- polkit は上流の現行版 (125) でも `session_tracking` の選択肢に
  `ConsoleKit` が正式に残っている (FreeBSD や CRUX がこの構成で
  polkit 125/127 をビルドしている実績あり)
- polkit の ConsoleKit モニタは `/var/run/ConsoleKit/database` を読んで
  セッションを照合する

## 中身

`polkit-ck.scm` (myguixpack チャンネル用モジュール `(polkit-ck)`) に2つ。

| パッケージ | 内容 |
|---|---|
| `consolekit2` | ConsoleKit2 1.2.7 を新規パッケージ化。`console-kit-daemon`、`ck-launch-session`、`ck-list-sessions`、`pam_ck_connector` を含む |
| `polkit/ck` | 本家 polkit を inherit し、`-Dsession_tracking=` を `ConsoleKit` に書き換え、inputs から elogind を外した変種 |

ポイント:

- `consolekit2` の configure には `--localstatedir=/var` を付けている。
  polkit 側が `/var/run/ConsoleKit/database` を決め打ちで読むため
- `consolekit2` の inputs の polkit は**本家**のまま。ConsoleKit が使うのは
  クライアントライブラリ (libpolkit-gobject-1) だけで、セッション追跡の
  選択はデーモン側の話。`polkit/ck` を入れると依存が循環する
- `polkit/ck` のフラグ書き換えは文字列の表記ゆれを吸収する形にしてある
  (Guix 121 は `libelogind`、127 は `elogind`)

## 追加方法

前提: **未検証の叩き台**。Muse の VM には Guix が無いので、まず laptop で
ビルドを通してから desktop に持っていく進め方を想定している。

### 1. チャンネルに置く

```sh
cp polkit-ck.scm ~/myguixpack/
```

### 2. consolekit2 のハッシュを確定する

定義中の sha256 はプレースホルダ (`000...0`)。実値に置き換える。

```sh
git clone https://github.com/ConsoleKit2/ConsoleKit2
cd ConsoleKit2 && git checkout 1.2.7 && cd ..
guix hash -rx ConsoleKit2
```

出力された base32 を `polkit-ck.scm` の `(base32 "...")` に貼る。
(タグは 1.2.7 を置いてある。採用時点で新しいタグがあれば差し替えてよいが、
ビルド方式が autotools から変わっていたら定義ごと見直しが要る)

### 3. ビルド確認 (laptop)

```sh
cd ~/myguixpack
guix build -L . consolekit2
guix build -L . polkit-ck
```

転びやすいところ:

- `autoreconf` でマクロが無いと言われたら、そのマクロを持つパッケージを
  `consolekit2` の native-inputs に足す (gtk-doc と gobject-introspection は
  最初から入れてある)
- configure フラグ名が違うと言われたら `configure --help` で実物を確認して
  直す (`--enable-pam-module`、`--with-pam-module-dir` あたり)
- `polkit/ck` 側で本家のフェーズやパッチ (`polkit-disable-systemd.patch`
  など) が elogind/systemd 前提の書き換えをしていたら、そこが調整ポイント

### 4. OS 設定への組み込み (desktop)

OS 設定ファイルの `#:use-module` に `(polkit-ck)` と
`(gnu services dbus)` を足した上で、services に手を入れる。

#### (a) polkit-service-type の中身を差し替える

既存の `modify-services` に、guix-service-type の書き換えと同じ手つきで追加。

```scheme
(polkit-service-type config =>
                     (polkit-configuration
                      (inherit config)
                      (polkit polkit/ck)))
```

#### (b) ConsoleKit をシステムバスに登録する

`console-kit-daemon` は D-Bus アクティベーションで起動するので、
デーモン常駐の shepherd サービスは必須ではない。まずこれだけで試す。

```scheme
(simple-service 'consolekit dbus-root-service-type
                (list consolekit2))
```

アクティベーションだけでは不安定な場合は、shepherd で常駐させる形に
切り替える (デーモン側のオプション名は `--help` で要確認)。

```scheme
(simple-service 'consolekit shepherd-root-service-type
                (list (shepherd-service
                       (provision '(console-kit-daemon))
                       (documentation "Run the ConsoleKit daemon.")
                       (requirement '(dbus-system))
                       (start #~(make-forkexec-constructor
                                 (list #$(file-append consolekit2
                                                      "/sbin/console-kit-daemon")
                                       "--no-daemon")))
                       (stop #~(make-kill-destructor)))))
```

#### (c) セッション登録 (いちばんの肝)

ログインセッションが ConsoleKit に登録されていないと、polkit が cookie を
引けず、今と同じ落ち方をする。登録の経路は2つ。

- **本命: `ck-launch-session` でセッションを包む。**
  greetd がユーザーセッションを起動するコマンドを
  `ck-launch-session sway` の形にする。包むのは sway 本体の起動でないと
  意味がない (sway の子プロセスとして後から起動しても、cookie はその
  子ツリーにしか行き渡らない)。
  ただし gtkgreet 構成では「どのコマンドがユーザーセッションの祖先に
  なるか」が構成依存なので、ここは実験が要る
- **代替: `pam_ck_connector` を greetd の PAM に足す。**
  ConsoleKit の PAM モジュール (`lib/security/pam_ck_connector.so`) が
  ログイン時にセッションを登録する。Guix では greetd の PAM スタックへの
  追加が硬めなので、(c) の本命がダメだったら検討する

### 5. 認証エージェント (Guix Home 側)

ここまで通ったら、最後にグラフィカルな認証エージェントを足す。
polkit-gnome のエージェントは `bin` ではなく `libexec` にあるので、
sway の exec ではなく shepherd サービスで回すのが素直。

```scheme
;; home の packages に polkit-gnome を追加した上で
(simple-service 'polkit-agent home-shepherd-service-type
                (list (shepherd-service
                       (provision '(polkit-agent))
                       (documentation
                        "Run the polkit-gnome authentication agent.")
                       (start #~(make-forkexec-constructor
                                 (list #$(file-append
                                          polkit-gnome
                                          "/libexec/polkit-gnome-authentication-agent-1"))))
                       (stop #~(make-kill-destructor)))))
```

## 検証手順

reconfigure → 再ログインのあと、順に確認する。

```sh
# 自分のセッションが ConsoleKit に見えているか
ck-list-sessions

# cookie がセッションのプロセスに行き渡っているか (ck-launch-session 経由の場合)
echo $XDG_SESSION_COOKIE

# 本丸。"No session for cookie" が消えて認証が通れば勝ち
pkexec true
```

通ったら Thunar や udisks のマウントなど、polkit を使う操作全般が
まとめて生き返るはず。

## うまくいかないときの切り分け

- **`/var/run/ConsoleKit/database` が無い** → console-kit-daemon が
  起動していない。D-Bus アクティベーションの登録 ((b)) を確認する
- **セッションは見えるが pkexec が落ちる** → セッションが active と
  認識されていないか、cookie がプロセスに伝わっていない。
  `ck-list-sessions` の `is_active` と、起動経路 ((c)) を見直す
- **それでもダメな場合** → CRUX は polkit 127 + ConsoleKit の構成で
  `polkitunixsession.c` と `polkitbackendsessionmonitor.c` にパッチを
  当てている。素の polkit では現代の環境向けに小さい直しが要る可能性が
  あり、その2ファイルが最初の調査ポイントになる

## 注意

- ConsoleKit2 は枯れた技術で、polkit 側の ConsoleKit サポートも legacy
  扱い。将来の polkit で消える可能性はある。それでも「seatd を守ったまま
  polkit を生かす」現実解としては、今のところこれが一番筋がよい
- この一式は 2026-11-22 時点の叩き台。ビルドと配線の検証は laptop から
