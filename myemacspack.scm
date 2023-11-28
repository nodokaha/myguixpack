;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2020 Jakub Kądziołka <kuba@kadziolka.net>
;;; Copyright © 2020, 2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2021 c4droid <c4droid@foxmail.com>
;;; Copyright © 2021 Raghav Gururajan <rg@raghavgururajan.name>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (myemacspack)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((nonguix licenses) #:prefix plicense:)
  #:use-module (guix build-system emacs))

(define-public emacs-japanese-holiday
  (package
   (name "emacs-japanese-holiday")
   (version "master")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/emacs-jp/japanese-holidays")
       (commit version)))
     (sha256
      (base32 "1bxbxczsf0b7jiim2anjh16h243khyrcv4k07qg0yy8c9zrl18aq"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/emacs-jp/japanese-holidays")
   (synopsis "Emacs japanese Holiday list")
   (description "japanese Holiday set")
   (license license:gpl2+)))

(define-public emacs-teco
  (package
   (name "emacs-teco")
   (version "master")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/mtk/teco")
       (commit version)))
     (sha256
      (base32 "0jfrlpmcr8msj39fhm0sc11sxw46w0dk24zidsdp12lwgcnli44m"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/mtk/teco")
   (synopsis "TECO was an ancient text editor written in the days before most of you reading this were born. It supported macros of editing commands as an extension mechanism. The original version of EMACS was written by loading macros into TECO that provided EMACS functionality and then saving the memory image of the combined TECO command interpreter and the macros as a new program (\"dumping an EMACS\").")
   (description "TECO was an ancient text editor written in the days before most of you reading this were born. It supported macros of editing commands as an extension mechanism. The original version of EMACS was written by loading macros into TECO that provided EMACS functionality and then saving the memory image of the combined TECO command interpreter and the macros as a new program (\"dumping an EMACS\").")
   (license license:gpl3+)))

(define-public emacs-doom-modeline-exwm
  (package
   (name "emacs-doom-modeline-exwm")
   (version "master")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/elken/doom-modeline-exwm")
       (commit version)))
     (sha256
      (base32 "0r8i6lb34yy4n3yy7c7h6f5hvyws2xihh2gh65mg9x6nz3w7kvay"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/elken/doom-modeline-exwm")
   (synopsis "doom-modeline segment for exwm")
   (description "doom-modeline segment for exwm")
   (license license:expat)))
