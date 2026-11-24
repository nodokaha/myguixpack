;;; shirudo.scm --- Shirudo（BPF ベースの Linux セキュリティ基盤）
;;;
;;; 上流: https://github.com/shirudo-dev/shirudo
;;; ライセンスは BSD-2-Clause（BPF プログラムは BSD/GPL デュアル）。
;;;
;;; 状態（2026-11-24 調査時点）:
;;;   * 正式リリース（リリースタグ／ソース tarball）はまだ無い。
;;;     GitHub Releases にあるのは CI のテストカーネル成果物
;;;     （"Test kernel build …"、タグ test-kernel-*）だけで、
;;;     shirudo 本体の配布は git のみ。VERSION ファイルは "0.0.0-dev"、
;;;     Makefile.version の版数発見も test-kernel-* タグを除外する。
;;;   * そのため git-fetch で main のコミットに固定する。
;;;     固定先: 1e81ff59107abbd811f05ab16bef5382c45b82d0
;;;     （2026-11-24 時点の main 先端。list_commits で確認）
;;;
;;; スコープ: operator プロファイル（make / make install-operator）。
;;; target プロファイルは、全依存の静的アーカイブを 1 つの libdir に
;;; 揃える前提で、上流は target-deps として OpenSSL 3.5.9 /
;;; libcurl 8.18.0 / tpm2-tss 4.2.0 をソースからビルドする。
;;; Guix の通常のパッケージ構成とは相性が悪いので対象外とした。
;;;
;;; vmlinux.h の生成元 BTF（解決済み）:
;;;   内蔵 BPF オブジェクトはビルド時に vmlinux.h を必要とする。
;;;   これはリポジトリに含まれず、BTF から同梱ツール
;;;   （tools/gen-vmlinux-h）で生成される。生成元の優先順は
;;;   BPF_VMLINUX_H=<生成済みヘッダ>、BPF_VMLINUX_BTF=<file>、
;;;   artifacts/bpf-next-kernel-debs/vmlinux.btf、最後に
;;;   /sys/kernel/btf/vmlinux（Makefile.shirudo で確認）。
;;;   しかも内蔵オブジェクトは署名付きローダ ABI（prog->aux->sig）を
;;;   読むため、その ABI を持つ bpf-next 系カーネルの BTF でないと
;;;   コンパイルできない（上流ドキュメント「System requirements」）。
;;;   BTF 無しでビルドすると gen-vmlinux-h が落ちる（終了コード 139。
;;;   2026-11-24、Muse VM で確認）。
;;;   供給方法: 上流 CI テストカーネルのリリース zip
;;;   （test-kernel-45212180772、kernel-packages-x86-64-ci.zip）に
;;;   vmlinux-7.4-shirudo-ci-20261123.btf がそのまま入っている。
;;;   これを別 origin（%shirudo-ci-kernel-zip）で固定し、
;;;   supply-vmlinux-btf フェーズで取り出して BPF_VMLINUX_BTF= で渡す。
;;;   2026-11-24、Muse VM で実証済み: この BTF から 99,045 行の
;;;   vmlinux.h が生成でき、bpf_prog_aux の sig も含まれる。
;;;
;;; その他の罠・TODO:
;;;   * shirudo-build が実行する clang は PATH 検索されず、ビルド時に
;;;     SHIRUDO_CLANG_PATH（既定 /usr/bin/clang）がバイナリへ
;;;     埋め込まれる（Makefile.shirudo の -DCLANG_PATH）。
;;;     → clang-23 のストアパスを make-flags で渡す。
;;;     埋め込まれる vmlinux.h の既定パス SHIRUDO_VMLINUX_PATH は
;;;     $(sharedir)/shirudo/vmlinux.h から導出されるので、prefix を
;;;     ストアに向ければ自動的に合う（Makefile.shirudo で確認）。
;;;     上流は clang/LLVM 23 を要求する。Guix 本家には clang-23 /
;;;     llvm-23（23.1.1）がある（gnu/packages/llvm.scm で確認）。
;;;     既定の clang は 22 系なので、必ず 23 を指すこと。
;;;   * shirudo-quote-check は -static-pie で libcrypto を静的リンク
;;;     する。上流トップ Makefile は、pkg-config の libdir に
;;;     libcrypto.a が無いと OpenSSL をソースからビルドしに行く
;;;     （quote-check-deps）。Guix の openssl は .a を "static" 出力へ
;;;     分離しているため、その検査（libdir 直下の有無）に引っかかり、
;;;     サンドボックス内でネット取得を試みて失敗する。
;;;     → QUOTE_CHECK_OPENSSL=（空）をコマンドラインで渡して自前
;;;       ビルドを止め（Makefile 側の ?= を上書きできる）、inputs に
;;;       (openssl "static") を入れてリンク時に libcrypto.a が
;;;       見つかるようにする。
;;;     → -static-pie に要る glibc 側の静的部品として (glibc "static")
;;;       も入れたが、Guix で静的 PIE がそのままリンクできるかは
;;;       未確認（TODO: laptop で確認）。
;;;     → 同じパッケージの複数出力（openssl と (openssl "static")）を
;;;       併記する書き方がこれでよいかも未確認（TODO: ラベル重複）。
;;;   * 版数刻印は Makefile.version が git describe で行う。
;;;     git-fetch のチェックアウトには .git が無いので、刻印が空に
;;;     なる／ビルドが止まる可能性がある（TODO: laptop で確認）。
;;;   * 実行時依存（ビルドには不要。shirudo build やイメージ生成で
;;;     使う。上流ドキュメント「System requirements」の operator
;;;     host 項より）: veritysetup（cryptsetup）、mkfs.ext4
;;;     （e2fsprogs）、llvm-strip、readelf（binutils）、bash、
;;;     coreutils。
;;;     TODO: propagated-inputs にするか wrap するか未決定。
;;;   * Guix の luajit が GC64 有効でビルドされているか未確認。
;;;     上流は 64bit 環境で LuaJIT（GC64）を要求する
;;;     （Makefile.config の luajit 検査自体は無条件）。
;;;   * テストは TPM シミュレータや root を前提とするものを含むため
;;;     無効化した（Makefile.shirudo の test 節コメントより）。
;;;     TODO: 動かせる範囲の切り分け。
;;;   * libbpf と BPF UAPI ヘッダは vendor/libbpf に同梱され、
;;;     bpftool も不要（vmlinux.h は同梱ツールで生成）。ビルド時の
;;;     ネットワークアクセスは本来不要な構成。
;;;
;;; ビルド時依存の対応（Makefile.config の pkg-config 検査より）:
;;;   libcrypto >= 3.5 / libssl >= 3.5 → openssl（Guix は 3.5.9。
;;;     ML-DSA 検査のため openssl CLI も同じ入力から PATH に入る）
;;;   tss2-esys >= 4.0 / tss2-tctildr → tpm2-tss-4（同梱モジュール）
;;;   libelf → elfutils、zlib → zlib、libcurl >= 7.75 → curl
;;;     （Guix は 8.21.0）、luajit → luajit
;;;
;;; 検証状況（2026-11-24、Muse VM の Guix 063d1af で確認）:
;;;   評価・依存解決・全 config 探査・ユーザーランドのコンパイル・
;;;   gen-vmlinux-h のリンクまで通過し、GEN vmlinux.h の段まで到達した。
;;;   BTF 供給込みの最終ビルドは実行中に VM が入れ替わり未完。
;;;   残りの確認は laptop 側か、VM に Guix を入れ直してから。

(define-module (shirudo)
  #:use-module (shirudo-deps)              ; tpm2-tss-4
  #:use-module (gnu packages base)         ; glibc
  #:use-module (gnu packages compression)  ; zlib
  #:use-module (gnu packages curl)         ; curl
  #:use-module (gnu packages elf)          ; elfutils（libelf）
  #:use-module (gnu packages llvm)         ; clang-23, llvm-23
  #:use-module (gnu packages lua)          ; luajit
  #:use-module (gnu packages pkg-config)   ; pkg-config
  #:use-module (gnu packages tls)          ; openssl
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:))

(define %shirudo-commit "1e81ff59107abbd811f05ab16bef5382c45b82d0")

;; BPF オブジェクトのコンパイルに要る vmlinux.h は、署名付きローダ ABI を
;; 持つカーネルの BTF から生成するしかない（冒頭のブロッカー参照）。
;; 上流の CI テストカーネルのリリース zip には vmlinux.btf がそのまま
;; 入っている（カーネル 7.4-shirudo-ci-20261123、g2bf3351c5f89）。
;; 2026-11-24、Muse VM で実証: この BTF を gen-vmlinux-h に通すと
;; 99,045 行の vmlinux.h が生成でき、bpf_prog_aux の sig（keyring_serial
;; 等）も含まれる。ハッシュはダウンロードして実測した。
;; 注意: 上流がテストカーネルを作り直すと asset が差し替わるので、
;; リリースタグとハッシュはセットで固定する。
(define %shirudo-ci-kernel-zip
  (origin
    (method url-fetch)
    (uri (string-append
          "https://github.com/shirudo-dev/shirudo/releases/download/"
          "test-kernel-45212180772/kernel-packages-x86-64-ci.zip"))
    (sha256
     (base32 "16sa2fiby6nqg85w3nzikjmci5shlzrxh68w7n6yl30ygg761rpk"))))

(define-public shirudo
  (package
    (name "shirudo")
    (version (git-version "0.0.0-dev" "0" %shirudo-commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/shirudo-dev/shirudo")
             (commit %shirudo-commit)))
       (file-name (git-file-name name version))
       ;; 2026-11-24、Muse VM 上の Guix で実測:
       ;;   git clone → 固定コミットを checkout → .git を除いて
       ;;   guix hash -rx <チェックアウト>
       ;; サブモジュールは無い（.gitmodules なし）ので非再帰で一致するはず。
       ;; 2026-11-24、guix build での照合も完了（チェックアウトが
       ;; そのまま unpack され、ビルドが進行した）。
       (sha256
        (base32 "0zgb61zjbvp3gkh56cnp7bf802h55hb7vnzvv451gls8wk0lqmf1"))))
    (build-system gnu-build-system)
    (arguments
     (list #:tests? #f            ; 上記コメント参照
           #:make-flags
           #~(list (string-append "prefix=" #$output)
                   ;; 上流は CC の既定が cc だが、Guix のビルド環境には
                   ;; cc という名前が無い（gcc パッケージは cc リンクを
                   ;; 作らない。gcc-toolchain にはある）。探査のコンパイル
                   ;; が command not found で落ち、「vendored ヘッダが
                   ;; 古い」という誤った不足表示になる（2026-11-24、
                   ;; Muse VM で診断フェーズを入れて特定）。
                   "CC=gcc"
                   ;; vendored libbpf.a（静的）をリンクすると
                   ;; __tls_get_addr の解決で「DSO missing from command
                   ;; line」になる（Guix の glibc では ld-linux が
                   ;; コマンドライン上の DSO として数えられない）。
                   ;; 間接 DSO からの解決を許可して回避する。
                   ;; LDFLAGS は上流の Makefile.shirudo で ?=（空）なので
                   ;; 上書きして問題ない（2026-11-24、Muse VM で確認）。
                   "LDFLAGS=-Wl,--copy-dt-needed-entries"
                   ;; shirudo-build へ埋め込む clang（上記コメント参照）。
                   ;; native-inputs でのラベルはパッケージ名の "clang"。
                   (string-append "SHIRUDO_CLANG_PATH="
                                  #$(this-package-native-input "clang")
                                  "/bin/clang")
                   ;; 上流が用意した逃げ道。Guix の新しい gcc の警告で
                   ;; ビルドが落ちないようにする。
                   "WERROR=0"
                   ;; quote-check の静的 OpenSSL 自前ビルドを止める
                   ;; （上記コメント参照）。
                   "QUOTE_CHECK_OPENSSL="
                   ;; BTF の供給（上記 %shirudo-ci-kernel-zip 参照）。
                   ;; supply-vmlinux-btf フェーズがビルド直下に置いた
                   ;; ファイルを相対パスで指す。
                   "BPF_VMLINUX_BTF=vmlinux.btf"
                   )
           #:phases
           #~(modify-phases %standard-phases
               ;; shirudo に ./configure は無い。設定の探査は上流の
               ;; make が Makefile.config で行う方式なので、標準の
               ;; configure フェーズは消す（残すと 127 で落ちる。
               ;; 2026-11-24、Muse VM で確認）。
               (delete 'configure)
               (add-before 'build 'supply-vmlinux-btf
                 (lambda* (#:key native-inputs inputs #:allow-other-keys)
                   ;; CI カーネルの zip から vmlinux.btf だけを取り出し、
                   ;; ビルドディレクトリ直下に置く（make フラグで
                   ;; 相対パス指定している）。
                   (invoke "sh" "-c"
                           (string-append
                            "unzip -p "
                            (assoc-ref (or native-inputs inputs)
                                       "kernel-packages-x86-64-ci.zip")
                            " '*/vmlinux-7.4-shirudo-ci-20261123.btf'"
                            " > vmlinux.btf"))))
               (replace 'install
                 (lambda* (#:key make-flags #:allow-other-keys)
                   ;; 既定の install は bin/shirudo と bash 補完だけ。
                   ;; operator 一式（libexec/shirudo/shirudo-build、
                   ;; bin/shirudo-quote-check、gen-image 一式、
                   ;; share/shirudo/vmlinux.h、BPF ヘッダ）は
                   ;; install-operator で入れる。
                   (apply invoke "make" "install-operator" make-flags))))))
    (native-inputs
     (list clang-23
           llvm-23          ; llvm-strip 等の LLVM ツール
           pkg-config
           unzip            ; CI カーネル zip から BTF を取り出す
           ;; origin は素で入れるとファイル名がラベルになる
           ;; （guix/packages.scm の add-input-label の origin 節）。
           ;; (list "ラベル" origin) 形式は、リストの先頭要素が
           ;; ラベル付きでないと sanitize に弾かれて ("_" (...)) に
           ;; 包まれる（2026-11-24、Muse VM で特定）。
           %shirudo-ci-kernel-zip))
    (inputs
     (list curl
           elfutils
           (list glibc "static")   ; quote-check の -static-pie 用
           luajit
           openssl
           (list openssl "static") ; quote-check の libcrypto.a 用
           tpm2-tss-4
           zlib))
    (home-page "https://github.com/shirudo-dev/shirudo")
    (synopsis "BPF-based security platform for Linux")
    (description
     "Shirudo is a BPF-based security platform for Linux.  Once boot-time
initialization completes, it restricts the @code{bpf()} system call to
signed loaders, applies signed live patches (@dfn{upatches}) to a running
system, and produces TPM-signed evidence of the system's state.")
    (license license:bsd-2)))
