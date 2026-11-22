;;; polkit-ck.scm -- seatd のまま polkit 認証を通すためのパッケージ定義
;;;
;;; myguixpack チャンネル用のモジュール。Guix 本体には無い ConsoleKit2 と、
;;; session_tracking=ConsoleKit でビルドした polkit の変種 (polkit/ck) を
;;; 定義する。elogind を消した seatd 運用では polkit のセッション照合が
;;; "No session for cookie" で落ちるため、台帳係だけを ConsoleKit2 に
;;; 任せる構成。
;;;
;;; 注意: パッケージのビルドは 2026-11-23 に laptop で確認済み
;;; (consolekit2 / polkit-ck とも成功)。同日デスクトップへ組み込み、
;;; セッション登録 (active) と GetSessionForCookie /
;;; GetSessionForUnixProcess の照合成功まで確認済み。認証の完走には
;;; グラフィカルエージェントが要り、polkit-gnome は素の polkit
;;; (logind 版モニタ) にリンクするため polkit-gnome/ck を使う。
;;; pkexec 内蔵のテキストエージェントは応答段で "No session for
;;; cookie" になる (登録が root 権限経由のためとみられる)。

(define-module (polkit-ck)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages xorg))

(define-public consolekit2
  (package
    (name "consolekit2")
    (version "1.2.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/ConsoleKit2/ConsoleKit2")
              (commit version)))
       (file-name (git-file-name name version))
       (sha256
        ;; 1.2.7 タグのチェックアウトを guix hash -rx で測った値。
        ;; なおタグの中身の configure.ac の版表記は 1.2.6 のまま
        ;; (上流が上げ忘れたとみられる)。
        (base32 "1fgnwhqvzjy4yg8xg76fiabamb7jnhvznjj9dxpqlzl1lhpsd6vd"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f            ;チェック用のスイートは同梱されていない
           #:configure-flags
           #~(list ;; polkit の ConsoleKit モニタは
                   ;; /var/run/ConsoleKit/database を決め打ちで読むので、
                   ;; データベースの置き場所をこちらに合わせる。
                   "--localstatedir=/var"
                   "--enable-pam-module"
                   (string-append "--with-pam-module-dir="
                                  #$output "/lib/security")
                   "--disable-gtk-doc"
                   "--enable-introspection=no")
           #:phases
           #~(modify-phases %standard-phases
               ;; Git のツリーには生成済みの configure が無いので作る。
               ;; (ビルドシステム標準の bootstrap フェーズと重なっても
               ;;  autoreconf は冪等なので害はない)
               (add-after 'unpack 'autoreconf
                 (lambda _
                   ;; data/Makefile.am のログ置き場を作る install 規則は
                   ;; localstatedir (/var) をそのまま使うので、サンドボックス
                   ;; 内で書けるよう出力先の中に逃がす。コンパイル時や
                   ;; 設定ファイルに埋まる localstatedir は /var のまま。
                   (substitute* "data/Makefile.am"
                     (("\\$\\(DESTDIR\\)\\$\\(localstatedir\\)/log/ConsoleKit")
                      "$(DESTDIR)$(prefix)/var/log/ConsoleKit"))
                   ;; doc の Makefile.am が gtk-doc.make を include するので、
                   ;; autoreconf の前に gtkdocize で雛形をコピーしておく。
                   (invoke "gtkdocize")
                   (invoke "autoreconf" "-vfi"))))))
    (native-inputs
     ;; autoreconf 時に configure.ac が参照するマクロの供給元。
     ;; マクロ不足で転んだら、不足分をここへ足す。
     (list autoconf
           automake
           libtool
           intltool
           gettext-minimal
           gtk-doc
           gobject-introspection
           pkg-config
           ;; gdbus-codegen と glib-genmarshal がビルド時に要る。
           (list glib "bin")))
    (inputs
     (list glib
           dbus
           libx11
           zlib
           eudev
           linux-pam
           ;; console-kit-daemon は認可チェックに libpolkit-gobject-1 を
           ;; 使う。ここは本家の polkit でよい。セッション追跡の選択は
           ;; polkitd (デーモン) 側の話で、クライアントライブラリには
           ;; 影響しない。polkit/ck を入れると依存が循環するので入れない。
           polkit))
    (home-page "https://consolekit2.github.io/ConsoleKit2")
    (synopsis "ユーザー、ログインセッション、シートを追跡するフレームワーク")
    (description
     "ConsoleKit2 は、ユーザーとログインセッション、シート (seat) を定義し
追跡するためのフレームワーク。デバイスの仲介は行わず、セッションの台帳
だけを担う。そのため seatd と役割が重ならず、seatd 運用のまま polkit の
セッション照合 (session_tracking=ConsoleKit) の台帳係として使える。")
    (license license:gpl2+)))

(define-public polkit/ck
  (package/inherit polkit
    (name "polkit-ck")
    (arguments
     (substitute-keyword-arguments (package-arguments polkit)
       ((#:configure-flags flags #~'())
        ;; Guix の polkit は版によって綴りが違う
        ;; (121: "-Dsession_tracking=libelogind"、
        ;;  127: "-Dsession_tracking=elogind")。
        ;; どちらの綴りでも ConsoleKit に置き換わるようにしておく。
        #~(map (lambda (flag)
                 (if (or (equal? flag "-Dsession_tracking=libelogind")
                         (equal? flag "-Dsession_tracking=elogind"))
                     "-Dsession_tracking=ConsoleKit"
                     flag))
               #$flags))))
    (inputs
     (modify-inputs (package-inputs polkit)
       ;; ConsoleKit 追跡では logind 系ライブラリは使わない。
       (delete "elogind")))))

(define-public polkit-gnome/ck
  (package/inherit polkit-gnome
    (name "polkit-gnome-ck")
    (inputs
     (modify-inputs (package-inputs polkit-gnome)
       ;; エージェントは自分のセッションを libpolkit-gobject の
       ;; セッションモニタで引く。素の polkit のモニタは logind 版
       ;; なので、elogind の無い環境では "Unable to determine the
       ;; session we are in" になって登録できない。ConsoleKit 版
       ;; モニタの polkit/ck に差し替える。
       (replace "polkit" polkit/ck)))))
