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

(define-module (cybersecurity)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages java)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages check)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages time)
  #:use-module (gnu packages bioinformatics)      ;python-intervaltree
  #:use-module (gnu packages emulators)
  #:use-module (engineering))

(define-public blacksmith
  (package
    (name "blacksmith")
    (version "0.0.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/comsec-group/blacksmith")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0kyp71wndf527dgza5iks5m5vj543mvxp5w7cjd8x0pilmd1xrls"))
              (modules '((guix build utils)))
              (snippet `(begin
                          (delete-file-recursively "external")
                          (substitute* "CMakeLists.txt"
                            (("add_subdirectory\\(external\\)") "")
                            (("[ \t]*FetchContent_MakeAvailable\\(asmjit\\)")
                             (string-append
                              "find_package(asmjit)\n"
                              "find_package(nlohmann_json)")))))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                      ;no test-suite
       #:imported-modules
       ((guix build copy-build-system)
        ,@%cmake-build-system-modules)
       #:modules
       (((guix build copy-build-system) #:prefix copy:)
        (guix build cmake-build-system)
        (guix build utils))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-build
           (lambda _
             (substitute* "CMakeLists.txt"
               ;; Use default C++ standard instead.
               (("cxx_std_17") "")
               ;; This project tries to link argagg library, which doesn't
               ;; exist, as argagg project is a single header file.
               (("argagg") ""))))
         (replace 'install
           (lambda args
             (apply (assoc-ref copy:%standard-phases 'install)
                    #:install-plan
                    '(("." "bin" #:include ("blacksmith"))
                      ("." "lib" #:include-regexp ("\\.a$")))
                    args))))))
    (native-inputs
     (list pkg-config))
    (inputs
     (list argagg asmjit nlohmann-json))
    (home-page "https://comsec.ethz.ch/research/dram/blacksmith")
    (synopsis "Rowhammer fuzzer with non-uniform and frequency-based patterns")
    (description
     "Blacksmith is an implementation of Rowhammer fuzzer that crafts novel
non-uniform Rowhammer access patterns based on the concepts of frequency,
phase, and amplitude.  It is able to bypass recent @acronym{TRR, Target Row
Refresh}in-DRAM mitigations effectively and as such can trigger bit flips.")
    (license license:expat)))

(define-public python-colored-traceback
  (package
    (name "python-colored-traceback")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "colored-traceback" version))
       (sha256
        (base32 "018vj5r9hzd7brhw914sdnxw89spp4av89y9ajxzcsd83lmwx9vd"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-pygments))
    (home-page "http://www.github.com/staticshock/colored-traceback.py")
    (synopsis "Automatically color uncaught exception tracebacks")
    (description "Automatically color uncaught exception tracebacks")
    (license #f)))

(define-public python-ropgadget
  (package
    (name "python-ropgadget")
    (version "7.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ROPGadget" version))
       (sha256
        (base32 "0brlb5sh22zvzmdsp17cwa1bmdxj45if297gj9hx0rzq5jijc1m4"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-capstone))
    (home-page "https://github.com/JonathanSalwan/ROPgadget")
    (synopsis
     "This tool lets you search your gadgets on your binaries to facilitate your ROP exploitation.")
    (description
     "This tool lets you search your gadgets on your binaries to facilitate your ROP
exploitation.")
    (license license:bsd-3)))

(define-public python-rpyc
  (package
    (name "python-rpyc")
    (version "5.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "rpyc" version))
       (sha256
        (base32 "0lmzrxc6f0sg6k0yvi6f2z44dkhiankdadv44sp1ibwzhxs328zj"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-plumbum))
    (home-page "")
    (synopsis
     "Remote Python Call (RPyC) is a transparent and symmetric distributed computing library")
    (description
     "Remote Python Call (R@code{PyC}) is a transparent and symmetric distributed
computing library")
    (license #f)))

(define-public python-unicorn
  (package
    (name "python-unicorn")
    (version "2.0.1.post1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "unicorn" version))
       (sha256
        (base32 "0mlfs8qfi0clyncfkbxp6in0cpl747510i6bqymwid43xcirbikz"))))
    (build-system pyproject-build-system)
    (home-page "http://www.unicorn-engine.org")
    (synopsis "Unicorn CPU emulator engine")
    (description "Unicorn CPU emulator engine")
    (license #f)))

(define-public pwntools
  (package
    (name "pwntools")
    (version "4.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pwntools" version))
       (sha256
        (base32
         "19iz4ymhna1qwg90zh86h4ffyvh07m9f2xfi47i92grlgxviwpx8"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f))                 ;XXX: needs a specific version of unicorn
    (propagated-inputs
     (list python-capstone
           python-colored-traceback
           python-intervaltree
           python-mako
           python-packaging
           python-paramiko
           python-pathlib2
           python-pip
           python-psutil
           python-pyelftools
           python-pygments
           python-pyserial
           python-pysocks
           python-dateutil
           python-requests
           python-ropgadget
           python-rpyc
           python-six
           python-sortedcontainers
           python-unicorn))
    (home-page "https://github.com/Gallopsled/pwntools")
    (synopsis
     "Capture-the-flag (CTF) framework and exploit development library")
    (description
     "Pwntools is a capture-the-flag (CTF) framework and exploit development library.
Written in Python, it is designed for rapid prototyping and development, and
intended to make exploit writing as simple as possible.")
    (license license:expat)))

(define-public guile-z3
  (package
    (name "guile-z3")
    (version "master")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://framagit.org/tyreunom/guile-z3")
             (commit version)))
       (sha256
        (base32 "14v0vx5g5fx9nx17919vsf082fzcfpj8clbswprq5f3pklycm0xm"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:configure-flags #~(list (string-append "Z3_LIBDIR="
                                               #$z3 "/lib"))))
    (propagated-inputs (list z3 guile-3.0))
    (native-inputs (list pkg-config autoconf automake m4))
    (home-page "https://framagit.org/tyreunom/guile-z3")
    (synopsis "Guile Z3 Bindings")
    (description
     "This project aims to give GNU Guile users a
very simple library to use Z3, the theorem prover.  Z3 itself is able to read
files formated in SMT-LIB2, which is a s-expression format.  Instead of writting
files and calling Z3, this library offers you all the benefits of using guile to
produce your expressions in software.")
    (license license:expat)))

(define-public emacs-capstone
  (package
    (name "emacs-capstone")
    (version "master")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/anticomputer/emacs-capstone")
             (commit version)))
       (sha256
        (base32 "1034pww2xzd5k1xya202dhxk0xllxynzd64bkmfhy0c1vvvm94ff"))))
    (propagated-inputs (list capstone))
    (native-inputs (list pkg-config))
    (build-system emacs-build-system)
    (arguments
     (list
      #:phases #~(modify-phases %standard-phases
                     (add-after 'check 'make
                       (lambda _
                         (invoke "make"
                                 (string-append "CAPSTONE_INC=" #$capstone "/include/capstone"))))
		     (add-after 'install 'install-lib
				(lambda* (#:key outputs #:allow-other-keys)
				  (let ((lib (string-append (assoc-ref outputs "out") "/share/emacs/site-lisp/capstone-master")))
				    (install-file "capstone-core.so" lib)
				    (install-file "capstone-core.o" lib)))))))
    (home-page "https://github.com/anticomputer/emacs-capstone")
    (synopsis
     "This is a set of elisp bindings for the capstone dissassembly library")
    (description
     "Provided because I think emacs has everything it needs to be a decent ASM navigation platform.")
    (license license:gpl2+)))

(define-public iaito
  (package
    (name "iaito")
    (version "5.8.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/radareorg/iaito")
             (commit version)))
       (sha256
        (base32 "1w0mxx1akiwfk1k6cv5bq3bspbfhhdh8nff8g9nij3r9ljkxvigy"))))
    (build-system gnu-build-system)
    (arguments `(#:tests? #f))
    ;; (arguments `(#:configure-flags '("CC=clang" "CXX=clang++")))
    (propagated-inputs (list qtbase qtsvg radare2 openssl))
    (native-inputs (list pkg-config autoconf automake m4 qttools))
    (home-page "https://github.com/radareorg/iaito")
    (synopsis "iaito is the official graphical interface for radare2, a libre reverse engineering framework.")
    (description
     "iaito is the official graphical interface for radare2, a libre reverse engineering framework.")
    (license license:gpl3+)))
