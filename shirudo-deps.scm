;;; shirudo-deps.scm --- shirudo のために先に入れる依存パッケージ
;;;
;;; TPM2 Software Stack (tpm2-tss) の 4.x 系。
;;;
;;; 背景: Guix 本家の tpm2-tss は 3.0.3 だが、shirudo は
;;; tss2-esys >= 4.0 を要求する（上流 shirudo の Makefile.config の
;;; pkg-config 検査より）。本家の定義を inherit して、版数・ソース・
;;; 入力だけを差し替える。
;;;
;;; 版数の選択: shirudo 自身の target-deps は tpm2-tss 4.2.0 を
;;; ソースからビルドして固定しているが、ここでは最新の 4.2.x である
;;; 4.2.2（2026-11-12 リリース、タグはコミット bcc9cda）を採用した。
;;; 「tss2-esys >= 4.0」の下限は満たす。厳密に上流の固定へ寄せたい
;;; 場合は version と sha256 を 4.2.0 のものに差し替えること。
;;;
;;; 3.0.3 との差分（4.2.2 の configure.ac を実読して確認）:
;;;   * FAPI / policy が有効なとき（既定で有効）に pkg-config の
;;;     "uuid"（libuuid）が必須になった。3.0.3 の configure.ac には
;;;     この検査はない。
;;;     → util-linux の "lib" 出力を inputs に追加する。
;;;   * json-c は >= 0.13 が明示された（本家の入力の json-c で
;;;     足りる想定。未検証）。
;;;   * libcrypto の下限は >= 1.1.0 のままで、Guix の openssl で足りる。
;;;   * libusb / libftdi の検査は任意機能（tcti-spi-ftdi 等）向けで、
;;;     既定では無効なので入力には足していない。
;;;
;;; ハッシュ: 配布 tarball tpm2-tss-4.2.2.tar.gz（make dist 形式で
;;; configure 同梱）を実際にダウンロードして sha256 を実測し、
;;; Guix 形式 base32 へ変換した値。変換は本家 3.0.3 の既知ハッシュ
;;; （05xynpwq…）と一致することで検証済み。
;;;   sha256 (hex): bd4efc89ee01aca8ff771cae268d84333b7594c2d4afee50bb13b859f1113c3f
;;;
;;; 注意: 2026-11-24、Muse VM の Guix（063d1af）でビルド成功を確認済み。
;;; tss2-esys.pc の Version は 4.2.2。初回の取得は GitHub の署名付き
;;; URL の期限切れ（618 jwt:expired）で落ち、再試行で通過した。

(define-module (shirudo-deps)
  #:use-module (gnu packages hardware)    ; tpm2-tss（本家 3.0.3）
  #:use-module (gnu packages linux)       ; util-linux（libuuid）
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public tpm2-tss-4
  (package/inherit tpm2-tss
    (version "4.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/tpm2-software/tpm2-tss"
                           "/releases/download/" version "/tpm2-tss-"
                           version ".tar.gz"))
       (sha256
        (base32 "0grw27qmkf0kpd8fxbylqaa7afrkhj6jdbhwfzzsib01xs4zqkmx"))))
    (inputs
     ;; 4.x で追加された libuuid 要求（上記コメント参照）。
     ;; 入力の形式は (ラベル パッケージ 出力) の3要素。
     ;; modify-inputs の append では、追加分が ("_" (...)) と
     ;; 包まれて invalid input になったため（2026-11-24、Muse VM の
     ;; Guix 063d1af で確認）、単純な append で足す。
     (append (package-inputs tpm2-tss)
             (list (list "util-linux" util-linux "lib"))))))
