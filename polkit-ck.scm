;;; polkit-ck.scm -- seatd のまま polkit 認証を通すためのパッケージ定義
;;;
;;; myguixpack チャンネル用のモジュール。Guix 本体には無い ConsoleKit2 と、
;;; session_tracking=ConsoleKit でビルドした polkit の変種 (polkit/ck) を
;;; 定義する。elogind を消した seatd 運用では polkit のセッション照合が
;;; "No session for cookie" で落ちるため、台帳係だけを ConsoleKit2 に
;;; 任せる構成。
;;;
;;; 注意: 叩き台 (未検証)。consolekit2 の sha256 はプレースホルダで、
;;; 採用時に guix hash で確定すること。

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
  #:use-module (gnu packages gtk-doc)
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
        ;; プレースホルダ。採用時に下記で得た値へ置き換えること。
        ;;   git clone https://github.com/ConsoleKit2/ConsoleKit2
        ;;   guix hash -rx ConsoleKit2
        (base32 "0000000000000000000000000000000000000000000000000000"))))
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
                   (invoke "autoreconf" "-vfi"))))))
    (native-inputs
     ;; autoreconf 時に configure.ac が参照するマクロの供給元。
     ;; マクロ不足で転んだら、不足分をここへ足す (README.md 参照)。
     (list autoconf
           automake
           libtool
           intltool
           gettext-minimal
           gtk-doc
           gobject-introspection
           pkg-config))
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
