;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013 Cyril Roelandt <tipecaml@gmail.com>
;;; Copyright © 2014, 2015 David Thompson <davet@gnu.org>
;;; Copyright © 2014 Kevin Lemonnier <lemonnierk@ulrar.net>
;;; Copyright © 2015 Jeff Mickey <j@codemac.net>
;;; Copyright © 2016–2021 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2016 Stefan Reichör <stefan@xsteve.at>
;;; Copyright © 2017, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017, 2018 Nikita <nikita@n0.is>
;;; Copyright © 2017, 2018 Leo Famulari <leo@famulari.name>
;;; Copyright © 2017, 2021 Arun Isaac <arunisaac@systemreboot.net>
;;; Copyright © 2019 Meiyo Peng <meiyo.peng@gmail.com>
;;; Copyright © 2019 Timothy Sample <samplet@ngyro.com>
;;; Copyright © 2019 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2019, 2020, 2023 Janneke Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2020 Brice Waegeneire <brice@waegenei.re>
;;; Copyright © 2020 Ryan Prior <rprior@protonmail.com>
;;; Copyright © 2020, 2022 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2020, 2022 Marius Bakke <marius@gnu.org>
;;; Copyright © 2021, 2022 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2021, 2022 Felix Gruber <felgru@posteo.net>
;;; Copyright © 2022 Andrew Tropin <andrew@trop.in>
;;; Copyright © 2023 Zheng Junjie <873216071@qq.com>
;;; Copyright © 2023 David Pflug <david@pflug.io>
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

(define-module (nushell)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages groff)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages libbsd)
  #:use-module (gnu packages libedit)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages texinfo)
  #:use-module (cargo)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (rust))

(define-public rust-fastrand-2
  (package
    (name "rust-fastrand")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fastrand" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19flpv5zbzpf0rk4x77z4zf25in0brg8l7m304d3yrf47qvwxjr5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "https://github.com/smol-rs/fastrand")
    (synopsis "A simple and fast random number generator")
    (description
     "This package provides a simple and fast random number generator")
    (license (list license:asl2.0 license:expat))))

(define-public rust-tempfile-3
  (package
    (name "rust-tempfile")
    (version "3.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tempfile" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vsl2193w3gpx3mwj36fwx3v6q2qyvmzrdn6m8fgfsjkrkrx556b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-fastrand" ,rust-fastrand-2)
                       ("rust-redox-syscall" ,rust-redox-syscall-0.3)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://stebalien.com/projects/tempfile-rs/")
    (synopsis "A library for managing temporary files and directories.")
    (description
     "This package provides a library for managing temporary files and directories.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serial-test-derive-2
  (package
    (name "rust-serial-test-derive")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serial_test_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13zvd5ds76hhjn3z0axc05n15lzpxpz77jcykic8q5knhlbjklci"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/palfrey/serial_test/")
    (synopsis "Helper crate for serial_test")
    (description "Helper crate for serial_test")
    (license license:expat)))

(define-public rust-redox-syscall-0.4
  (package
    (name "rust-redox-syscall")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "redox_syscall" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1aiifyz5dnybfvkk4cdab9p2kmphag1yad6iknc7aszlxxldf8j7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://gitlab.redox-os.org/redox-os/syscall")
    (synopsis "A Rust library to access raw Redox system calls")
    (description
     "This package provides a Rust library to access raw Redox system calls")
    (license license:expat)))

(define-public rust-parking-lot-core-0.9
  (package
    (name "rust-parking-lot-core")
    (version "0.9.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "parking_lot_core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13h0imw1aq86wj28gxkblhkzx6z1gk8q18n0v76qmmj6cliajhjc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-petgraph" ,rust-petgraph-0.6)
                       ("rust-redox-syscall" ,rust-redox-syscall-0.4)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thread-id" ,rust-thread-id-4)
                       ("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/Amanieu/parking_lot")
    (synopsis
     "An advanced API for creating custom synchronization primitives.")
    (description
     "An advanced API for creating custom synchronization primitives.")
    (license (list license:expat license:asl2.0))))

(define-public rust-lock-api-0.4
  (package
    (name "rust-lock-api")
    (version "0.4.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lock_api" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0iggx0h4jx63xm35861106af3jkxq06fpqhpkhgw0axi2n38y5iw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-owning-ref" ,rust-owning-ref-0.4)
                       ("rust-scopeguard" ,rust-scopeguard-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Amanieu/parking_lot")
    (synopsis
     "Wrappers to create fully-featured Mutex and RwLock types. Compatible with no_std.")
    (description
     "Wrappers to create fully-featured Mutex and @code{RwLock} types.  Compatible
with no_std.")
    (license (list license:expat license:asl2.0))))

(define-public rust-dashmap-5
  (package
    (name "rust-dashmap")
    (version "5.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dashmap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0miqnlxi501vfbv6mw5jbmzgnj0wjrch3p4abvpd59s9v30lg1wp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-lock-api" ,rust-lock-api-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot-core" ,rust-parking-lot-core-0.9)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/xacrimon/dashmap")
    (synopsis "Blazing fast concurrent HashMap for Rust.")
    (description "Blazing fast concurrent @code{HashMap} for Rust.")
    (license license:expat)))

(define-public rust-serial-test-2
  (package
    (name "rust-serial-test")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serial_test" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b9v0csv9wxl1gcjq99plwimxbmhgr6kzbwqyb457qh3d22xsmhf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dashmap" ,rust-dashmap-5)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-fslock" ,rust-fslock-0.2)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-serial-test-derive" ,rust-serial-test-derive-2))))
    (home-page "https://github.com/palfrey/serial_test/")
    (synopsis "Allows for the creation of serialised Rust tests")
    (description "Allows for the creation of serialised Rust tests")
    (license license:expat)))

(define-public rust-relative-path-1
  (package
    (name "rust-relative-path")
    (version "1.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "relative-path" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jl32g41ww8pm8lbdmxm6ahagzwkz8b02q1gxzps47g1zj52j1y7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/udoprog/relative-path")
    (synopsis "Portable, relative paths for Rust.")
    (description "Portable, relative paths for Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rstest-macros-0.18
  (package
    (name "rust-rstest-macros")
    (version "0.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rstest_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01g6rg60snmscipc9xiili7nsn0v25sv64713gp99y2jg0jgha6l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-relative-path" ,rust-relative-path-1)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/la10736/rstest")
    (synopsis "Rust fixture based test framework. It use procedural macro
to implement fixtures and table based tests.
")
    (description
     "Rust fixture based test framework.  It use procedural macro to implement
fixtures and table based tests.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rstest-0.18
  (package
    (name "rust-rstest")
    (version "0.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rstest" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1681ncnlzhc8894idm3pqf40nndn4k4kcp0kpv29n68a7hpspvlp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-timer" ,rust-futures-timer-3)
                       ("rust-rstest-macros" ,rust-rstest-macros-0.18)
                       ("rust-rustc-version" ,rust-rustc-version-0.4))))
    (home-page "https://github.com/la10736/rstest")
    (synopsis "Rust fixture based test framework. It use procedural macro
to implement fixtures and table based tests.
")
    (description
     "Rust fixture based test framework.  It use procedural macro to implement
fixtures and table based tests.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pretty-assertions-1
  (package
    (name "rust-pretty-assertions")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pretty_assertions" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rmsnqlpmpfjp5gyi31xgc48kdhc1kqn246bnc494nwadhdfwz5g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-diff" ,rust-diff-0.1)
                       ("rust-yansi" ,rust-yansi-0.5))))
    (home-page
     "https://github.com/rust-pretty-assertions/rust-pretty-assertions")
    (synopsis
     "Overwrite `assert_eq!` and `assert_ne!` with drop-in replacements, adding colorful diffs.")
    (description
     "Overwrite `assert_eq!` and `assert_ne!` with drop-in replacements, adding
colorful diffs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-test-support-0.86
  (package
    (name "rust-nu-test-support")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-test-support" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1453ikw3bwmgls9qq255qip2968g2f3iz6rb7c0kq9xnzbrmb506"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hamcrest2" ,rust-hamcrest2-0.3)
                       ("rust-nu-glob" ,rust-nu-glob-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-num-format" ,rust-num-format-0.4)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-which" ,rust-which-4))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-test-support")
    (synopsis "Support for writing Nushell tests")
    (description "Support for writing Nushell tests")
    (license license:expat)))

(define-public rust-criterion-0.5
  (package
    (name "rust-criterion")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "criterion" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bv9ipygam3z8kk6k771gh9zi0j0lb9ir0xi1pc075ljg80jvcgj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anes" ,rust-anes-0.1)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-cast" ,rust-cast-0.3)
                       ("rust-ciborium" ,rust-ciborium-0.2)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-criterion-plot" ,rust-criterion-plot-0.5)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-oorandom" ,rust-oorandom-11)
                       ("rust-plotters" ,rust-plotters-0.3)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smol" ,rust-smol-1)
                       ("rust-tinytemplate" ,rust-tinytemplate-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://bheisler.github.io/criterion.rs/book/index.html")
    (synopsis "Statistics-driven micro-benchmarking library")
    (description "Statistics-driven micro-benchmarking library")
    (license (list license:asl2.0 license:expat))))

(define-public rust-winresource-0.1
  (package
    (name "rust-winresource")
    (version "0.1.17")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winresource" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0aakwh8llq2zvm7qihkrg7sz50hzccyl4x831j60g4psijpsmqkp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-toml" ,rust-toml-0.7)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://github.com/BenjaminRi/winresource")
    (synopsis "Create and set windows icons and metadata for executables")
    (description "Create and set windows icons and metadata for executables")
    (license license:expat)))

(define-public rust-simplelog-0.12
  (package
    (name "rust-simplelog")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "simplelog" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sa3hjdifxhcb9lnlg549fr2cc7vz89nygwbih2dbqsx3h20ivmc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-term" ,rust-ansi-term-0.12)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-paris" ,rust-paris-1)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/drakulix/simplelog.rs")
    (synopsis "A simple and easy-to-use logging facility for Rust's log crate")
    (description
     "This package provides a simple and easy-to-use logging facility for Rust's log
crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-std-0.86
  (package
    (name "rust-nu-std")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-std" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c2cn9jy0l86kjcwy9zlmgifwjp52iah75b2lbjd5vl72qm7ngng"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-miette" ,rust-miette-5)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-std")
    (synopsis "The standard library of Nushell")
    (description "The standard library of Nushell")
    (license license:expat)))

(define-public rust-deltae-0.3
  (package
    (name "rust-deltae")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "deltae" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d3hw9hpvicl9x0x34jr2ybjk5g5ym1lhbyz6zj31110gq8zaaap"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://gitlab.com/ryanobeirne/deltae")
    (synopsis "Calculate Delta E between two colors in CIE Lab space.")
    (description "Calculate Delta E between two colors in CIE Lab space.")
    (license license:expat)))

(define-public rust-cint-0.3
  (package
    (name "rust-cint")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cint" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16l9glvaxshbp3awcga3s8cdfv00gb1n2s7ixzxxjwc5yz6qf3ks"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "https://github.com/termhn/cint")
    (synopsis
     "A lean, minimal, and stable set of types for color interoperation between crates in Rust.")
    (description
     "This package provides a lean, minimal, and stable set of types for color
interoperation between crates in Rust.")
    (license (list license:expat license:asl2.0 license:zlib))))

(define-public rust-csscolorparser-0.6
  (package
    (name "rust-csscolorparser")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csscolorparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gxh11hajx96mf5sd0az6mfsxdryfqvcfcphny3yfbfscqq7sapb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cint" ,rust-cint-0.3)
                       ("rust-lab" ,rust-lab-0.11)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-rgb" ,rust-rgb-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/mazznoer/csscolorparser-rs")
    (synopsis "CSS color parser library")
    (description "CSS color parser library")
    (license (list license:expat license:asl2.0))))

(define-public rust-wezterm-color-types-0.2
  (package
    (name "rust-wezterm-color-types")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wezterm-color-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xvphmrqgg69v9l879xj5lq010z13f5ixi854ykmny6j7m47lvjc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-csscolorparser" ,rust-csscolorparser-0.6)
                       ("rust-deltae" ,rust-deltae-0.3)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-wezterm-dynamic" ,rust-wezterm-dynamic-0.1))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "Types for working with colors")
    (description "Types for working with colors")
    (license license:expat)))

(define-public rust-wezterm-dynamic-derive-0.1
  (package
    (name "rust-wezterm-dynamic-derive")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wezterm-dynamic-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1w07qf8njyq19nxi9vpshwprk00blhzg9ybis2rhfba433rmx7qc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis
     "config serialization for wezterm via dynamic json-like data values")
    (description
     "config serialization for wezterm via dynamic json-like data values")
    (license license:expat)))

(define-public rust-wezterm-dynamic-0.1
  (package
    (name "rust-wezterm-dynamic")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wezterm-dynamic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1al8fmfr852m62mlcr0v2lg3a18icl2sv79zv7jnv9v0rk07hpm7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-ordered-float" ,rust-ordered-float-3)
                       ("rust-strsim" ,rust-strsim-0.10)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-wezterm-dynamic-derive" ,rust-wezterm-dynamic-derive-0.1))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis
     "config serialization for wezterm via dynamic json-like data values")
    (description
     "config serialization for wezterm via dynamic json-like data values")
    (license license:expat)))

(define-public rust-wezterm-bidi-0.2
  (package
    (name "rust-wezterm-bidi")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wezterm-bidi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dkcwscvlwnv6lnagxfb08rcd21gfyrxbr7afcjaj3wvycn3hq0m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-wezterm-dynamic" ,rust-wezterm-dynamic-0.1))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "The Unicode Bidi Algorithm (UBA)")
    (description "The Unicode Bidi Algorithm (UBA)")
    (license (list license:expat ))))

(define-public rust-vtparse-0.6
  (package
    (name "rust-vtparse")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vtparse" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l5yz9650zhkaffxn28cvfys7plcw2wd6drajyf41pshn37jm6vd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-utf8parse" ,rust-utf8parse-0.2))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "Low level escape sequence parser")
    (description "Low level escape sequence parser")
    (license license:expat)))

(define-public rust-memmem-0.1
  (package
    (name "rust-memmem")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memmem" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "05ccifqgxdfxk6yls41ljabcccsz3jz6549l1h3cwi17kr494jm6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "http://github.com/jneem/memmem")
    (synopsis "Substring searching")
    (description "Substring searching")
    (license (list license:expat license:asl2.0))))

(define-public rust-finl-unicode-1
  (package
    (name "rust-finl-unicode")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "finl_unicode" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ipdx778849czik798sjbgk5yhwxqybydac18d2g9jb20dxdrkwg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://finl.xyz")
    (synopsis
     "Library for handling Unicode functionality for finl (categories and grapheme segmentation)")
    (description
     "Library for handling Unicode functionality for finl (categories and grapheme
segmentation)")
    (license (list license:expat license:asl2.0))))

(define-public rust-termwiz-0.20
  (package
    (name "rust-termwiz")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "termwiz" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yj80sli95wcw0im2iic9h7mx20hms3f9shxk7jarjqgl5waj2cm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-cassowary" ,rust-cassowary-0.3)
                       ("rust-filedescriptor" ,rust-filedescriptor-0.8)
                       ("rust-finl-unicode" ,rust-finl-unicode-1)
                       ("rust-fixedbitset" ,rust-fixedbitset-0.4)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-image" ,rust-image-0.24)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memmem" ,rust-memmem-0.1)
                       ("rust-nix" ,rust-nix-0.24)
                       ("rust-num-derive" ,rust-num-derive-0.3)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-ordered-float" ,rust-ordered-float-3)
                       ("rust-pest" ,rust-pest-2)
                       ("rust-pest-derive" ,rust-pest-derive-2)
                       ("rust-phf" ,rust-phf-0.10)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-semver" ,rust-semver-0.11)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha2" ,rust-sha2-0.9)
                       ("rust-signal-hook" ,rust-signal-hook-0.1)
                       ("rust-siphasher" ,rust-siphasher-0.3)
                       ("rust-terminfo" ,rust-terminfo-0.7)
                       ("rust-termios" ,rust-termios-0.3)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-ucd-trie" ,rust-ucd-trie-0.1)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-vtparse" ,rust-vtparse-0.6)
                       ("rust-wezterm-bidi" ,rust-wezterm-bidi-0.2)
                       ("rust-wezterm-color-types" ,rust-wezterm-color-types-0.2)
                       ("rust-wezterm-dynamic" ,rust-wezterm-dynamic-0.1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "Terminal Wizardry for Unix and Windows")
    (description "Terminal Wizardry for Unix and Windows")
    (license license:expat)))

(define-public rust-ratatui-0.23
  (package
    (name "rust-ratatui")
    (version "0.23.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ratatui" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1bcnzzvlzdqn1h961zdi0l13x97fakq3xrj68hxmra4labclqbif"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cassowary" ,rust-cassowary-0.3)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-indoc" ,rust-indoc-2)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-strum" ,rust-strum-0.25)
                       ("rust-termion" ,rust-termion-2)
                       ("rust-termwiz" ,rust-termwiz-0.20)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/ratatui-org/ratatui")
    (synopsis "A library that's all about cooking up terminal user interfaces")
    (description
     "This package provides a library that's all about cooking up terminal user
interfaces")
    (license license:expat)))

(define-public rust-nu-explore-0.86
  (package
    (name "rust-nu-explore")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-explore" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mlwzws1mm182i2s9jdrf6bh8my3p3yx5k3g29861ylkq40s655g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-str" ,rust-ansi-str-0.8)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-lscolors" ,rust-lscolors-0.15)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-color-config" ,rust-nu-color-config-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-json" ,rust-nu-json-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-table" ,rust-nu-table-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-ratatui" ,rust-ratatui-0.23)
                       ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.2)
                       ("rust-terminal-size" ,rust-terminal-size-0.2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-explore")
    (synopsis "Nushell table pager")
    (description "Nushell table pager")
    (license license:expat)))

(define-public rust-winreg-0.51
  (package
    (name "rust-winreg")
    (version "0.51.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winreg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z48nmaskwsiyyq9576sgf8ya3fvf1xg3kma8q7n8ml1jkvkszwk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/gentoo90/winreg-rs")
    (synopsis "Rust bindings to MS Windows Registry API")
    (description "Rust bindings to MS Windows Registry API")
    (license license:expat)))

(define-public rust-windows-interface-0.48
  (package
    (name "rust-windows-interface")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-interface" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1iqcilw0hfyzwhk12xfmcy40r10406sgf4xmdansijlv1kr8vyz6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The interface macro for the windows crate")
    (description "The interface macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-implement-0.48
  (package
    (name "rust-windows-implement")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-implement" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1764n853zd7bb0wn94i0qxfs6kdy7wrz7v9qhdn7x7hvk64fabjy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The implement macro for the windows crate")
    (description "The implement macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-0.48
  (package
    (name "rust-windows")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03vh89ilnxdxdh0n9np4ns4m10fvm93h3b0cc05ipg3qq1mqi1p6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-implement" ,rust-windows-implement-0.48)
                       ("rust-windows-interface" ,rust-windows-interface-0.48)
                       ("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-which-4
  (package
    (name "rust-which")
    (version "4.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "which" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ixzmx3svsv5hbdvd8vdhd3qwvf6ns8jdpif1wmwsy10k90j9fl7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-home" ,rust-home-0.5)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rustix" ,rust-rustix-0.38))))
    (home-page "https://github.com/harryfei/which-rs.git")
    (synopsis
     "A Rust equivalent of Unix command \"which\". Locate installed executable in cross platforms.")
    (description
     "This package provides a Rust equivalent of Unix command \"which\".  Locate
installed executable in cross platforms.")
    (license license:expat)))

(define-public rust-vec1-1
  (package
    (name "rust-vec1")
    (version "1.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vec1" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p4xrrgqpzxlg7q74aqwxgsyfjsz0ppfgabqqahyj7rkr90prnib"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "https://github.com/rustonaut/vec1/")
    (synopsis "a std Vec wrapper assuring that it has at least 1 element")
    (description "a std Vec wrapper assuring that it has at least 1 element")
    (license (list license:expat license:asl2.0))))

(define-public rust-tardar-0.1
  (package
    (name "rust-tardar")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tardar" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "05imkznxr59dqp0s37i7qkrpyjx2zz9lmxy8ijcvka5nhcpr834h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-miette" ,rust-miette-5)
                       ("rust-vec1" ,rust-vec1-1))))
    (home-page "https://github.com/olson-sean-k/tardar")
    (synopsis "Extensions for diagnostic error handling with `miette`.")
    (description "Extensions for diagnostic error handling with `miette`.")
    (license license:expat)))

(define-public rust-pori-0.0.0
  (package
    (name "rust-pori")
    (version "0.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pori" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01p9g4fn3kasnmwj8i4plzk6nnnk7ak2qsfcv9b9y4zcilrkv9m4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nom" ,rust-nom-7))))
    (home-page "https://github.com/olson-sean-k/pori")
    (synopsis "Parser state and error extensions for nom.")
    (description "Parser state and error extensions for nom.")
    (license license:expat)))

(define-public rust-wax-0.6
  (package
    (name "rust-wax")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mqk9qxsjlbwnjnj0gkaa29qm3mmgbgrc6pd4qpjvcmsl25af4ld"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-format" ,rust-const-format-0.2)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-pori" ,rust-pori-0.0.0)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-tardar" ,rust-tardar-0.1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/olson-sean-k/wax")
    (synopsis
     "Opinionated and portable globs that can be matched against paths and directory trees.")
    (description
     "Opinionated and portable globs that can be matched against paths and directory
trees.")
    (license license:expat)))

(define-public rust-xattr-1
  (package
    (name "rust-xattr")
    (version "1.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "xattr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11b93igkwsq88b6m14x63c13zns418njh6ngvg2fbwqzyw4n0s7l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/Stebalien/xattr")
    (synopsis "unix extended filesystem attributes")
    (description "unix extended filesystem attributes")
    (license (list license:expat license:asl2.0))))

(define-public rust-z85-3
  (package
    (name "rust-z85")
    (version "3.0.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "z85" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z10407jwvjfzpzaxwxgqsm9vcbyldzzh2qz2b0ijy2h3fprsn9a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/decafbad/z85")
    (synopsis
     "Rust implementation of ZeroMQ's Z85 encoding mechanism with padding.")
    (description
     "Rust implementation of @code{ZeroMQ's} Z85 encoding mechanism with padding.")
    (license (list license:expat license:asl2.0))))

(define-public rust-winapi-util-0.1
  (package
    (name "rust-winapi-util")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winapi-util" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15i5lm39wd44004i9d5qspry2cynkrpvwzghr6s2c3dsk28nz7pj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/BurntSushi/winapi-util")
    (synopsis "A dumping ground for high level safe wrappers over winapi.")
    (description
     "This package provides a dumping ground for high level safe wrappers over winapi.")
    (license (list license:unlicense license:expat))))

(define-public rust-wild-2
  (package
    (name "rust-wild")
    (version "2.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wild" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rqblf9sbfqvhgmihmh3iav5cs1i3psr4lpradd12njdm4qikl0h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-glob" ,rust-glob-0.3))))
    (home-page "https://lib.rs/crates/wild")
    (synopsis "Glob (wildcard) expanded command-line arguments on Windows")
    (description "Glob (wildcard) expanded command-line arguments on Windows")
    (license (list license:asl2.0 license:expat))))

(define-public rust-walkdir-2
  (package
    (name "rust-walkdir")
    (version "2.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "walkdir" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vjl9fmfc4v8k9ald23qrpcbyb8dl1ynyq8d516cm537r1yqa7fp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-same-file" ,rust-same-file-1)
                       ("rust-winapi-util" ,rust-winapi-util-0.1))))
    (home-page "https://github.com/BurntSushi/walkdir")
    (synopsis "Recursively walk a directory.")
    (description "Recursively walk a directory.")
    (license (list license:unlicense license:expat))))

(define-public rust-uuhelp-parser-0.0.22
  (package
    (name "rust-uuhelp-parser")
    (version "0.0.22")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uuhelp_parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19ji4019k9pfw0hjdznxx522d3k4zvldrqk3pfxd6lkdwcqigrkd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "")
    (synopsis
     "A collection of functions to parse the markdown code of help files")
    (description
     "This package provides a collection of functions to parse the markdown code of
help files")
    (license license:expat)))

(define-public rust-uucore-procs-0.0.22
  (package
    (name "rust-uucore-procs")
    (version "0.0.22")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uucore_procs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d7aicpsy0b2nxjn5f9nvbixiw1yrcxgkbxfyi4cz1ii4pwgf7hw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-uuhelp-parser" ,rust-uuhelp-parser-0.0.22))))
    (home-page "https://github.com/uutils/coreutils")
    (synopsis "uutils ~ 'uucore' proc-macros")
    (description "uutils ~ uucore proc-macros")
    (license license:expat)))

(define-public rust-sm3-0.4
  (package
    (name "rust-sm3")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sm3" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0q2qn4d7qhd8v5grr0xdq9jv3likcr2i8nnqqhxy79yh0avs7fgb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-digest" ,rust-digest-0.10))))
    (home-page "https://github.com/RustCrypto/hashes")
    (synopsis "SM3 (OSCCA GM/T 0004-2012) hash function")
    (description "SM3 (OSCCA GM/T 0004-2012) hash function")
    (license (list license:expat license:asl2.0))))

(define-public rust-sha2-0.10
  (package
    (name "rust-sha2")
    (version "0.10.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sha2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j1x78zk9il95w9iv46dh9wm73r6xrgj32y6lzzw7bxws9dbfgbr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-sha2-asm" ,rust-sha2-asm-0.6))))
    (home-page "https://github.com/RustCrypto/hashes")
    (synopsis "Pure Rust implementation of the SHA-2 hash function family
including SHA-224, SHA-256, SHA-384, and SHA-512.
")
    (description
     "Pure Rust implementation of the SHA-2 hash function family including SHA-224,
SHA-256, SHA-384, and SHA-512.")
    (license (list license:expat license:asl2.0))))

(define-public rust-sha1-0.10
  (package
    (name "rust-sha1")
    (version "0.10.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sha1" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fnnxlfg08xhkmwf2ahv634as30l1i3xhlhkvxflmasi5nd85gz3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-sha1-asm" ,rust-sha1-asm-0.5))))
    (home-page "https://github.com/RustCrypto/hashes")
    (synopsis "SHA-1 hash function")
    (description "SHA-1 hash function")
    (license (list license:expat license:asl2.0))))

(define-public rust-os-display-0.1
  (package
    (name "rust-os-display")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "os_display" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xfgfqvfg5nyidv5p85fb87l0mif1nniisxarw6npd4jv2x2jqks"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/blyxxyz/os_display")
    (synopsis "Display strings in a safe platform-appropriate way")
    (description "Display strings in a safe platform-appropriate way")
    (license license:expat)))

(define-public rust-md-5-0.10
  (package
    (name "rust-md-5")
    (version "0.10.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "md-5" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kvq5rnpm4fzwmyv5nmnxygdhhb2369888a06gdc9pxyrzh7x7nq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-md5-asm" ,rust-md5-asm-0.5))))
    (home-page "https://github.com/RustCrypto/hashes")
    (synopsis "MD5 hash function")
    (description "MD5 hash function")
    (license (list license:expat license:asl2.0))))

(define-public rust-glob-0.3
  (package
    (name "rust-glob")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glob" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16zca52nglanv23q5qrwd5jinw3d3as5ylya6y1pbx47vkxvrynj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-lang/glob")
    (synopsis
     "Support for matching file paths against Unix shell style patterns.
")
    (description
     "Support for matching file paths against Unix shell style patterns.")
    (license (list license:expat license:asl2.0))))

(define-public rust-dns-lookup-2
  (package
    (name "rust-dns-lookup")
    (version "2.0.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dns-lookup" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z74n2zij2gahycabm0gkmkyx574h76gwk7sz93yqpr3qa3n0xp5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/keeperofdakeys/dns-lookup/")
    (synopsis
     "A simple dns resolving api, much like rust's unstable api. Also includes getaddrinfo and getnameinfo wrappers for libc variants.")
    (description
     "This package provides a simple dns resolving api, much like rust's unstable api.
 Also includes getaddrinfo and getnameinfo wrappers for libc variants.")
    (license (list license:expat license:asl2.0))))

(define-public rust-digest-0.10
  (package
    (name "rust-digest")
    (version "0.10.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "digest" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-blobby" ,rust-blobby-0.3)
                       ("rust-block-buffer" ,rust-block-buffer-0.10)
                       ("rust-const-oid" ,rust-const-oid-0.9)
                       ("rust-crypto-common" ,rust-crypto-common-0.1)
                       ("rust-subtle" ,rust-subtle-2))))
    (home-page "https://github.com/RustCrypto/traits")
    (synopsis
     "Traits for cryptographic hash functions and message authentication codes")
    (description
     "Traits for cryptographic hash functions and message authentication codes")
    (license (list license:expat license:asl2.0))))

(define-public rust-data-encoding-macro-internal-0.1
  (package
    (name "rust-data-encoding-macro-internal")
    (version "0.1.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "data-encoding-macro-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wppwhrpg25zdcvyshvb6ximcr1wrinipzfpq6g56qz87k73zpwg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/ia0/data-encoding")
    (synopsis "Internal library for data-encoding-macro")
    (description "Internal library for data-encoding-macro")
    (license license:expat)))

(define-public rust-data-encoding-macro-0.1
  (package
    (name "rust-data-encoding-macro")
    (version "0.1.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "data-encoding-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16dvya8kib5gazblxml2rahg98q87n0anmj9xapf2c01qqyb6169"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-data-encoding-macro-internal" ,rust-data-encoding-macro-internal-0.1))))
    (home-page "https://github.com/ia0/data-encoding")
    (synopsis "Macros for data-encoding")
    (description "Macros for data-encoding")
    (license license:expat)))

(define-public rust-arrayvec-0.7
  (package
    (name "rust-arrayvec")
    (version "0.7.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrayvec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04b7n722jij0v3fnm3qk072d5ysc2q30rl9fz33zpfhzah30mlwn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/bluss/arrayvec")
    (synopsis
     "A vector with fixed capacity, backed by an array (it can be stored on the stack too). Implements fixed capacity ArrayVec and ArrayString.")
    (description
     "This package provides a vector with fixed capacity, backed by an array (it can
be stored on the stack too).  Implements fixed capacity @code{ArrayVec} and
@code{ArrayString}.")
    (license (list license:expat license:asl2.0))))

(define-public rust-blake3-1
  (package
    (name "rust-blake3")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "blake3" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11ysh12zcqq6xkjxh5cbrmnwzalprm3z552i5ff7wm5za9hz0c82"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-constant-time-eq" ,rust-constant-time-eq-0.3)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-memmap2" ,rust-memmap2-0.7)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/BLAKE3-team/BLAKE3")
    (synopsis "the BLAKE3 hash function")
    (description "the BLAKE3 hash function")
    (license (list license:cc0 license:asl2.0))))

(define-public rust-constant-time-eq-0.3
  (package
    (name "rust-constant-time-eq")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "constant_time_eq" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hl0y8frzlhpr58rh8rlg4bm53ax09ikj2i5fk7gpyphvhq4s57p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/cesarb/constant_time_eq")
    (synopsis "Compares two equal-sized byte strings in constant time.")
    (description "Compares two equal-sized byte strings in constant time.")
    (license (list license:cc0 license:expat-0 license:asl2.0))))

(define-public rust-blake2b-simd-1
  (package
    (name "rust-blake2b-simd")
    (version "1.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "blake2b_simd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "102pfciq6g59hf47gv6kix42cgpqw8pjyf9hx0r3jyb94b9mla13"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-constant-time-eq" ,rust-constant-time-eq-0.3))))
    (home-page "https://github.com/oconnor663/blake2_simd")
    (synopsis "a pure Rust BLAKE2b implementation with dynamic SIMD")
    (description "a pure Rust BLAKE2b implementation with dynamic SIMD")
    (license license:expat)))

(define-public rust-uucore-0.0.22
  (package
    (name "rust-uucore")
    (version "0.0.22")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uucore" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04cdc6fyk0mrbpb93wl7q8yrhi39gydzk2phf1p6a82ds8v2qarl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-blake2b-simd" ,rust-blake2b-simd-1)
                       ("rust-blake3" ,rust-blake3-1)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-data-encoding-macro" ,rust-data-encoding-macro-0.1)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-dns-lookup" ,rust-dns-lookup-2)
                       ("rust-dunce" ,rust-dunce-1)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-md-5" ,rust-md-5-0.10)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-nix" ,rust-nix-0.27)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-os-display" ,rust-os-display-0.1)
                       ("rust-sha1" ,rust-sha1-0.10)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-sha3" ,rust-sha3-0.10)
                       ("rust-sm3" ,rust-sm3-0.4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-uucore-procs" ,rust-uucore-procs-0.0.22)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-wild" ,rust-wild-2)
                       ("rust-winapi-util" ,rust-winapi-util-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48)
                       ("rust-z85" ,rust-z85-3))))
    (home-page "https://github.com/uutils/coreutils")
    (synopsis "uutils ~ 'core' uutils code library (cross-platform)")
    (description "uutils ~ core uutils code library (cross-platform)")
    (license license:expat)))

(define-public rust-bindgen-0.66
  (package
    (name "rust-bindgen")
    (version "0.66.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bindgen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19yj6fsb08x0l1pg871vvfvlx1mglamz8hyjpazhfc90zh34xf7j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-annotate-snippets" ,rust-annotate-snippets-0.9)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cexpr" ,rust-cexpr-0.6)
                       ("rust-clang-sys" ,rust-clang-sys-1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-lazycell" ,rust-lazycell-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-peeking-take-while" ,rust-peeking-take-while-0.1)
                       ("rust-prettyplease" ,rust-prettyplease-0.2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-shlex" ,rust-shlex-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-which" ,rust-which-4))))
    (home-page "https://rust-lang.github.io/rust-bindgen/")
    (synopsis
     "Automatically generates Rust FFI bindings to C and C++ libraries.")
    (description
     "Automatically generates Rust FFI bindings to C and C++ libraries.")
    (license license:bsd-3)))

(define-public rust-selinux-sys-0.6
  (package
    (name "rust-selinux-sys")
    (version "0.6.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "selinux-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hbgs3081gpwczsfhancs0ivf4lfljk78qazwibqq91hb4w04rnm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.66)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-dunce" ,rust-dunce-1)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/koutheir/selinux-sys")
    (synopsis "Flexible Mandatory Access Control (MAC) for Linux")
    (description "Flexible Mandatory Access Control (MAC) for Linux")
    (license license:expat)))

(define-public rust-reference-counted-singleton-0.1
  (package
    (name "rust-reference-counted-singleton")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "reference-counted-singleton" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13r2p2d408ci11s8pjxjaxv8znil0rfpaggcn75xv27bswjvzgzi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/koutheir/reference-counted-singleton")
    (synopsis
     "Reference-counted singleton whose protected data can be recreated as needed")
    (description
     "Reference-counted singleton whose protected data can be recreated as needed")
    (license license:expat)))

(define-public rust-selinux-0.4
  (package
    (name "rust-selinux")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "selinux" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f3i0zlifzrvxs4yrddbj91fwavgg0vwbdxikjjifjmxf3cr3c40"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-reference-counted-singleton" ,rust-reference-counted-singleton-0.1)
                       ("rust-selinux-sys" ,rust-selinux-sys-0.6)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/koutheir/selinux")
    (synopsis "Flexible Mandatory Access Control for Linux")
    (description "Flexible Mandatory Access Control for Linux")
    (license license:expat)))

(define-public rust-exacl-0.11
  (package
    (name "rust-exacl")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "exacl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17vd67mhppnw1kbb053c4bygilbdviz53zrzm4z1cxr73hn1b5f6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.68)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-scopeguard" ,rust-scopeguard-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/byllyfish/exacl")
    (synopsis
     "Manipulate file system access control lists (ACL) on macOS, Linux, and FreeBSD")
    (description
     "Manipulate file system access control lists (ACL) on @code{macOS}, Linux, and
@code{FreeBSD}")
    (license license:expat)))

(define-public rust-clap-derive-4
  (package
    (name "rust-clap-derive")
    (version "4.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wxq692izvj0gn4i29002xs8l02wpzx6jwr4z17bhs8dy9ph2qh8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/clap-rs/clap/tree/master/clap_derive")
    (synopsis
     "Parse command line argument by defining a struct, derive crate.")
    (description
     "Parse command line argument by defining a struct, derive crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-anstyle-wincon-3
  (package
    (name "rust-anstyle-wincon")
    (version "3.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "anstyle-wincon" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a066gr4p7bha8qwnxyrpbrqzjdvk8l7pdg7isljimpls889ssgh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstyle" ,rust-anstyle-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/rust-cli/anstyle")
    (synopsis "Styling legacy Windows terminals")
    (description "Styling legacy Windows terminals")
    (license (list license:expat license:asl2.0))))

(define-public rust-anstream-0.6
  (package
    (name "rust-anstream")
    (version "0.6.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "anstream" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i2a9390vwhc42c5njz38n56jfwg17v64nqw9232j9gb2sz1xf9a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstyle" ,rust-anstyle-1)
                       ("rust-anstyle-parse" ,rust-anstyle-parse-0.2)
                       ("rust-anstyle-query" ,rust-anstyle-query-1)
                       ("rust-anstyle-wincon" ,rust-anstyle-wincon-3)
                       ("rust-colorchoice" ,rust-colorchoice-1)
                       ("rust-utf8parse" ,rust-utf8parse-0.2))))
    (home-page "https://github.com/rust-cli/anstyle")
    (synopsis
     "A simple cross platform library for writing colored text to a terminal.")
    (description
     "This package provides a simple cross platform library for writing colored text
to a terminal.")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-builder-4
  (package
    (name "rust-clap-builder")
    (version "4.4.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap_builder" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0iafh05fjzgaldx10j9qik9ir5sqz1mrcdy7lcgbspm6mjp1y8qf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstream" ,rust-anstream-0.6)
                       ("rust-anstyle" ,rust-anstyle-1)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-clap-lex" ,rust-clap-lex-0.5)
                       ("rust-strsim" ,rust-strsim-0.10)
                       ("rust-terminal-size" ,rust-terminal-size-0.3)
                       ("rust-unicase" ,rust-unicase-2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis
     "A simple to use, efficient, and full-featured Command Line Argument Parser")
    (description
     "This package provides a simple to use, efficient, and full-featured Command Line
Argument Parser")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-4
  (package
    (name "rust-clap")
    (version "4.4.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mmragwn4wqp42ksv67wj9fdq5pj8d5iab4f7vs0gpicdksh8iyh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clap-builder" ,rust-clap-builder-4)
                       ("rust-clap-derive" ,rust-clap-derive-4))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis
     "A simple to use, efficient, and full-featured Command Line Argument Parser")
    (description
     "This package provides a simple to use, efficient, and full-featured Command Line
Argument Parser")
    (license (list license:expat license:asl2.0))))

(define-public rust-uu-cp-0.0.22
  (package
    (name "rust-uu-cp")
    (version "0.0.22")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uu_cp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03idj6l9xcmdfwn6djs7ivckpzgvzxnhh4a75v423asgqw4f1zbz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clap" ,rust-clap-4)
                       ("rust-exacl" ,rust-exacl-0.11)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-indicatif" ,rust-indicatif-0.17)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-quick-error" ,rust-quick-error-2)
                       ("rust-selinux" ,rust-selinux-0.4)
                       ("rust-uucore" ,rust-uucore-0.0.22)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-xattr" ,rust-xattr-1))))
    (home-page "https://github.com/uutils/coreutils")
    (synopsis "cp ~ (uutils) copy SOURCE to DESTINATION")
    (description "cp ~ (uutils) copy SOURCE to DESTINATION")
    (license license:expat)))

(define-public rust-cookie-store-0.20
  (package
    (name "rust-cookie-store")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cookie_store" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xkc7fl1jik9ki13j9pjgyw51d0qd613srz1lv1qb0blpjmn2x1q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cookie" ,rust-cookie-0.17)
                       ("rust-idna" ,rust-idna-0.3)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-publicsuffix" ,rust-publicsuffix-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://github.com/pfernie/cookie_store")
    (synopsis "Implementation of Cookie storage and retrieval")
    (description "Implementation of Cookie storage and retrieval")
    (license (list license:expat license:asl2.0))))

(define-public rust-ureq-2
  (package
    (name "rust-ureq")
    (version "2.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ureq" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qsmg3lg5ik7jqqf5a7nhyzpg6z88scws5rgphz7a156shwdbk7m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-brotli-decompressor" ,rust-brotli-decompressor-2)
                       ("rust-cookie" ,rust-cookie-0.17)
                       ("rust-cookie-store" ,rust-cookie-store-0.20)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-rustls-webpki" ,rust-rustls-webpki-0.101)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-socks" ,rust-socks-0.3)
                       ("rust-url" ,rust-url-2)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.25))))
    (home-page "https://github.com/algesten/ureq")
    (synopsis "Simple, safe HTTP client")
    (description "Simple, safe HTTP client")
    (license (list license:expat license:asl2.0))))

(define-public rust-umask-2
  (package
    (name "rust-umask")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "umask" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "071xszsd6znk0ik11pxl7mwhf07clsiq3qpzw1ac0dcyak14d6pc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/Canop/umask")
    (synopsis "utility to deal with unix access mode")
    (description "utility to deal with unix access mode")
    (license license:expat)))

(define-public rust-windows-interface-0.44
  (package
    (name "rust-windows-interface")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-interface" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zwwwfzjdf087gvgy48bbfq9yd0fsh1fj5wzs88gim7cj6jnjgw5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The interface macro for the windows crate")
    (description "The interface macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-implement-0.44
  (package
    (name "rust-windows-implement")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-implement" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ij5q9khlcfn43a1p3ypjbn711k50s9pc8la5bf04ys1wfl7rs3c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The implement macro for the windows crate")
    (description "The implement macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-0.44
  (package
    (name "rust-windows")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ax1ip82dhszxz4hhsrdj3b0681xw6axahnfldxcgi506nmmsx4y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-implement" ,rust-windows-implement-0.44)
                       ("rust-windows-interface" ,rust-windows-interface-0.44)
                       ("rust-windows-targets" ,rust-windows-targets-0.42))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-url-2
  (package
    (name "rust-url")
    (version "2.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "url" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rbsx1nvz5ardf0x815639z1bxbbgjjjhj0mmnfaqzr5327m6fql"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-form-urlencoded" ,rust-form-urlencoded-1)
                       ("rust-idna" ,rust-idna-0.4)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/servo/rust-url")
    (synopsis "URL library for Rust, based on the WHATWG URL Standard")
    (description "URL library for Rust, based on the WHATWG URL Standard")
    (license (list license:expat license:asl2.0))))

(define-public rust-scopeguard-1
  (package
    (name "rust-scopeguard")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "scopeguard" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bluss/scopeguard")
    (synopsis
     "A RAII scope guard that will run a given closure when it goes out of scope,
even if the code between panics (assuming unwinding panic).

Defines the macros `defer!`, `defer_on_unwind!`, `defer_on_success!` as
shorthands for guards with one of the implemented strategies.
")
    (description
     "This package provides a RAII scope guard that will run a given closure when it
goes out of scope, even if the code between panics (assuming unwinding panic).
Defines the macros `defer!`, `defer_on_unwind!`, `defer_on_success!` as
shorthands for guards with one of the implemented strategies.")
    (license (list license:expat license:asl2.0))))

(define-public rust-trash-3
  (package
    (name "rust-trash")
    (version "3.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "trash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0604bq18pfjyh636c5spx58skq7maqg2phdy0n09hk8lwl460r4c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-objc" ,rust-objc-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-scopeguard" ,rust-scopeguard-1)
                       ("rust-url" ,rust-url-2)
                       ("rust-windows" ,rust-windows-0.44))))
    (home-page "https://github.com/ArturKovacs/trash")
    (synopsis "A library for moving files and folders to the Recycle Bin")
    (description
     "This package provides a library for moving files and folders to the Recycle Bin")
    (license license:expat)))

(define-public rust-joinery-2
  (package
    (name "rust-joinery")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "joinery" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xg4cjnz8cd6ya9hynb9wx79ijd3j6307f47aijviqzwyml7s5kj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Lucretiel/joinery")
    (synopsis
     "A small crate for generically joining iterators with a separator")
    (description
     "This package provides a small crate for generically joining iterators with a
separator")
    (license license:expat)))

(define-public rust-titlecase-2
  (package
    (name "rust-titlecase")
    (version "2.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "titlecase" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hi0hkh2x78rvq7rhdgdzsgwcnlpvvb59hgnifsgwz01vf67lf9q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-joinery" ,rust-joinery-2)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://github.com/wezm/titlecase")
    (synopsis
     "A tool and library that capitalizes text according to a style defined by John Gruber for post titles on his website Daring Fireball.")
    (description
     "This package provides a tool and library that capitalizes text according to a
style defined by John Gruber for post titles on his website Daring Fireball.")
    (license license:expat)))

(define-public rust-terminal-size-0.3
  (package
    (name "rust-terminal-size")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "terminal_size" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xqdzdjq77smg41z67vg3qwrcilf1zf5330gdrgm22lyghmvzgi1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/eminence/terminal-size")
    (synopsis "Gets the size of your Linux or Windows terminal")
    (description "Gets the size of your Linux or Windows terminal")
    (license (list license:expat license:asl2.0))))

(define-public rust-xmlparser-0.13
  (package
    (name "rust-xmlparser")
    (version "0.13.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "xmlparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r796g21c70p983ax0j6rmhzmalg4rhx61mvd4farxdhfyvy1zk6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/xmlparser")
    (synopsis "Pull-based, zero-allocation XML parser.")
    (description "Pull-based, zero-allocation XML parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-roxmltree-0.18
  (package
    (name "rust-roxmltree")
    (version "0.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "roxmltree" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00mkd2xyrxm8ap39sxpkhzdzfn2m98q3zicf6wd2f6yfa7il08w6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-xmlparser" ,rust-xmlparser-0.13))))
    (home-page "https://github.com/RazrFalcon/roxmltree")
    (synopsis "Represent an XML as a read-only tree.")
    (description "Represent an XML as a read-only tree.")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-syntax-0.8
  (package
    (name "rust-regex-syntax")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "regex-syntax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17rd2s8xbiyf6lb4aj2nfi44zqlj98g2ays8zzj2vfs743k79360"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1))))
    (home-page "https://github.com/rust-lang/regex/tree/master/regex-syntax")
    (synopsis "A regular expression parser.")
    (description "This package provides a regular expression parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-automata-0.4
  (package
    (name "rust-regex-automata")
    (version "0.4.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "regex-automata" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gs8q9yhd3kcg4pr00ag4viqxnh5l7jpyb9fsfr8hzh451w4r02z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.8))))
    (home-page "https://github.com/rust-lang/regex/tree/master/regex-automata")
    (synopsis "Automata construction and matching using regular expressions.")
    (description
     "Automata construction and matching using regular expressions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-1
  (package
    (name "rust-regex")
    (version "1.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "regex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hxkd814n4irind8im5c9am221ri6bprx49nc7yxv02ykhd9a2rq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-1)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-regex-automata" ,rust-regex-automata-0.4)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.8))))
    (home-page "https://github.com/rust-lang/regex")
    (synopsis
     "An implementation of regular expressions for Rust. This implementation uses
finite automata and guarantees linear time matching on all inputs.
")
    (description
     "An implementation of regular expressions for Rust.  This implementation uses
finite automata and guarantees linear time matching on all inputs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rayon-core-1
  (package
    (name "rust-rayon-core")
    (version "1.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rayon-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vaq0q71yfvcwlmia0iqf6ixj2fibjcf2xjy92n1m1izv1mgpqsw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-deque" ,rust-crossbeam-deque-0.8)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8))))
    (home-page "https://github.com/rayon-rs/rayon")
    (synopsis "Core APIs for Rayon")
    (description "Core APIs for Rayon")
    (license (list license:expat license:asl2.0))))

(define-public rust-rayon-1
  (package
    (name "rust-rayon")
    (version "1.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rayon" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cfdnvchf7j4cpha5jkcrrsr61li9i9lp5ak7xdq6d3pvc1xn9ww"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-rayon-core" ,rust-rayon-core-1))))
    (home-page "https://github.com/rayon-rs/rayon")
    (synopsis "Simple work-stealing parallelism for Rust")
    (description "Simple work-stealing parallelism for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-print-positions-0.6
  (package
    (name "rust-print-positions")
    (version "0.6.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "print-positions" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "026jzdf63b37bb9ix3mpczln2pqylsiwkkxhikj05x9y1r3r7x8x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-segmentation" ,rust-unicode-segmentation-1))))
    (home-page "https://github.com/bobhy/print-positions")
    (synopsis
     "A library providing string segmentation on grapheme clusters and ANSI escape sequences
for accurate length arithmetic based on visible print positions.
")
    (description
     "This package provides a library providing string segmentation on grapheme
clusters and ANSI escape sequences for accurate length arithmetic based on
visible print positions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-is-docker-0.2
  (package
    (name "rust-is-docker")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "is-docker" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cyibrv6817cqcpf391m327ss40xlbik8wxcv5h9pj9byhksx2wj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://github.com/TheLarkInn/is-docker")
    (synopsis "Checks if the process is running inside a Docker container.")
    (description "Checks if the process is running inside a Docker container.")
    (license license:expat)))

(define-public rust-is-wsl-0.4
  (package
    (name "rust-is-wsl")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "is-wsl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19bs5pq221d4bknnwiqqkqrnsx2in0fsk8fylxm1747iim4hjdhp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-is-docker" ,rust-is-docker-0.2)
                       ("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://github.com/TheLarkInn/is-wsl")
    (synopsis
     "Checks if the process is running inside Windows Subsystem for Linux.")
    (description
     "Checks if the process is running inside Windows Subsystem for Linux.")
    (license license:expat)))

(define-public rust-open-5
  (package
    (name "rust-open")
    (version "5.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "open" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1y6fk1n36isp2fi0qy7csg702qah1a534qrxavgnykffgn9g3ayg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-is-wsl" ,rust-is-wsl-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pathdiff" ,rust-pathdiff-0.2))))
    (home-page "https://github.com/Byron/open-rs")
    (synopsis "Open a path or URL using the program configured on the system")
    (description
     "Open a path or URL using the program configured on the system")
    (license license:expat)))

(define-public rust-nu-term-grid-0.86
  (package
    (name "rust-nu-term-grid")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-term-grid" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rijc4cb5qshf519ya5fmzfg9f4szwwwhqh9ygj9fc0wpz1ygdjb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-term-grid")
    (synopsis "Nushell grid printing")
    (description "Nushell grid printing")
    (license license:expat)))

(define-public rust-tabled-derive-0.6
  (package
    (name "rust-tabled-derive")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tabled_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r1z7qj37h1x4nyqbxq9jvbd713qvgpjlf1w18pz1x2lifh8ixlr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro-error" ,rust-proc-macro-error-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/zhiburt/tabled")
    (synopsis "Derive macros which is used by tabled crate")
    (description "Derive macros which is used by tabled crate")
    (license license:expat)))

(define-public rust-papergrid-0.10
  (package
    (name "rust-papergrid")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "papergrid" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j6hhk8lgzz53rzrlpxqrsq9gqi7cis445l7m7wn5nxny8avxk52"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-str" ,rust-ansi-str-0.8)
                       ("rust-ansitok" ,rust-ansitok-0.2)
                       ("rust-bytecount" ,rust-bytecount-0.6)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/zhiburt/tabled")
    (synopsis "Papergrid is a core library to print a table")
    (description "Papergrid is a core library to print a table")
    (license license:expat)))

(define-public rust-vte-0.10
  (package
    (name "rust-vte")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vte" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10srmy9ssircrwsb5lpx3fbhx71460j77kvz0krz38jcmf9fdg3c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                       ("rust-utf8parse" ,rust-utf8parse-0.2)
                       ("rust-vte-generate-state-changes" ,rust-vte-generate-state-changes-0.1))))
    (home-page "https://github.com/alacritty/vte")
    (synopsis "Parser for implementing terminal emulators")
    (description "Parser for implementing terminal emulators")
    (license (list license:asl2.0 license:expat))))

(define-public rust-ansitok-0.2
  (package
    (name "rust-ansitok")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ansitok" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10vc2d1325qsbvbnqnj48zg55wv7jz929drx9vpdscdvl7k48012"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nom" ,rust-nom-7)
                       ("rust-vte" ,rust-vte-0.10))))
    (home-page "https://gitlab.com/zhiburt/ansitok")
    (synopsis "A library for parsing ANSI Escape Codes")
    (description
     "This package provides a library for parsing ANSI Escape Codes")
    (license license:expat)))

(define-public rust-ansi-str-0.8
  (package
    (name "rust-ansi-str")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ansi-str" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07ddhqynv05xjyhw295w29qy77fi84sh5p2mm46ap0d94s4mgx0w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansitok" ,rust-ansitok-0.2))))
    (home-page "https://github.com/zhiburt/ansi-str")
    (synopsis
     "A library which provides a set of methods to work with ANSI strings")
    (description
     "This package provides a library which provides a set of methods to work with
ANSI strings")
    (license license:expat)))

(define-public rust-tabled-0.14
  (package
    (name "rust-tabled")
    (version "0.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tabled" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08jx39f86941n5mklw387j5myriqxng3zmhy2fjsn0d15miw7sfz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-str" ,rust-ansi-str-0.8)
                       ("rust-ansitok" ,rust-ansitok-0.2)
                       ("rust-papergrid" ,rust-papergrid-0.10)
                       ("rust-tabled-derive" ,rust-tabled-derive-0.6)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/zhiburt/tabled")
    (synopsis
     "An easy to use library for pretty print tables of Rust `struct`s and `enum`s.")
    (description
     "An easy to use library for pretty print tables of Rust `struct`s and `enum`s.")
    (license license:expat)))

(define-public rust-nu-table-0.86
  (package
    (name "rust-nu-table")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k4nhhzi2ld6d64skqafl92p2zj5bhmw57cy5ap8qb8j73v6zgry"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-color-config" ,rust-nu-color-config-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-tabled" ,rust-tabled-0.14))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-table")
    (synopsis "Nushell table printing")
    (description "Nushell table printing")
    (license license:expat)))

(define-public rust-filetime-0.2
  (package
    (name "rust-filetime")
    (version "0.2.22")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "filetime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1w1a4zb4ciqjl1chvp9dplbacq07jv97pkdn0pzackbk7vfrw0nl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-redox-syscall" ,rust-redox-syscall-0.3)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/alexcrichton/filetime")
    (synopsis "Platform-agnostic accessors of timestamps in File metadata
")
    (description "Platform-agnostic accessors of timestamps in File metadata")
    (license (list license:expat license:asl2.0))))

(define-public rust-notify-6
  (package
    (name "rust-notify")
    (version "6.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "notify" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bad98r0ilkhhq2jg3zs11zcqasgbvxia8224wpasm74n65vs1b2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-fsevent-sys" ,rust-fsevent-sys-4)
                       ("rust-inotify" ,rust-inotify-0.9)
                       ("rust-kqueue" ,rust-kqueue-1)
                       ("rust-kqueue" ,rust-kqueue-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis "Cross-platform filesystem notification library")
    (description "Cross-platform filesystem notification library")
    (license license:cc0)))

(define-public rust-file-id-0.2
  (package
    (name "rust-file-id")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "file-id" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jdg9xq830hghzrqkbnx8nda58a7z6mh8b6vlg5mj87v4l2ji135"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis
     "Utility for reading inode numbers (Linux, MacOS) and file IDs (Windows)")
    (description
     "Utility for reading inode numbers (Linux, @code{MacOS}) and file IDs (Windows)")
    (license (list license:expat license:asl2.0))))

(define-public rust-notify-debouncer-full-0.3
  (package
    (name "rust-notify-debouncer-full")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "notify-debouncer-full" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0m31ad5wv0lhrncn6qqk4zmryf0fl9h1j9kzrx89p2rlkjsxmxa9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-file-id" ,rust-file-id-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-notify" ,rust-notify-6)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis "notify event debouncer optimized for ease of use")
    (description "notify event debouncer optimized for ease of use")
    (license (list license:expat license:asl2.0))))

(define-public rust-vt100-0.15
  (package
    (name "rust-vt100")
    (version "0.15.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vt100" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pklc8y984axmxr0cd363srr2d27wd5rj15xlcmkjznvy0xqdkc4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-itoa" ,rust-itoa-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-vte" ,rust-vte-0.11))))
    (home-page "https://github.com/doy/vt100-rust")
    (synopsis "Library for parsing terminal data")
    (description "Library for parsing terminal data")
    (license license:expat)))

(define-public rust-indicatif-0.17
  (package
    (name "rust-indicatif")
    (version "0.17.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "indicatif" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "098ggvg7ps4097p5n9hmb3pqqy10bi8vjfzb7pci79xrklf78a7v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-console" ,rust-console-0.15)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-instant" ,rust-instant-0.1)
                       ("rust-number-prefix" ,rust-number-prefix-0.4)
                       ("rust-portable-atomic" ,rust-portable-atomic-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-vt100" ,rust-vt100-0.15))))
    (home-page "https://github.com/console-rs/indicatif")
    (synopsis "A progress bar and cli reporting library for Rust")
    (description
     "This package provides a progress bar and cli reporting library for Rust")
    (license license:expat)))

(define-public rust-diesel-table-macro-syntax-0.1
  (package
    (name "rust-diesel-table-macro-syntax")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "diesel_table_macro_syntax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1i9115qgsnargr6a707lqcjc45wqzq351a2gbvnnyw2kqkpmfmgw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-syn" ,rust-syn-2))))
    (home-page "https://diesel.rs")
    (synopsis "Internal diesel crate")
    (description "Internal diesel crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-diesel-derives-2
  (package
    (name "rust-diesel-derives")
    (version "2.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "diesel_derives" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i1bzp6rxnrrlgz1y946ap3203vjvack9a05h135mxblfmrkg0zg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-diesel-table-macro-syntax" ,rust-diesel-table-macro-syntax-0.1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://diesel.rs")
    (synopsis
     "You should not use this crate directly, it is internal to Diesel.")
    (description
     "You should not use this crate directly, it is internal to Diesel.")
    (license (list license:expat license:asl2.0))))

(define-public rust-diesel-2
  (package
    (name "rust-diesel")
    (version "2.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "diesel" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cwxqvwag055axclg1g7in6ygw0wav8s7nwfhghzq67ilqaa4s12"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bigdecimal" ,rust-bigdecimal-0.3)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-diesel-derives" ,rust-diesel-derives-2)
                       ("rust-ipnet" ,rust-ipnet-2)
                       ("rust-ipnetwork" ,rust-ipnetwork-0.17)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libsqlite3-sys" ,rust-libsqlite3-sys-0.26)
                       ("rust-mysqlclient-sys" ,rust-mysqlclient-sys-0.2)
                       ("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-integer" ,rust-num-integer-0.1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pq-sys" ,rust-pq-sys-0.4)
                       ("rust-quickcheck" ,rust-quickcheck-1)
                       ("rust-r2d2" ,rust-r2d2-0.8)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-url" ,rust-url-2)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://diesel.rs")
    (synopsis
     "A safe, extensible ORM and Query Builder for PostgreSQL, SQLite, and MySQL")
    (description
     "This package provides a safe, extensible ORM and Query Builder for
@code{PostgreSQL}, SQLite, and @code{MySQL}")
    (license (list license:expat license:asl2.0))))

(define-public rust-rust-decimal-1
  (package
    (name "rust-rust-decimal")
    (version "1.32.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rust_decimal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z9hgc76n78lfgw0wb063na5ajbxpm14gyhhdny1796mj1j23i54"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-borsh" ,rust-borsh-0.10)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-diesel" ,rust-diesel-1)
                       ("rust-diesel" ,rust-diesel-2)
                       ("rust-ndarray" ,rust-ndarray-0.15)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-postgres" ,rust-postgres-0.19)
                       ("rust-proptest" ,rust-proptest-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rkyv" ,rust-rkyv-0.7)
                       ("rust-rocket" ,rust-rocket-0.5)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tokio-postgres" ,rust-tokio-postgres-0.7))))
    (home-page "https://github.com/paupino/rust-decimal")
    (synopsis
     "Decimal number implementation written in pure Rust suitable for financial and fixed-precision calculations.")
    (description
     "Decimal number implementation written in pure Rust suitable for financial and
fixed-precision calculations.")
    (license license:expat)))

(define-public rust-dtparse-2
  (package
    (name "rust-dtparse")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dtparse" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fg8h07m0z38c6i556dfmgnhl18i8w37cl235iyfzc9l3kz7r325"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rust-decimal" ,rust-rust-decimal-1))))
    (home-page "https://github.com/bspeice/dtparse.git")
    (synopsis "A dateutil-compatible timestamp parser for Rust")
    (description
     "This package provides a dateutil-compatible timestamp parser for Rust")
    (license license:asl2.0)))

(define-public rust-dialoguer-0.11
  (package
    (name "rust-dialoguer")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dialoguer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pl0744wwr97kp8qnaybzgrfwk66qakzq0i1qrxl03vpbn0cx2v5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-console" ,rust-console-0.15)
                       ("rust-fuzzy-matcher" ,rust-fuzzy-matcher-0.3)
                       ("rust-shell-words" ,rust-shell-words-1)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/console-rs/dialoguer")
    (synopsis "A command line prompting library.")
    (description "This package provides a command line prompting library.")
    (license license:expat)))

(define-public rust-csv-core-0.1
  (package
    (name "rust-csv-core")
    (version "0.1.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csv-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w7s7qa60xb054rqddpyg53xq2b29sf3rbhcl8sbdx02g4yjpyjy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-memchr" ,rust-memchr-2))))
    (home-page "https://github.com/BurntSushi/rust-csv")
    (synopsis "Bare bones CSV parsing with no_std support.")
    (description "Bare bones CSV parsing with no_std support.")
    (license (list license:unlicense license:expat))))

(define-public rust-csv-1
  (package
    (name "rust-csv")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csv" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zjrlycvn44fxd9m8nwy8x33r9ncgk0k3wvy4fnvb9rpsks4ymxc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-csv-core" ,rust-csv-core-0.1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/BurntSushi/rust-csv")
    (synopsis "Fast CSV parsing with support for serde.")
    (description "Fast CSV parsing with support for serde.")
    (license (list license:unlicense license:expat))))

(define-public rust-chrono-humanize-0.2
  (package
    (name "rust-chrono-humanize")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chrono-humanize" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fq25fcdqd7s39dx81hq123210q4lpcbjdz82jl2fy6jnkk2g5kr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4))))
    (home-page "https://gitlab.com/imp/chrono-humanize-rs")
    (synopsis
     "Human-friendly time expressions - similar to Python arrow.humanize")
    (description
     "Human-friendly time expressions - similar to Python arrow.humanize")
    (license (list license:expat license:asl2.0))))

(define-public rust-chardetng-0.1
  (package
    (name "rust-chardetng")
    (version "0.1.17")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chardetng" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1spikjcnblwa5n1nnk46fxkwn86yfiqxgs47h4yaw23vbfvg1f0l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-rayon" ,rust-rayon-1))))
    (home-page "https://docs.rs/chardetng/")
    (synopsis "A character encoding detector for legacy Web content")
    (description
     "This package provides a character encoding detector for legacy Web content")
    (license (list license:asl2.0 license:expat))))

(define-public rust-calamine-0.22
  (package
    (name "rust-calamine")
    (version "0.22.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "calamine" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ixbak0wag0whhfl2sa7gv4s1bzwz9giqz3gznzwidlvcldaa2zy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-codepage" ,rust-codepage-0.1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-quick-xml" ,rust-quick-xml-0.30)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zip" ,rust-zip-0.6))))
    (home-page "https://github.com/tafia/calamine")
    (synopsis
     "An Excel/OpenDocument Spreadsheets reader and deserializer in pure rust")
    (description
     "An Excel/@code{OpenDocument} Spreadsheets reader and deserializer in pure rust")
    (license license:expat)))

(define-public rust-byteorder-1
  (package
    (name "rust-byteorder")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "byteorder" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jzncxyf404mwqdbspihyzpkndfgda450l0893pz5xj685cg5l0z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/BurntSushi/byteorder")
    (synopsis
     "Library for reading/writing numbers in big-endian and little-endian.")
    (description
     "Library for reading/writing numbers in big-endian and little-endian.")
    (license (list license:unlicense license:expat))))

(define-public rust-bracoxide-0.1
  (package
    (name "rust-bracoxide")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bracoxide" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j71fs71ss70rj7n4na8hg63w93czhrjdgi7di6nma12lrfg79xd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/atahabaki/bracoxide")
    (synopsis
     "A feature-rich library for brace pattern combination, permutation generation, and error handling.")
    (description
     "This package provides a feature-rich library for brace pattern combination,
permutation generation, and error handling.")
    (license license:expat)))

(define-public rust-alphanumeric-sort-1
  (package
    (name "rust-alphanumeric-sort")
    (version "1.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "alphanumeric-sort" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13hzg58ynj2b3h5ngcww1hp4hiawksa5bkqdr1cbgqjls9890541"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://magiclen.org/alphanumeric-sort")
    (synopsis
     "This crate can help you sort order for files and folders whose names contain numerals.")
    (description
     "This crate can help you sort order for files and folders whose names contain
numerals.")
    (license license:expat)))

(define-public rust-nu-command-0.86
  (package
    (name "rust-nu-command")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-command" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1sc4bh8ivc7mvp8jz9szkpkvmd8m46wyb4xxb0z9idf82nbn3xhg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-alphanumeric-sort" ,rust-alphanumeric-sort-1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bracoxide" ,rust-bracoxide-0.1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-bytesize" ,rust-bytesize-1)
                       ("rust-calamine" ,rust-calamine-0.22)
                       ("rust-chardetng" ,rust-chardetng-0.1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-humanize" ,rust-chrono-humanize-0.2)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-dialoguer" ,rust-dialoguer-0.11)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-dtparse" ,rust-dtparse-2)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-filesize" ,rust-filesize-0.2)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-fs-extra" ,rust-fs-extra-1)
                       ("rust-htmlescape" ,rust-htmlescape-0.3)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-indicatif" ,rust-indicatif-0.17)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-lscolors" ,rust-lscolors-0.15)
                       ("rust-md-5" ,rust-md-5-0.10)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-nix" ,rust-nix-0.27)
                       ("rust-notify-debouncer-full" ,rust-notify-debouncer-full-0.3)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-cmd-base" ,rust-nu-cmd-base-0.86)
                       ("rust-nu-color-config" ,rust-nu-color-config-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-glob" ,rust-nu-glob-0.86)
                       ("rust-nu-json" ,rust-nu-json-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-system" ,rust-nu-system-0.86)
                       ("rust-nu-table" ,rust-nu-table-0.86)
                       ("rust-nu-term-grid" ,rust-nu-term-grid-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-num" ,rust-num-0.4)
                       ("rust-num-format" ,rust-num-format-0.4)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-open" ,rust-open-5)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-pathdiff" ,rust-pathdiff-0.2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-print-positions" ,rust-print-positions-0.6)
                       ("rust-quick-xml" ,rust-quick-xml-0.30)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-roxmltree" ,rust-roxmltree-0.18)
                       ("rust-rusqlite" ,rust-rusqlite-0.29)
                       ("rust-same-file" ,rust-same-file-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-sysinfo" ,rust-sysinfo-0.29)
                       ("rust-tabled" ,rust-tabled-0.14)
                       ("rust-terminal-size" ,rust-terminal-size-0.3)
                       ("rust-titlecase" ,rust-titlecase-2)
                       ("rust-toml" ,rust-toml-0.8)
                       ("rust-trash" ,rust-trash-3)
                       ("rust-umask" ,rust-umask-2)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-ureq" ,rust-ureq-2)
                       ("rust-url" ,rust-url-2)
                       ("rust-uu-cp" ,rust-uu-cp-0.0.22)
                       ("rust-uuid" ,rust-uuid-1)
                       ("rust-wax" ,rust-wax-0.6)
                       ("rust-which" ,rust-which-4)
                       ("rust-windows" ,rust-windows-0.48)
                       ("rust-winreg" ,rust-winreg-0.51))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-command")
    (synopsis "Nushell's built-in commands")
    (description "Nushell's built-in commands")
    (license license:expat)))

(define-public rust-const-fn-0.4
  (package
    (name "rust-const-fn")
    (version "0.4.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "const_fn" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0df9fv9jhnh9b4ni3s2fbfcvq77iia4lbb89fklwawbgv2vdrp7v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/taiki-e/const_fn")
    (synopsis
     "An attribute for easy generation of const functions with conditional compilations.
")
    (description
     "An attribute for easy generation of const functions with conditional
compilations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-tz-rs-0.6
  (package
    (name "rust-tz-rs")
    (version "0.6.14")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tz-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d720z3p6g65awzv3924dipjnldrdsv6np0h9g7x5yj8r0aip19k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-fn" ,rust-const-fn-0.4))))
    (home-page "https://github.com/x-hgg-x/tz-rs")
    (synopsis
     "A pure Rust reimplementation of libc functions localtime, gmtime and mktime.")
    (description
     "This package provides a pure Rust reimplementation of libc functions localtime,
gmtime and mktime.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tzdb-0.5
  (package
    (name "rust-tzdb")
    (version "0.5.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tzdb" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17nr100ly0z69p8wfw6jvy6fpv68bklmnf5fgz6njl7vy9c8jxgc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-iana-time-zone" ,rust-iana-time-zone-0.1)
                       ("rust-tz-rs" ,rust-tz-rs-0.6))))
    (home-page "https://github.com/Kijewski/tzdb")
    (synopsis "Static time zone information for tz-rs")
    (description "Static time zone information for tz-rs")
    (license license:asl2.0)))

(define-public rust-libssh2-sys-0.3
  (package
    (name "rust-libssh2-sys")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libssh2-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vkidqw5ll71ynqc93hgcq62iqkklzb5268zffd13ql7nwqa1j1d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libz-sys" ,rust-libz-sys-1)
                       ("rust-openssl-sys" ,rust-openssl-sys-0.9)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-vcpkg" ,rust-vcpkg-0.2))))
    (home-page "https://github.com/alexcrichton/ssh2-rs")
    (synopsis "Native bindings to the libssh2 library")
    (description "Native bindings to the libssh2 library")
    (license (list license:expat license:asl2.0))))

(define-public rust-libgit2-sys-0.16
  (package
    (name "rust-libgit2-sys")
    (version "0.16.1+1.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libgit2-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "030dnq7hz79qs4rxdllc3ailvqzc432jwwxk7g8av55hh0vbp8pj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libssh2-sys" ,rust-libssh2-sys-0.3)
                       ("rust-libz-sys" ,rust-libz-sys-1)
                       ("rust-openssl-sys" ,rust-openssl-sys-0.9)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/rust-lang/git2-rs")
    (synopsis "Native bindings to the libgit2 library")
    (description "Native bindings to the libgit2 library")
    (license (list license:expat license:asl2.0))))

(define-public rust-git2-0.18
  (package
    (name "rust-git2")
    (version "0.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "git2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kf0kvg3i7p1223zs2h9fz99ndm0l9kdx3hcw63g73dh5nlppygv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libgit2-sys" ,rust-libgit2-sys-0.16)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-openssl-probe" ,rust-openssl-probe-0.1)
                       ("rust-openssl-sys" ,rust-openssl-sys-0.9)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://github.com/rust-lang/git2-rs")
    (synopsis
     "Bindings to libgit2 for interoperating with git repositories. This library is
both threadsafe and memory safe and allows both reading and writing git
repositories.
")
    (description
     "Bindings to libgit2 for interoperating with git repositories.  This library is
both threadsafe and memory safe and allows both reading and writing git
repositories.")
    (license (list license:expat license:asl2.0))))

(define-public rust-konst-proc-macros-0.2
  (package
    (name "rust-konst-proc-macros")
    (version "0.2.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "konst_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dxp8mdh3q9d044ql203way4fgbc50n3j3pi2j1x2snlcaa10klq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the `konst` crate")
    (description "Implementation detail of the `konst` crate")
    (license license:zlib)))

(define-public rust-konst-macro-rules-0.2
  (package
    (name "rust-konst-macro-rules")
    (version "0.2.19")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "konst_macro_rules" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dswja0dqcww4x3fwjnirc0azv2n6cazn8yv0kddksd8awzkz4x4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the konst crate")
    (description "Implementation detail of the konst crate")
    (license license:zlib)))

(define-public rust-konst-0.2
  (package
    (name "rust-konst")
    (version "0.2.19")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "konst" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x3lxxk9vjaiiaabngv7ki2bv9xi36gnqzjzi0s8qfs8wq9hw3rk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-konst-macro-rules" ,rust-konst-macro-rules-0.2)
                       ("rust-konst-proc-macros" ,rust-konst-proc-macros-0.2)
                       ("rust-trybuild" ,rust-trybuild-1))))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (description
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (license license:zlib)))

(define-public rust-const-format-proc-macros-0.2
  (package
    (name "rust-const-format-proc-macros")
    (version "0.2.32")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "const_format_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0015dzbjbd773nn6096dwqv11fm8m3gy4a4a56cz5x10zl4gzxn7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Implementation detail of the `const_format` crate")
    (description "Implementation detail of the `const_format` crate")
    (license license:zlib)))

(define-public rust-const-format-0.2
  (package
    (name "rust-const-format")
    (version "0.2.32")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "const_format" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wvns8mzqwkyciwr00p2g5g4ak7zz8m473di85srj11xmz3i98p3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-format-proc-macros" ,rust-const-format-proc-macros-0.2)
                       ("rust-konst" ,rust-konst-0.2))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Compile-time string formatting")
    (description "Compile-time string formatting")
    (license license:zlib)))

(define-public rust-shadow-rs-0.24
  (package
    (name "rust-shadow-rs")
    (version "0.24.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "shadow-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xqcw27hf8ybxlzhnnx5k0dvb5lq6yydsjv6yrfilky9y6pqq6gr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-format" ,rust-const-format-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-git2" ,rust-git2-0.18)
                       ("rust-is-debug" ,rust-is-debug-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-tzdb" ,rust-tzdb-0.5))))
    (home-page "https://github.com/baoyachi/shadow-rs")
    (synopsis "A build-time information stored in your rust project")
    (description
     "This package provides a build-time information stored in your rust project")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-cmd-lang-0.86
  (package
    (name "rust-nu-cmd-lang")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cmd-lang" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0aqw3lbj3ndi8j24m0g223s7rwvx9chcpipl74pjxwpcly9czpwx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-shadow-rs" ,rust-shadow-rs-0.24)
                       ("rust-shadow-rs" ,rust-shadow-rs-0.24))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-cmd-lang")
    (synopsis "Nushell's core language commands")
    (description "Nushell's core language commands")
    (license license:expat)))

(define-public rust-warp-0.3
  (package
    (name "rust-warp")
    (version "0.3.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "warp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sfimrpxkyka1mavfhg5wa4x977qs8vyxa510c627w9zw0i2xsf1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-compression" ,rust-async-compression-0.3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-headers" ,rust-headers-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-multer" ,rust-multer-2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-scoped-tls" ,rust-scoped-tls-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-tungstenite" ,rust-tokio-tungstenite-0.20)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/seanmonstar/warp")
    (synopsis "serve the web at warp speeds")
    (description "serve the web at warp speeds")
    (license license:expat)))

(define-public rust-tungstenite-0.16
  (package
    (name "rust-tungstenite")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tungstenite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l9s7gi9kgl4zynhbyb7737lmwaxaim4b818lwi7y95f2hx73lva"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rustls" ,rust-rustls-0.20)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-sha-1" ,rust-sha-1-0.9)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-url" ,rust-url-2)
                       ("rust-utf-8" ,rust-utf-8-0.7)
                       ("rust-webpki" ,rust-webpki-0.22)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22))))
    (home-page "https://github.com/snapview/tungstenite-rs")
    (synopsis "Lightweight stream-based WebSocket implementation")
    (description "Lightweight stream-based @code{WebSocket} implementation")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-tungstenite-0.16
  (package
    (name "rust-tokio-tungstenite")
    (version "0.16.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-tungstenite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wnadcv9q2yi7bjkdp6z0g4rk7kbdblsv613fpgjrhgwdbgkj2z8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-rustls" ,rust-rustls-0.20)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.23)
                       ("rust-tungstenite" ,rust-tungstenite-0.16)
                       ("rust-webpki" ,rust-webpki-0.22)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22))))
    (home-page "https://github.com/snapview/tokio-tungstenite")
    (synopsis
     "Tokio binding for Tungstenite, the Lightweight stream-based WebSocket implementation")
    (description
     "Tokio binding for Tungstenite, the Lightweight stream-based @code{WebSocket}
implementation")
    (license license:expat)))

(define-public rust-simple-asn1-0.4
  (package
    (name "rust-simple-asn1")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "simple_asn1" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jxy9as8nj65c2n27j843g4fpb95x4fjz31w6qx63q3wwlys2b39"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-num-bigint" ,rust-num-bigint-0.2)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/acw/simple_asn1")
    (synopsis "A simple DER/ASN.1 encoding/decoding library.")
    (description
     "This package provides a simple DER/ASN.1 encoding/decoding library.")
    (license license:isc)))

(define-public rust-jsonwebtoken-7
  (package
    (name "rust-jsonwebtoken")
    (version "7.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "jsonwebtoken" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ciz205wcjcn7n6i871zz5xlbzk863b0ybgiqi7li9ipwhawraxg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.12)
                       ("rust-pem" ,rust-pem-0.8)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-simple-asn1" ,rust-simple-asn1-0.4))))
    (home-page "https://github.com/Keats/jsonwebtoken")
    (synopsis "Create and decode JWTs in a strongly typed way.")
    (description "Create and decode JWTs in a strongly typed way.")
    (license license:expat)))

(define-public rust-async-session-3
  (package
    (name "rust-async-session")
    (version "3.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-session" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0c76vazdlcs2rsxq8gd8a6wnb913vxhnfx1hyfmfpqml4gjlrnh7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-lock" ,rust-async-lock-2)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-blake3" ,rust-blake3-0.3)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-hmac" ,rust-hmac-0.11)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-sha2" ,rust-sha2-0.9))))
    (home-page "https://github.com/http-rs/async-session")
    (synopsis "Async session support with pluggable middleware")
    (description "Async session support with pluggable middleware")
    (license (list license:expat license:asl2.0))))

(define-public rust-salvo-extra-0.16
  (package
    (name "rust-salvo-extra")
    (version "0.16.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "salvo_extra" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "023wagm5mpkp1jnpggllbddqigsy5h4qnw2lk8m3j25fj61fl3iy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-compression" ,rust-async-compression-0.3)
                       ("rust-async-session" ,rust-async-session-3)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-cookie" ,rust-cookie-0.16)
                       ("rust-csrf" ,rust-csrf-0.4)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-hkdf" ,rust-hkdf-0.12)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-hyper-rustls" ,rust-hyper-rustls-0.23)
                       ("rust-jsonwebtoken" ,rust-jsonwebtoken-7)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-salvo-core" ,rust-salvo-core-0.16)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-tungstenite" ,rust-tokio-tungstenite-0.16)
                       ("rust-tokio-util" ,rust-tokio-util-0.6)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://salvo.rs")
    (synopsis
     "Salvo is a powerful web framework that can make your work easier.
")
    (description
     "Salvo is a powerful web framework that can make your work easier.")
    (license (list license:expat license:asl2.0))))

(define-public rust-textnonce-1
  (package
    (name "rust-textnonce")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "textnonce" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10v653sz0305dlzdqh6wh795hxypk24s21iiqcfyv16p1kbzhhvp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.12)
                       ("rust-rand" ,rust-rand-0.7)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/mikedilger/textnonce")
    (synopsis "Text based random nonce generator")
    (description "Text based random nonce generator")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-quote-impl-0.3
  (package
    (name "rust-proc-quote-impl")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-quote-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "184ax14pyazv5g6yma60ls7x4hd5q6wah1kf677xng06idifrcvz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1))))
    (home-page "https://github.com/Goncalerta/proc-quote")
    (synopsis "A procedural macro implementation of quote!.")
    (description
     "This package provides a procedural macro implementation of quote!.")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-quote-0.4
  (package
    (name "rust-proc-quote")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-quote" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0051nax31x1yzr1imbp200l2gpz6pqcmlcna099r33773lbap12y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-proc-quote-impl" ,rust-proc-quote-impl-0.3)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Goncalerta/proc-quote")
    (synopsis "A procedural macro implementation of quote!.")
    (description
     "This package provides a procedural macro implementation of quote!.")
    (license (list license:expat license:asl2.0))))

(define-public rust-salvo-macros-0.16
  (package
    (name "rust-salvo-macros")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "salvo_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hdlzvcv2vvbr60w1kmfr9bx8glx4xs9g0ry1pwa7yf7ig987z90"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-crate" ,rust-proc-macro-crate-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-proc-quote" ,rust-proc-quote-0.4)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://salvo.rs")
    (synopsis "salvo proc macros")
    (description "salvo proc macros")
    (license (list license:expat license:asl2.0))))

(define-public rust-salvo-core-0.16
  (package
    (name "rust-salvo-core")
    (version "0.16.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "salvo_core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01dazprfzmjmvwgcrvqxjd12hgwwlk71mskwyl4cj2y2gm5p80bv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-compression" ,rust-async-compression-0.3)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-cookie" ,rust-cookie-0.16)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-fastrand" ,rust-fastrand-1)
                       ("rust-form-urlencoded" ,rust-form-urlencoded-1)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-headers" ,rust-headers-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-multer" ,rust-multer-2)
                       ("rust-multimap" ,rust-multimap-0.8)
                       ("rust-num-cpus" ,rust-num-cpus-1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-pin-utils" ,rust-pin-utils-0.1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-0.2)
                       ("rust-salvo-macros" ,rust-salvo-macros-0.16)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tempdir" ,rust-tempdir-0.3)
                       ("rust-textnonce" ,rust-textnonce-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.23)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://salvo.rs")
    (synopsis
     "Salvo is a powerful web framework that can make your work easier.
")
    (description
     "Salvo is a powerful web framework that can make your work easier.")
    (license (list license:expat license:asl2.0))))

(define-public rust-salvo-0.16
  (package
    (name "rust-salvo")
    (version "0.16.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "salvo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jw9h9aac4ms9shvssc8mw53q9842f5bfqv1a8aqkpcyd2j23n4b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-salvo-core" ,rust-salvo-core-0.16)
                       ("rust-salvo-extra" ,rust-salvo-extra-0.16))))
    (home-page "https://salvo.rs")
    (synopsis
     "Salvo is a powerful web framework that can make your work easier.
")
    (description
     "Salvo is a powerful web framework that can make your work easier.")
    (license (list license:expat license:asl2.0))))

(define-public rust-mime-guess-2
  (package
    (name "rust-mime-guess")
    (version "2.0.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mime_guess" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vs28rxnbfwil6f48hh58lfcx90klcvg68gxdc60spwa4cy2d4j1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-mime" ,rust-mime-0.3)
                       ("rust-unicase" ,rust-unicase-2)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/abonander/mime_guess")
    (synopsis
     "A simple crate for detection of a file's MIME type by its extension.")
    (description
     "This package provides a simple crate for detection of a file's MIME type by its
extension.")
    (license license:expat)))

(define-public rust-rust-embed-utils-8
  (package
    (name "rust-rust-embed-utils")
    (version "8.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rust-embed-utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nisb2dr0h59alcbv96pgniy9x2ra74j3fvi1bgnzy3vrgwfygw7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-globset" ,rust-globset-0.4)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/pyros2097/rust-embed")
    (synopsis "Utilities for rust-embed")
    (description "Utilities for rust-embed")
    (license license:expat)))

(define-public rust-rust-embed-impl-8
  (package
    (name "rust-rust-embed-impl")
    (version "8.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rust-embed-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a9wcbpdhyqzb0x4kw1vif8w7d8jn4v47a33iqsax420v1pqqg9w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rust-embed-utils" ,rust-rust-embed-utils-8)
                       ("rust-shellexpand" ,rust-shellexpand-2)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/pyros2097/rust-embed")
    (synopsis
     "Rust Custom Derive Macro which loads files into the rust binary at compile time during release and loads the file from the fs during dev")
    (description
     "Rust Custom Derive Macro which loads files into the rust binary at compile time
during release and loads the file from the fs during dev")
    (license license:expat)))

(define-public rust-ubyte-0.10
  (package
    (name "rust-ubyte")
    (version "0.10.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ubyte" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1spj3k9sx6xvfn7am9vm1b463hsr79nyvj8asi2grqhyrvvdw87p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/SergioBenitez/ubyte")
    (synopsis
     "A simple, complete, const-everything, saturating, human-friendly, no_std library for byte units.
")
    (description
     "This package provides a simple, complete, const-everything, saturating,
human-friendly, no_std library for byte units.")
    (license (list license:expat license:asl2.0))))

(define-public rust-oid-registry-0.4
  (package
    (name "rust-oid-registry")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "oid-registry" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0akbah3j8231ayrp2l1y5d9zmvbvqcsj0sa6s6dz6h85z8bhgqiq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asn1-rs" ,rust-asn1-rs-0.3))))
    (home-page "https://github.com/rusticata/oid-registry")
    (synopsis "Object Identifier (OID) database")
    (description "Object Identifier (OID) database")
    (license (list license:expat license:asl2.0))))

(define-public rust-der-parser-7
  (package
    (name "rust-der-parser")
    (version "7.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "der-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10kfa2gzl3x20mwgrd43cyi79xgkqxyzcyrh0xylv4apa33qlfgy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asn1-rs" ,rust-asn1-rs-0.3)
                       ("rust-cookie-factory" ,rust-cookie-factory-0.3)
                       ("rust-displaydoc" ,rust-displaydoc-0.2)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rusticata-macros" ,rust-rusticata-macros-4))))
    (home-page "https://github.com/rusticata/der-parser")
    (synopsis "Parser/encoder for ASN.1 BER/DER data")
    (description "Parser/encoder for ASN.1 BER/DER data")
    (license (list license:expat license:asl2.0))))

(define-public rust-asn1-rs-derive-0.1
  (package
    (name "rust-asn1-rs-derive")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "asn1-rs-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gzf9vab06lk0zjvbr07axx64fndkng2s28bnj27fnwd548pb2yv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-synstructure" ,rust-synstructure-0.12))))
    (home-page "https://github.com/rusticata/asn1-rs")
    (synopsis "Derive macros for the `asn1-rs` crate")
    (description "Derive macros for the `asn1-rs` crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-asn1-rs-0.3
  (package
    (name "rust-asn1-rs")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "asn1-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0czsk1nd4dx2k83f7jzkn8klx05wbmblkx1jh51i4c170akhbzrh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asn1-rs-derive" ,rust-asn1-rs-derive-0.1)
                       ("rust-asn1-rs-impl" ,rust-asn1-rs-impl-0.1)
                       ("rust-bitvec" ,rust-bitvec-1)
                       ("rust-cookie-factory" ,rust-cookie-factory-0.3)
                       ("rust-displaydoc" ,rust-displaydoc-0.2)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rusticata-macros" ,rust-rusticata-macros-4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/rusticata/asn1-rs")
    (synopsis "Parser/encoder for ASN.1 BER/DER data")
    (description "Parser/encoder for ASN.1 BER/DER data")
    (license (list license:expat license:asl2.0))))

(define-public rust-x509-parser-0.13
  (package
    (name "rust-x509-parser")
    (version "0.13.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "x509-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "077bi0xyaa8cmrqf3rrw1z6kkzscwd1nxdxgs7mgz2ambg7bmfcz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-asn1-rs" ,rust-asn1-rs-0.3)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-der-parser" ,rust-der-parser-7)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-oid-registry" ,rust-oid-registry-0.4)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rusticata-macros" ,rust-rusticata-macros-4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/rusticata/x509-parser")
    (synopsis "Parser for the X.509 v3 format (RFC 5280 certificates)")
    (description "Parser for the X.509 v3 format (RFC 5280 certificates)")
    (license (list license:expat license:asl2.0))))

(define-public rust-stable-pattern-0.1
  (package
    (name "rust-stable-pattern")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "stable-pattern" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i8hq82vm82mqj02qqcsd7caibrih7x5w3a1xpm8hpv30261cr25"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-memchr" ,rust-memchr-2))))
    (home-page "https://github.com/SergioBenitez/stable-pattern")
    (synopsis "Stable port of std::str::Pattern and friends.")
    (description "Stable port of std::str::Pattern and friends.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rocket-http-0.5
  (package
    (name "rust-rocket-http")
    (version "0.5.0-rc.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rocket_http" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x4h411ldb59c6bq05r7dzi65xiqz7akd63zydkkm832j74i4q4k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cookie" ,rust-cookie-0.17)
                       ("rust-either" ,rust-either-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pear" ,rust-pear-0.2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-ref-cast" ,rust-ref-cast-1)
                       ("rust-rustls" ,rust-rustls-0.20)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-stable-pattern" ,rust-stable-pattern-0.1)
                       ("rust-state" ,rust-state-0.5)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.23)
                       ("rust-uncased" ,rust-uncased-0.9)
                       ("rust-uuid" ,rust-uuid-1)
                       ("rust-x509-parser" ,rust-x509-parser-0.13))))
    (home-page "https://rocket.rs")
    (synopsis
     "Types, traits, and parsers for HTTP requests, responses, and headers.
")
    (description
     "Types, traits, and parsers for HTTP requests, responses, and headers.")
    (license (list license:expat license:asl2.0))))

(define-public rust-devise-core-0.4
  (package
    (name "rust-devise-core")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "devise_core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sp5idq0idng9i5kwjd8slvc724s97r28arrhyqq1jpx1ax0vd9m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-proc-macro2-diagnostics" ,rust-proc-macro2-diagnostics-0.10)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/SergioBenitez/Devise")
    (synopsis "A library for devising derives and other procedural macros.")
    (description
     "This package provides a library for devising derives and other procedural
macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-devise-codegen-0.4
  (package
    (name "rust-devise-codegen")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "devise_codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mpy5mmsigkj5f72gby82yk4advcqj97am2wzn0dwkj8vnwg934w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-devise-core" ,rust-devise-core-0.4)
                       ("rust-quote" ,rust-quote-1))))
    (home-page "https://github.com/SergioBenitez/Devise")
    (synopsis "A library for devising derives and other procedural macros.")
    (description
     "This package provides a library for devising derives and other procedural
macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-devise-0.4
  (package
    (name "rust-devise")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "devise" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1y45iag4hyvspkdsf6d856hf0ihf9vjnaga3c7y6c72l7zywxsnn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-devise-codegen" ,rust-devise-codegen-0.4)
                       ("rust-devise-core" ,rust-devise-core-0.4))))
    (home-page "https://github.com/SergioBenitez/Devise")
    (synopsis "A library for devising derives and other procedural macros.")
    (description
     "This package provides a library for devising derives and other procedural
macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rocket-codegen-0.5
  (package
    (name "rust-rocket-codegen")
    (version "0.5.0-rc.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rocket_codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12shzkr9zmc0v3r190nhcfavly28nngja2g4h94p93122hzkb4vh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-devise" ,rust-devise-0.4)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rocket-http" ,rust-rocket-http-0.5)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://rocket.rs")
    (synopsis "Procedural macros for the Rocket web framework.")
    (description "Procedural macros for the Rocket web framework.")
    (license (list license:expat license:asl2.0))))

(define-public rust-terminal-size-0.2
  (package
    (name "rust-terminal-size")
    (version "0.2.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "terminal_size" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0drj7gb77kay5r1cv53ysq3g9g4f8n0jkhld0kadi3lzkvqzcswf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustix" ,rust-rustix-0.37)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/eminence/terminal-size")
    (synopsis "Gets the size of your Linux or Windows terminal")
    (description "Gets the size of your Linux or Windows terminal")
    (license (list license:expat license:asl2.0))))

(define-public rust-is-terminal-0.4
  (package
    (name "rust-is-terminal")
    (version "0.4.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "is-terminal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12xgvc7nsrp3pn8hcxajfhbli2l5wnh3679y2fmky88nhj4qj26b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hermit-abi" ,rust-hermit-abi-0.3)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/sunfishcode/is-terminal")
    (synopsis "Test whether a given stream is a terminal")
    (description "Test whether a given stream is a terminal")
    (license license:expat)))

(define-public rust-anstyle-1
  (package
    (name "rust-anstyle")
    (version "1.0.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "anstyle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11yxw02b6parn29s757z96rgiqbn8qy0fk9a3p3bhczm85dhfybh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-cli/anstyle")
    (synopsis "ANSI text styling")
    (description "ANSI text styling")
    (license (list license:expat license:asl2.0))))

(define-public rust-winnow-0.5
  (package
    (name "rust-winnow")
    (version "0.5.17")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winnow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p7n0rp982pjpscq6dnvbalz6lm45lb60zr0rivn8wm6w3803f53"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstream" ,rust-anstream-0.3)
                       ("rust-anstyle" ,rust-anstyle-1)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-terminal-size" ,rust-terminal-size-0.2))))
    (home-page "https://github.com/winnow-rs/winnow")
    (synopsis "A byte-oriented, zero-copy, parser combinators library")
    (description
     "This package provides a byte-oriented, zero-copy, parser combinators library")
    (license license:expat)))

(define-public rust-toml-edit-0.20
  (package
    (name "rust-toml-edit")
    (version "0.20.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml_edit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f7k5svmxw98fhi28jpcyv7ldr2s3c867pjbji65bdxjpd44svir"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-kstring" ,rust-kstring-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-spanned" ,rust-serde-spanned-0.6)
                       ("rust-toml-datetime" ,rust-toml-datetime-0.6)
                       ("rust-winnow" ,rust-winnow-0.5))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "Yet another format-preserving TOML parser.")
    (description "Yet another format-preserving TOML parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-toml-datetime-0.6
  (package
    (name "rust-toml-datetime")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml_datetime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jsy7v8bdvmzsci6imj8fzgd255fmy5fzp6zsri14yrry7i77nkw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "A TOML-compatible datetime type")
    (description "This package provides a TOML-compatible datetime type")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-spanned-0.6
  (package
    (name "rust-serde-spanned")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_spanned" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11p1l83r5g3k18pi88cqri2r9ai03pm8b4azj4j02ypx6scnqhln"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "Serde-compatible spanned Value")
    (description "Serde-compatible spanned Value")
    (license (list license:expat license:asl2.0))))

(define-public rust-toml-0.8
  (package
    (name "rust-toml")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0g9ysjaqvm2mv8q85xpqfn7hi710hj24sd56k49wyddvvyq8lp8q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-spanned" ,rust-serde-spanned-0.6)
                       ("rust-toml-datetime" ,rust-toml-datetime-0.6)
                       ("rust-toml-edit" ,rust-toml-edit-0.20))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis
     "A native Rust encoder and decoder of TOML-formatted files and streams. Provides
implementations of the standard Serialize/Deserialize traits for TOML data to
facilitate deserializing and serializing Rust structures.
")
    (description
     "This package provides a native Rust encoder and decoder of TOML-formatted files
and streams.  Provides implementations of the standard Serialize/Deserialize
traits for TOML data to facilitate deserializing and serializing Rust
structures.")
    (license (list license:expat license:asl2.0))))

(define-public rust-yansi-1
  (package
    (name "rust-yansi")
    (version "1.0.0-rc.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yansi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xr3n41j5v00scfkac2d6vhkxiq9nz3l5j6vw8f3g3bqixdjjrqk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-is-terminal" ,rust-is-terminal-0.4))))
    (home-page "https://github.com/SergioBenitez/yansi")
    (synopsis "A dead simple ANSI terminal color painting library.")
    (description
     "This package provides a dead simple ANSI terminal color painting library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro2-diagnostics-0.10
  (package
    (name "rust-proc-macro2-diagnostics")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-macro2-diagnostics" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j48ipc80pykvhx6yhndfa774s58ax1h6sm6mlhf09ls76f6l1mg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-version-check" ,rust-version-check-0.9)
                       ("rust-yansi" ,rust-yansi-1))))
    (home-page "https://github.com/SergioBenitez/proc-macro2-diagnostics")
    (synopsis "Diagnostics for proc-macro2.")
    (description "Diagnostics for proc-macro2.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pear-codegen-0.2
  (package
    (name "rust-pear-codegen")
    (version "0.2.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pear_codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0m0dras73cm92sqn1715ypn46h9z1r8sc043kq9rq1n8v89hz7ys"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-proc-macro2-diagnostics" ,rust-proc-macro2-diagnostics-0.10)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "")
    (synopsis "A (codegen) pear is a fruit.")
    (description "This package provides a (codegen) pear is a fruit.")
    (license (list license:expat license:asl2.0))))

(define-public rust-inlinable-string-0.1
  (package
    (name "rust-inlinable-string")
    (version "0.1.15")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "inlinable_string" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ysjci8yfvxgf51z0ny2nnwhxrclhmb3vbngin8v4bznhr3ybyn8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/fitzgen/inlinable_string")
    (synopsis
     "The `inlinable_string` crate provides the `InlinableString` type -- an owned, grow-able UTF-8 string that stores small strings inline and avoids heap-allocation -- and the `StringExt` trait which abstracts string operations over both `std::string::String` and `InlinableString` (or even your own custom string type).")
    (description
     "The `inlinable_string` crate provides the `@code{InlinableString`} type -- an
owned, grow-able UTF-8 string that stores small strings inline and avoids
heap-allocation -- and the `@code{StringExt`} trait which abstracts string
operations over both `std::string::String` and `@code{InlinableString`} (or even
your own custom string type).")
    (license (list license:asl2.0 license:expat))))

(define-public rust-pear-0.2
  (package
    (name "rust-pear")
    (version "0.2.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pear" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "077pd1lbr5g99gsmcbglcrq6izl32qvd2l2bc2cx6aajf76qd8v1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-inlinable-string" ,rust-inlinable-string-0.1)
                       ("rust-pear-codegen" ,rust-pear-codegen-0.2)
                       ("rust-yansi" ,rust-yansi-1))))
    (home-page "")
    (synopsis "A pear is a fruit.")
    (description "This package provides a pear is a fruit.")
    (license (list license:expat license:asl2.0))))

(define-public rust-atomic-0.6
  (package
    (name "rust-atomic")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atomic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15193mfhmrq3p6vi1a10hw3n6kvzf5h32zikhby3mdj0ww1q10cd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "https://github.com/Amanieu/atomic-rs")
    (synopsis "Generic Atomic<T> wrapper type")
    (description "Generic Atomic<T> wrapper type")
    (license (list license:asl2.0 license:expat))))

(define-public rust-figment-0.10
  (package
    (name "rust-figment")
    (version "0.10.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "figment" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07qqgam7d565rw4n7jz4barq7c61n5ij9zrv7b8hm9vmb69sq550"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atomic" ,rust-atomic-0.6)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pear" ,rust-pear-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-toml" ,rust-toml-0.8)
                       ("rust-uncased" ,rust-uncased-0.9)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://github.com/SergioBenitez/Figment")
    (synopsis "A configuration library so con-free, it's unreal.")
    (description
     "This package provides a configuration library so con-free, it's unreal.")
    (license (list license:expat license:asl2.0))))

(define-public rust-binascii-0.1
  (package
    (name "rust-binascii")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "binascii" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wnaglgl72pn5ilv61q6y34w76gbg7crb8ifqk6lsxnq2gajjg9q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/naim94a/binascii-rs")
    (synopsis
     "Useful no-std binascii operations including base64, base32 and base16 (hex)")
    (description
     "Useful no-std binascii operations including base64, base32 and base16 (hex)")
    (license license:expat)))

(define-public rust-rocket-0.5
  (package
    (name "rust-rocket")
    (version "0.5.0-rc.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rocket" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jcwrkqvmbh1gwvg55kv6mdp8c9331hqzd45jq9gsp5f05s4ywsq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-stream" ,rust-async-stream-0.3)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-atomic" ,rust-atomic-0.5)
                       ("rust-binascii" ,rust-binascii-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-figment" ,rust-figment-0.10)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-multer" ,rust-multer-2)
                       ("rust-num-cpus" ,rust-num-cpus-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-ref-cast" ,rust-ref-cast-1)
                       ("rust-rmp-serde" ,rust-rmp-serde-1)
                       ("rust-rocket-codegen" ,rust-rocket-codegen-0.5)
                       ("rust-rocket-http" ,rust-rocket-http-0.5)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-state" ,rust-state-0.5)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-ubyte" ,rust-ubyte-0.10)
                       ("rust-uuid" ,rust-uuid-1)
                       ("rust-version-check" ,rust-version-check-0.9)
                       ("rust-yansi" ,rust-yansi-0.5))))
    (home-page "https://rocket.rs")
    (synopsis
     "Web framework with a focus on usability, security, extensibility, and speed.
")
    (description
     "Web framework with a focus on usability, security, extensibility, and speed.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-openssl-0.6
  (package
    (name "rust-tokio-openssl")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-openssl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12l7a01sid095zmdkcmjnds9hwfcyjn9539r3c6b5w89g3xrz3y0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-openssl" ,rust-openssl-0.10)
                       ("rust-openssl-sys" ,rust-openssl-sys-0.9)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/sfackler/tokio-openssl")
    (synopsis "An implementation of SSL streams for Tokio backed by OpenSSL
")
    (description
     "An implementation of SSL streams for Tokio backed by @code{OpenSSL}")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-metrics-0.3
  (package
    (name "rust-tokio-metrics")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-metrics" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04p1kf7sgcrs2n62331fm5yvv8scqv2x81qixdz8pjb23lj0kkpa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Runtime and task level metrics for Tokio applications.
")
    (description "Runtime and task level metrics for Tokio applications.")
    (license license:expat)))

(define-public rust-futures-codec-0.4
  (package
    (name "rust-futures-codec")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "futures_codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nzadpxhdxdlnlk2f0gfn0qbifqc3pbnzm10v4z04x8ciczxcm6f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-0.5)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project" ,rust-pin-project-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-cbor" ,rust-serde-cbor-0.11)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/matthunz/futures-codec")
    (synopsis "Utilities for encoding and decoding frames using `async/await`")
    (description
     "Utilities for encoding and decoding frames using `async/await`")
    (license license:expat)))

(define-public rust-sse-codec-0.3
  (package
    (name "rust-sse-codec")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sse-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nh8b1y2k5lsvcva15da4by935bavirfpavs0d54pi2h2f0rz9c4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-0.4)
                       ("rust-bytes" ,rust-bytes-0.5)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-codec" ,rust-futures-codec-0.4)
                       ("rust-memchr" ,rust-memchr-2))))
    (home-page "https://github.com/goto-bus-stop/sse-codec")
    (synopsis "async Server-Sent Events protocol encoder/decoder")
    (description "async Server-Sent Events protocol encoder/decoder")
    (license license:mpl2.0)))

(define-public rust-rfc7239-0.1
  (package
    (name "rust-rfc7239")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rfc7239" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ixsyn8y2jfhfqnhwivgil3cvdr4jdr5s0nr7gqq3d3yryrifwq8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-uncased" ,rust-uncased-0.9))))
    (home-page "https://github.com/icewind1991/rfc7239")
    (synopsis "Parser for rfc7239 formatted Forwarded headers")
    (description "Parser for rfc7239 formatted Forwarded headers")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-retry-0.3
  (package
    (name "rust-tokio-retry")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-retry" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0kr1hnm5dmb9gfkby88yg2xj8g6x4i4gipva0c8ca3xyxhvfnmvz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-pin-project" ,rust-pin-project-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/srijs/rust-tokio-retry")
    (synopsis "Extensible, asynchronous retry behaviours for futures/tokio")
    (description "Extensible, asynchronous retry behaviours for futures/tokio")
    (license license:expat)))

(define-public rust-futures-rustls-0.24
  (package
    (name "rust-futures-rustls")
    (version "0.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "futures-rustls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a1acak02s42wh6qjmjyviscc5j77qsh1qrqd023hdqqikv3rg9m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-rustls" ,rust-rustls-0.21))))
    (home-page "https://github.com/quininer/futures-rustls")
    (synopsis "Asynchronous TLS/SSL streams for futures using Rustls.")
    (description "Asynchronous TLS/SSL streams for futures using Rustls.")
    (license (list license:expat license:asl2.0))))

(define-public rust-crc16-0.4
  (package
    (name "rust-crc16")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "crc16" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zzwb5iv51wnh96532cxkk4aa8ys47rhzrjy98wqcys25ks8k01k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/blackbeam/rust-crc16")
    (synopsis "A CRC16 implementation")
    (description "This package provides a CRC16 implementation")
    (license license:expat)))

(define-public rust-async-native-tls-0.4
  (package
    (name "rust-async-native-tls")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-native-tls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zhkka5azpr03wg2bswabmwcwcqbdia17h2d17hk4wk47kn4qzfm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://docs.rs/crate/async-native-tls/")
    (synopsis "Native TLS using futures
")
    (description "Native TLS using futures")
    (license (list license:expat license:asl2.0))))

(define-public rust-ahash-0.7
  (package
    (name "rust-ahash")
    (version "0.7.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ahash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0isw672fiwx8cjl040jrck6pi85xcszkz6q0xsqkiy6qjl31mdgw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-random" ,rust-const-random-0.1)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://github.com/tkaitchuck/ahash")
    (synopsis
     "A non-cryptographic hash function using AES-NI for high performance")
    (description
     "This package provides a non-cryptographic hash function using AES-NI for high
performance")
    (license (list license:expat license:asl2.0))))

(define-public rust-redis-0.23
  (package
    (name "rust-redis")
    (version "0.23.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "redis" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fpqnckjlrhl7jbr1flrqg2hpccy3pz91gfiwzw2nh9zpg0csjag"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.7)
                       ("rust-arc-swap" ,rust-arc-swap-1)
                       ("rust-async-native-tls" ,rust-async-native-tls-0.4)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-combine" ,rust-combine-4)
                       ("rust-crc16" ,rust-crc16-0.4)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-futures-rustls" ,rust-futures-rustls-0.24)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-r2d2" ,rust-r2d2-0.8)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-sha1-smol" ,rust-sha1-smol-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-retry" ,rust-tokio-retry-0.3)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-url" ,rust-url-2)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.23))))
    (home-page "https://github.com/redis-rs/redis-rs")
    (synopsis "Redis driver for Rust.")
    (description "Redis driver for Rust.")
    (license license:bsd-3)))

(define-public rust-priority-queue-1
  (package
    (name "rust-priority-queue")
    (version "1.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "priority-queue" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0q8y21p3c1y3zjah5540nr8jsp8rmm7mcf6ss3l683gcrbgrxwzz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/garro95/priority-queue")
    (synopsis
     "A Priority Queue implemented as a heap with a function to efficiently change the priority of an item.")
    (description
     "This package provides a Priority Queue implemented as a heap with a function to
efficiently change the priority of an item.")
    (license (list license:lgpl3 license:mpl2.0))))

(define-public rust-poem-derive-1
  (package
    (name "rust-poem-derive")
    (version "1.3.58")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "poem-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19l0m7xdjvl2qqy2y13hd0dh7rv9d1dcqg7gjj42ffr7wyya0l15"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-crate" ,rust-proc-macro-crate-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/poem-web/poem")
    (synopsis "Macros for poem")
    (description "Macros for poem")
    (license (list license:expat license:asl2.0))))

(define-public rust-opentelemetry-semantic-conventions-0.12
  (package
    (name "rust-opentelemetry-semantic-conventions")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry-semantic-conventions" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0scjg1lyrlykvqc8bgzm8dqrxv89kr7b5wg70240cdfi18sgkjbk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-opentelemetry" ,rust-opentelemetry-0.20))))
    (home-page
     "https://github.com/open-telemetry/opentelemetry-rust/tree/main/opentelemetry-semantic-conventions")
    (synopsis "Semantic conventions for OpenTelemetry")
    (description "Semantic conventions for @code{OpenTelemetry}")
    (license license:asl2.0)))

(define-public rust-procfs-0.14
  (package
    (name "rust-procfs")
    (version "0.14.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "procfs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sdv4r3gikcz12qzb4020rlcq7vn8kh72vgwmvk7fgw7n2n8vpmi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-rustix" ,rust-rustix-0.36)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/eminence/procfs")
    (synopsis "Interface to the linux procfs pseudo-filesystem")
    (description "Interface to the linux procfs pseudo-filesystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-prometheus-0.13
  (package
    (name "rust-prometheus")
    (version "0.13.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prometheus" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "136gpgkh52kg3w6cxj1fdqqq5kr9ch31ci0lq6swxxdxbz8i3624"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-procfs" ,rust-procfs-0.14)
                       ("rust-protobuf" ,rust-protobuf-2)
                       ("rust-protobuf-codegen-pure" ,rust-protobuf-codegen-pure-2)
                       ("rust-reqwest" ,rust-reqwest-0.11)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/tikv/rust-prometheus")
    (synopsis "Prometheus instrumentation library for Rust applications.")
    (description "Prometheus instrumentation library for Rust applications.")
    (license license:asl2.0)))

(define-public rust-opentelemetry-prometheus-0.13
  (package
    (name "rust-opentelemetry-prometheus")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry-prometheus" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lqfw7j8gb96zh6bx2ap3cq5sw8dvdnb38k30c975mg2ak11pn67"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-opentelemetry-api" ,rust-opentelemetry-api-0.20)
                       ("rust-opentelemetry-sdk" ,rust-opentelemetry-sdk-0.20)
                       ("rust-prometheus" ,rust-prometheus-0.13)
                       ("rust-protobuf" ,rust-protobuf-2))))
    (home-page "https://github.com/open-telemetry/opentelemetry-rust")
    (synopsis "Prometheus exporter for OpenTelemetry")
    (description "Prometheus exporter for @code{OpenTelemetry}")
    (license license:asl2.0)))

(define-public rust-sluice-0.5
  (package
    (name "rust-sluice")
    (version "0.5.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sluice" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d9ywr5039ibgaby8sc72f8fs5lpp8j5y6p3npya4jplxz000x3d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-channel" ,rust-async-channel-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3))))
    (home-page "https://github.com/sagebind/sluice")
    (synopsis
     "Efficient ring buffer for byte buffers, FIFO queues, and SPSC channels")
    (description
     "Efficient ring buffer for byte buffers, FIFO queues, and SPSC channels")
    (license license:expat)))

(define-public rust-castaway-0.1
  (package
    (name "rust-castaway")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "castaway" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xhspwy477qy5yg9c3jp713asxckjpx0vfrmz5l7r5zg7naqysd2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/sagebind/castaway")
    (synopsis
     "Safe, zero-cost downcasting for limited compile-time specialization.")
    (description
     "Safe, zero-cost downcasting for limited compile-time specialization.")
    (license license:expat)))

(define-public rust-isahc-1
  (package
    (name "rust-isahc")
    (version "1.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "isahc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1scfgyv3dpjbkqa9im25cd12cs6rbd8ygcaw67f3dx41sys08kik"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-channel" ,rust-async-channel-1)
                       ("rust-castaway" ,rust-castaway-0.1)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8)
                       ("rust-curl" ,rust-curl-0.4)
                       ("rust-curl-sys" ,rust-curl-sys-0.4)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-event-listener" ,rust-event-listener-2)
                       ("rust-futures-lite" ,rust-futures-lite-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httpdate" ,rust-httpdate-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.11)
                       ("rust-polling" ,rust-polling-2)
                       ("rust-publicsuffix" ,rust-publicsuffix-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-sluice" ,rust-sluice-0.5)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracing-futures" ,rust-tracing-futures-0.2)
                       ("rust-url" ,rust-url-2)
                       ("rust-waker-fn" ,rust-waker-fn-1))))
    (home-page "https://github.com/sagebind/isahc")
    (synopsis "The practical HTTP client that is fun to use.")
    (description "The practical HTTP client that is fun to use.")
    (license license:expat)))

(define-public rust-opentelemetry-http-0.9
  (package
    (name "rust-opentelemetry-http")
    (version "0.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry-http" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12shasrr0zg63gh8050wm2xlw1ppkb2a8c1my3x373hxw704wnf7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-isahc" ,rust-isahc-1)
                       ("rust-opentelemetry-api" ,rust-opentelemetry-api-0.20)
                       ("rust-reqwest" ,rust-reqwest-0.11)
                       ("rust-surf" ,rust-surf-2)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/open-telemetry/opentelemetry-rust")
    (synopsis
     "Helper implementations for exchange of traces and metrics over HTTP")
    (description
     "Helper implementations for exchange of traces and metrics over HTTP")
    (license license:asl2.0)))

(define-public rust-opentelemetry-sdk-0.20
  (package
    (name "rust-opentelemetry-sdk")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry_sdk" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09l0vl76yv61pp93vr2kf4khc3x9sjhapjwzg4wq3m0j0rd713ps"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-executor" ,rust-futures-executor-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-opentelemetry-http" ,rust-opentelemetry-http-0.9)
                       ("rust-opentelemetry-api" ,rust-opentelemetry-api-0.20)
                       ("rust-ordered-float" ,rust-ordered-float-3)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://github.com/open-telemetry/opentelemetry-rust")
    (synopsis
     "The SDK for the OpenTelemetry metrics collection and distributed tracing framework")
    (description
     "The SDK for the @code{OpenTelemetry} metrics collection and distributed tracing
framework")
    (license license:asl2.0)))

(define-public rust-urlencoding-2
  (package
    (name "rust-urlencoding")
    (version "2.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "urlencoding" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nj99jp37k47n0hvaz5fvz7z6jd0sb4ppvfy3nphr1zbnyixpy6s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://lib.rs/urlencoding")
    (synopsis "A Rust library for doing URL percentage encoding.")
    (description
     "This package provides a Rust library for doing URL percentage encoding.")
    (license license:expat)))

(define-public rust-wasm-bindgen-shared-0.2
  (package
    (name "rust-wasm-bindgen-shared")
    (version "0.2.87")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-bindgen-shared" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18bmjwvfyhvlq49nzw6mgiyx4ys350vps4cmx5gvzckh91dd0sna"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://rustwasm.github.io/wasm-bindgen/")
    (synopsis
     "Shared support between wasm-bindgen and wasm-bindgen cli, an internal
dependency.
")
    (description
     "Shared support between wasm-bindgen and wasm-bindgen cli, an internal
dependency.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasm-bindgen-backend-0.2
  (package
    (name "rust-wasm-bindgen-backend")
    (version "0.2.87")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-bindgen-backend" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gcsh3bjxhw3cirmin45107pcsnn0ymhkxg6bxg65s8hqp9vdwjy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bumpalo" ,rust-bumpalo-3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-wasm-bindgen-shared" ,rust-wasm-bindgen-shared-0.2))))
    (home-page "https://rustwasm.github.io/wasm-bindgen/")
    (synopsis "Backend code generation of the wasm-bindgen tool
")
    (description "Backend code generation of the wasm-bindgen tool")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasm-bindgen-macro-support-0.2
  (package
    (name "rust-wasm-bindgen-macro-support")
    (version "0.2.87")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-bindgen-macro-support" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yqc46pr6mlgb9bsnfdnd50qvsqnrz8g5243fnaz0rb7lhc1ns2l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-wasm-bindgen-backend" ,rust-wasm-bindgen-backend-0.2)
                       ("rust-wasm-bindgen-shared" ,rust-wasm-bindgen-shared-0.2))))
    (home-page "https://rustwasm.github.io/wasm-bindgen/")
    (synopsis
     "The part of the implementation of the `#[wasm_bindgen]` attribute that is not in the shared backend crate
")
    (description
     "The part of the implementation of the `#[wasm_bindgen]` attribute that is not in
the shared backend crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasm-bindgen-macro-0.2
  (package
    (name "rust-wasm-bindgen-macro")
    (version "0.2.87")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-bindgen-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07cg0b6zkcxa1yg1n10h62paid59s9zr8yss214bv8w2b7jrbr6y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-quote" ,rust-quote-1)
                       ("rust-wasm-bindgen-macro-support" ,rust-wasm-bindgen-macro-support-0.2))))
    (home-page "https://rustwasm.github.io/wasm-bindgen/")
    (synopsis
     "Definition of the `#[wasm_bindgen]` attribute, an internal dependency
")
    (description
     "Definition of the `#[wasm_bindgen]` attribute, an internal dependency")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasm-bindgen-0.2
  (package
    (name "rust-wasm-bindgen")
    (version "0.2.87")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-bindgen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hm3k42gcnrps2jh339h186scx1radqy1w7v1zwb333dncmaf1kp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-wasm-bindgen-macro" ,rust-wasm-bindgen-macro-0.2))))
    (home-page "https://rustwasm.github.io/")
    (synopsis "Easy support for interacting between JS and Rust.
")
    (description "Easy support for interacting between JS and Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-js-sys-0.3
  (package
    (name "rust-js-sys")
    (version "0.3.64")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "js-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nlkiwpm8dyqcf1xyc6qmrankcgdd3fpzc0qyfq2sw3z97z9bwf5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2))))
    (home-page "https://rustwasm.github.io/wasm-bindgen/")
    (synopsis
     "Bindings for all JS global objects and functions in all JS environments like
Node.js and browsers, built on `#[wasm_bindgen]` using the `wasm-bindgen` crate.
")
    (description
     "Bindings for all JS global objects and functions in all JS environments like
Node.js and browsers, built on `#[wasm_bindgen]` using the `wasm-bindgen` crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-opentelemetry-api-0.20
  (package
    (name "rust-opentelemetry-api")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry_api" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16sv4rdm417v3d3mkk9vgksx7fvlk2qqpnm3dhhb3c9x68jzg0ca"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-urlencoding" ,rust-urlencoding-2))))
    (home-page "https://github.com/open-telemetry/opentelemetry-rust")
    (synopsis
     "OpenTelemetry is a metrics collection and distributed tracing framework")
    (description
     "@code{OpenTelemetry} is a metrics collection and distributed tracing framework")
    (license license:asl2.0)))

(define-public rust-opentelemetry-0.20
  (package
    (name "rust-opentelemetry")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "opentelemetry" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0m2cg0kqv8hplm3w6aajjm4yl05k19a5k9bidzmjyv8fphvxk4cm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-opentelemetry-api" ,rust-opentelemetry-api-0.20)
                       ("rust-opentelemetry-sdk" ,rust-opentelemetry-sdk-0.20))))
    (home-page "https://github.com/open-telemetry/opentelemetry-rust")
    (synopsis "A metrics collection and distributed tracing framework")
    (description
     "This package provides a metrics collection and distributed tracing framework")
    (license license:asl2.0)))

(define-public rust-hyper-rustls-0.24
  (package
    (name "rust-hyper-rustls")
    (version "0.24.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hyper-rustls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15xai84ri2jy56v6zslxzl384p0qvrylvxvlaqvzfk617vky2y4d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.23))))
    (home-page "https://github.com/rustls/hyper-rustls")
    (synopsis "Rustls+hyper integration for pure rust HTTPS")
    (description "Rustls+hyper integration for pure rust HTTPS")
    (license (list license:asl2.0 license:isc license:expat))))

(define-public rust-fluent-pseudo-0.3
  (package
    (name "rust-fluent-pseudo")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-pseudo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0byldssmzjdmynbh1yvdrxcj0xmhqznlmmgwnh8a1fhla7wn5vgx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-regex" ,rust-regex-1))))
    (home-page "http://www.projectfluent.org")
    (synopsis
     "Pseudolocalization transformation API for use with Project Fluent API.
")
    (description
     "Pseudolocalization transformation API for use with Project Fluent API.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-self-cell-0.10
  (package
    (name "rust-self-cell")
    (version "0.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "self_cell" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1by8h3axgpbiph5nbq80z6a41hd4cqlqc66hgnngs57y42j6by8y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustversion" ,rust-rustversion-1))))
    (home-page "https://github.com/Voultapher/self_cell")
    (synopsis
     "Safe-to-use proc-macro-free self-referential structs in stable Rust.")
    (description
     "Safe-to-use proc-macro-free self-referential structs in stable Rust.")
    (license license:asl2.0)))

(define-public rust-intl-pluralrules-7
  (package
    (name "rust-intl-pluralrules")
    (version "7.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "intl_pluralrules" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wprd3h6h8nfj62d8xk71h178q7zfn3srxm787w4sawsqavsg3h7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "https://github.com/zbraniecki/pluralrules")
    (synopsis "Unicode Plural Rules categorizer for numeric input.")
    (description "Unicode Plural Rules categorizer for numeric input.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-type-map-0.4
  (package
    (name "rust-type-map")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "type-map" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ilsqq7pcl3k9ggxv2x5fbxxfd6x7ljsndrhc38jmjwnbr63dlxn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-hash" ,rust-rustc-hash-1))))
    (home-page "https://github.com/kardeiz/type-map")
    (synopsis "Provides a typemap container with FxHashMap")
    (description
     "This package provides a typemap container with @code{FxHashMap}")
    (license (list license:expat license:asl2.0))))

(define-public rust-intl-memoizer-0.5
  (package
    (name "rust-intl-memoizer")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "intl-memoizer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vx6cji8ifw77zrgipwmvy1i3v43dcm58hwjxpb1h29i98z46463"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-type-map" ,rust-type-map-0.4)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "http://www.projectfluent.org")
    (synopsis "A memoizer specifically tailored for storing lazy-initialized
intl formatters.
")
    (description
     "This package provides a memoizer specifically tailored for storing
lazy-initialized intl formatters.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fluent-syntax-0.11
  (package
    (name "rust-fluent-syntax")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-syntax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y6ac7z7sbv51nsa6km5z8rkjj4nvqk91vlghq1ck5c3cjbyvay0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "http://www.projectfluent.org")
    (synopsis "Parser/Serializer tools for Fluent Syntax. 
")
    (description "Parser/Serializer tools for Fluent Syntax.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-unic-langid-macros-impl-0.9
  (package
    (name "rust-unic-langid-macros-impl")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-macros-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1n74gi3l8j8k94535psn3azbx9g69i7kbx23d0plwzwhbg0dwp0z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description "API for managing Unicode Language Identifiers")
    (license (list license:expat license:asl2.0))))

(define-public rust-unic-langid-macros-0.9
  (package
    (name "rust-unic-langid-macros")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zn4pm72n7w0jy78i8bbkz2yv9g1yg79ava6y3ziy5llys5n2ph5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-tinystr" ,rust-tinystr-0.7)
                       ("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9)
                       ("rust-unic-langid-macros-impl" ,rust-unic-langid-macros-impl-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description "API for managing Unicode Language Identifiers")
    (license (list license:expat license:asl2.0))))

(define-public rust-zerovec-derive-0.10
  (package
    (name "rust-zerovec-derive")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerovec-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0963hp2dpk62wpk7qz3yn31jlwz39kfax2w7z1gj4r4hh14zbaxc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the zerovec crate")
    (description "Custom derive for the zerovec crate")
    (license license:expat)))

(define-public rust-zerofrom-derive-0.1
  (package
    (name "rust-zerofrom-derive")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerofrom-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hqq5xw5a55623313p2gs9scbn24kqhvgrn2wvr75lvi0i8lg9p6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-synstructure" ,rust-synstructure-0.13))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the zerofrom crate")
    (description "Custom derive for the zerofrom crate")
    (license license:expat)))

(define-public rust-zerofrom-0.1
  (package
    (name "rust-zerofrom")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerofrom" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dq5dmls0gdlbxgzvh56754k0wq7ch60flbq97g9mcf0qla0hnv5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zerofrom-derive" ,rust-zerofrom-derive-0.1))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "ZeroFrom trait for constructing")
    (description "@code{ZeroFrom} trait for constructing")
    (license license:expat)))

(define-public rust-yoke-derive-0.7
  (package
    (name "rust-yoke-derive")
    (version "0.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yoke-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pxk3pdihc2kbxvchl249a8nzrg0adza7zq3ajmjn020xnv9zqfm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-synstructure" ,rust-synstructure-0.13))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the yoke crate")
    (description "Custom derive for the yoke crate")
    (license license:expat)))

(define-public rust-yoke-0.7
  (package
    (name "rust-yoke")
    (version "0.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yoke" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r1n2s3ssz116s50fjk5dgzpzajr4p0b7b9d56yvpmh4hr88rqv1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1)
                       ("rust-yoke-derive" ,rust-yoke-derive-0.7)
                       ("rust-zerofrom" ,rust-zerofrom-0.1))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis
     "Abstraction allowing borrowed data to be carried along with the backing data it borrows from")
    (description
     "Abstraction allowing borrowed data to be carried along with the backing data it
borrows from")
    (license license:expat)))

(define-public rust-t1ha-0.1
  (package
    (name "rust-t1ha")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "t1ha" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k4w9fc3wkxq67sicj1q44gmjh5fajx332536ln4wm0smr8sli7s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-0.1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rustc-version" ,rust-rustc-version-0.2))))
    (home-page "https://github.com/flier/rust-t1ha")
    (synopsis
     "An implementation of the T1AH (Fast Positive Hash) hash function.")
    (description
     "An implementation of the T1AH (Fast Positive Hash) hash function.")
    (license license:zlib)))

(define-public rust-zerovec-0.10
  (package
    (name "rust-zerovec")
    (version "0.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerovec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bjppfylqx0bhwpns5xdz5f6kkaqnxmch5mba2pghnqmbc61750i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake" ,rust-databake-0.1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-t1ha" ,rust-t1ha-0.1)
                       ("rust-yoke" ,rust-yoke-0.7)
                       ("rust-zerofrom" ,rust-zerofrom-0.1)
                       ("rust-zerovec-derive" ,rust-zerovec-derive-0.10))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Zero-copy vector backed by a byte array")
    (description "Zero-copy vector backed by a byte array")
    (license license:expat)))

(define-public rust-synstructure-0.13
  (package
    (name "rust-synstructure")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "synstructure" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01jvj55fxgqa69sp1j9mma09p9vj6zwcvyvh8am81b1zfc7ahnr8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/mystor/synstructure")
    (synopsis "Helper methods and macros for custom derives")
    (description "Helper methods and macros for custom derives")
    (license license:expat)))

(define-public rust-databake-derive-0.1
  (package
    (name "rust-databake-derive")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "databake-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yq8w4k5j8jbn6k9cvnr0f35x5dvhw3v9lfki41azwamwbgr81jz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-synstructure" ,rust-synstructure-0.13))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the databake crate")
    (description "Custom derive for the databake crate")
    (license license:expat)))

(define-public rust-databake-0.1
  (package
    (name "rust-databake")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "databake" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gfg93byqg7rhcafqwn57c6b5rl201b7bi0r4bxsl6ms29ing6wm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake-derive" ,rust-databake-derive-0.1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis
     "Trait that lets structs represent themselves as (const) Rust expressions")
    (description
     "Trait that lets structs represent themselves as (const) Rust expressions")
    (license license:expat)))

(define-public rust-tinystr-0.7
  (package
    (name "rust-tinystr")
    (version "0.7.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tinystr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06d2ym0963i72psh69lrc4wbraw446klbz2nad79pp0bx12y5l6m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake" ,rust-databake-0.1)
                       ("rust-displaydoc" ,rust-displaydoc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zerovec" ,rust-zerovec-0.10))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "A small ASCII-only bounded length string representation.")
    (description
     "This package provides a small ASCII-only bounded length string representation.")
    (license license:expat)))

(define-public rust-unic-langid-impl-0.9
  (package
    (name "rust-unic-langid-impl")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zrm390npybzrclbrj6il1l3yqd0i4zgvlypamdm95l75cpzsnz3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tinystr" ,rust-tinystr-0.7))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description "API for managing Unicode Language Identifiers")
    (license (list license:expat license:asl2.0))))

(define-public rust-unic-langid-0.9
  (package
    (name "rust-unic-langid")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0byg9pqm4vywfx82lcw080sphbgj5z8niq0gz384zd4x4gbrm3rr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9)
                       ("rust-unic-langid-macros" ,rust-unic-langid-macros-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description "API for managing Unicode Language Identifiers")
    (license (list license:expat license:asl2.0))))

(define-public rust-fluent-langneg-0.13
  (package
    (name "rust-fluent-langneg")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-langneg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "152yxplc11vmxkslvmaqak9x86xnavnhdqyhrh38ym37jscd0jic"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "http://projectfluent.org/")
    (synopsis "A library for language and locale negotiation.
")
    (description
     "This package provides a library for language and locale negotiation.")
    (license license:asl2.0)))

(define-public rust-fluent-bundle-0.15
  (package
    (name "rust-fluent-bundle")
    (version "0.15.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-bundle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zbzm13rfz7fay7bps7jd4j1pdnlxmdzzfymyq2iawf9vq0wchp2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fluent-langneg" ,rust-fluent-langneg-0.13)
                       ("rust-fluent-syntax" ,rust-fluent-syntax-0.11)
                       ("rust-intl-memoizer" ,rust-intl-memoizer-0.5)
                       ("rust-intl-pluralrules" ,rust-intl-pluralrules-7)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-self-cell" ,rust-self-cell-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "http://www.projectfluent.org")
    (synopsis
     "A localization system designed to unleash the entire expressive power of
natural language translations.
")
    (description
     "This package provides a localization system designed to unleash the entire
expressive power of natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fluent-0.16
  (package
    (name "rust-fluent")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19s7z0gw95qdsp9hhc00xcy11nwhnx93kknjmdvdnna435w97xk1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fluent-bundle" ,rust-fluent-bundle-0.15)
                       ("rust-fluent-pseudo" ,rust-fluent-pseudo-0.3)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "http://www.projectfluent.org")
    (synopsis
     "A localization system designed to unleash the entire expressive power of
natural language translations.
")
    (description
     "This package provides a localization system designed to unleash the entire
expressive power of natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-chacha20-0.7
  (package
    (name "rust-chacha20")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chacha20" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c8h4sp9zh13v8p9arydjcj92xc6j3mccrjc4mizrvq7fzx9717h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cipher" ,rust-cipher-0.3)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-rand-core" ,rust-rand-core-0.6)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/RustCrypto/stream-ciphers")
    (synopsis
     "The ChaCha20 stream cipher (RFC 8439) implemented in pure Rust using traits
from the RustCrypto `cipher` crate, with optional architecture-specific
hardware acceleration (AVX2, SSE2). Additionally provides the ChaCha8, ChaCha12,
XChaCha20, XChaCha12 and XChaCha8 stream ciphers, and also optional
rand_core-compatible RNGs based on those ciphers.
")
    (description
     "The @code{ChaCha20} stream cipher (RFC 8439) implemented in pure Rust using
traits from the @code{RustCrypto} `cipher` crate, with optional
architecture-specific hardware acceleration (AVX2, SSE2).  Additionally provides
the @code{ChaCha8}, @code{ChaCha12}, X@code{ChaCha20}, X@code{ChaCha12} and
X@code{ChaCha8} stream ciphers, and also optional rand_core-compatible RNGs
based on those ciphers.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-chacha20poly1305-0.8
  (package
    (name "rust-chacha20poly1305")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chacha20poly1305" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18mb6k1w71dqv5q50an4rvp19l6yg8ssmvfrmknjfh2z0az7lm5n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.4)
                       ("rust-chacha20" ,rust-chacha20-0.7)
                       ("rust-cipher" ,rust-cipher-0.3)
                       ("rust-poly1305" ,rust-poly1305-0.7)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page
     "https://github.com/RustCrypto/AEADs/tree/master/chacha20poly1305")
    (synopsis
     "Pure Rust implementation of the ChaCha20Poly1305 Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration. Also contains implementations of the XChaCha20Poly1305
extended nonce variant of ChaCha20Poly1305, and the reduced-round
ChaCha8Poly1305 and ChaCha12Poly1305 lightweight variants.
")
    (description
     "Pure Rust implementation of the @code{ChaCha20Poly1305} Authenticated Encryption
with Additional Data Cipher (RFC 8439) with optional architecture-specific
hardware acceleration.  Also contains implementations of the
X@code{ChaCha20Poly1305} extended nonce variant of @code{ChaCha20Poly1305}, and
the reduced-round @code{ChaCha8Poly1305} and @code{ChaCha12Poly1305} lightweight
variants.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-zeroize-1
  (package
    (name "rust-zeroize")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zeroize" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z8yix823b6lz878qwg6bvwhg3lb0cbw3c9yij9p8mbv7zdzfmj7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zeroize-derive" ,rust-zeroize-derive-1))))
    (home-page "https://github.com/RustCrypto/utils/tree/master/zeroize")
    (synopsis "Securely clear secrets from memory with a simple trait built on
stable Rust primitives which guarantee memory is zeroed using an
operation will not be 'optimized away' by the compiler.
Uses a portable pure Rust implementation that works everywhere,
even WASM!
")
    (description
     "Securely clear secrets from memory with a simple trait built on stable Rust
primitives which guarantee memory is zeroed using an operation will not be
optimized away by the compiler.  Uses a portable pure Rust implementation that
works everywhere, even WASM!")
    (license (list license:asl2.0 license:expat))))

(define-public rust-polyval-0.5
  (package
    (name "rust-polyval")
    (version "0.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polyval" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1890wqvc0csc9y9k9k4gsbz91rgdnhn6xnfmy9pqkh674fvd46c4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpufeatures" ,rust-cpufeatures-0.2)
                       ("rust-opaque-debug" ,rust-opaque-debug-0.3)
                       ("rust-universal-hash" ,rust-universal-hash-0.4)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/RustCrypto/universal-hashes")
    (synopsis
     "POLYVAL is a GHASH-like universal hash over GF(2^128) useful for constructing
a Message Authentication Code (MAC)
")
    (description
     "POLYVAL is a GHASH-like universal hash over GF(2^128) useful for constructing a
Message Authentication Code (MAC)")
    (license (list license:asl2.0 license:expat))))

(define-public rust-ghash-0.4
  (package
    (name "rust-ghash")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ghash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "169wvrc2k9lw776x3pmqp76kc0w5717wz01bfg9rz0ypaqbcr0qm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-opaque-debug" ,rust-opaque-debug-0.3)
                       ("rust-polyval" ,rust-polyval-0.5)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/RustCrypto/universal-hashes")
    (synopsis
     "Universal hash over GF(2^128) useful for constructing a Message Authentication Code (MAC),
as in the AES-GCM authenticated encryption cipher.
")
    (description
     "Universal hash over GF(2^128) useful for constructing a Message Authentication
Code (MAC), as in the AES-GCM authenticated encryption cipher.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-aes-gcm-0.9
  (package
    (name "rust-aes-gcm")
    (version "0.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "aes-gcm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xndncn1phjb7pjam63vl0yp7h8jh95m0yxanr1092vx7al8apyz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.4)
                       ("rust-aes" ,rust-aes-0.7)
                       ("rust-cipher" ,rust-cipher-0.3)
                       ("rust-ctr" ,rust-ctr-0.8)
                       ("rust-ghash" ,rust-ghash-0.4)
                       ("rust-subtle" ,rust-subtle-2)
                       ("rust-zeroize" ,rust-zeroize-1))))
    (home-page "https://github.com/RustCrypto/AEADs")
    (synopsis "Pure Rust implementation of the AES-GCM (Galois/Counter Mode)
Authenticated Encryption with Associated Data (AEAD) Cipher
with optional architecture-specific hardware acceleration
")
    (description
     "Pure Rust implementation of the AES-GCM (Galois/Counter Mode) Authenticated
Encryption with Associated Data (AEAD) Cipher with optional
architecture-specific hardware acceleration")
    (license (list license:asl2.0 license:expat))))

(define-public rust-csrf-0.4
  (package
    (name "rust-csrf")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csrf" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1q7ixhshj6a7x2vgsr4d4iqa5mgp4fwkr4lx2hgvnj9xcy1py9dh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aead" ,rust-aead-0.4)
                       ("rust-aes-gcm" ,rust-aes-gcm-0.9)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chacha20poly1305" ,rust-chacha20poly1305-0.8)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-generic-array" ,rust-generic-array-0.14)
                       ("rust-hmac" ,rust-hmac-0.11)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-sha2" ,rust-sha2-0.9)
                       ("rust-typemap" ,rust-typemap-0.3))))
    (home-page "https://github.com/heartsucker/rust-csrf")
    (synopsis "CSRF protection primitives")
    (description "CSRF protection primitives")
    (license license:expat)))

(define-public rust-poem-1
  (package
    (name "rust-poem")
    (version "1.3.58")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "poem" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pbvx354045qw0hcg434l79n93bhnfmh325h120sx4g7yccsxizb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-compression" ,rust-async-compression-0.4)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-cookie" ,rust-cookie-0.17)
                       ("rust-csrf" ,rust-csrf-0.4)
                       ("rust-eyre" ,rust-eyre-0.6)
                       ("rust-fluent" ,rust-fluent-0.16)
                       ("rust-fluent-langneg" ,rust-fluent-langneg-0.13)
                       ("rust-fluent-syntax" ,rust-fluent-syntax-0.11)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-headers" ,rust-headers-0.3)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httpdate" ,rust-httpdate-1)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-hyper-rustls" ,rust-hyper-rustls-0.24)
                       ("rust-intl-memoizer" ,rust-intl-memoizer-0.5)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-multer" ,rust-multer-2)
                       ("rust-openssl" ,rust-openssl-0.10)
                       ("rust-opentelemetry" ,rust-opentelemetry-0.20)
                       ("rust-opentelemetry-http" ,rust-opentelemetry-http-0.9)
                       ("rust-opentelemetry-prometheus" ,rust-opentelemetry-prometheus-0.13)
                       ("rust-opentelemetry-semantic-conventions" ,rust-opentelemetry-semantic-conventions-0.12)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-poem-derive" ,rust-poem-derive-1)
                       ("rust-priority-queue" ,rust-priority-queue-1)
                       ("rust-prometheus" ,rust-prometheus-0.13)
                       ("rust-quick-xml" ,rust-quick-xml-0.30)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rcgen" ,rust-rcgen-0.11)
                       ("rust-redis" ,rust-redis-0.23)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rfc7239" ,rust-rfc7239-0.1)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rust-embed" ,rust-rust-embed-8)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-sse-codec" ,rust-sse-codec-0.3)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-metrics" ,rust-tokio-metrics-0.3)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-openssl" ,rust-tokio-openssl-0.6)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-tungstenite" ,rust-tokio-tungstenite-0.20)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower" ,rust-tower-0.4)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-unic-langid" ,rust-unic-langid-0.9)
                       ("rust-x509-parser" ,rust-x509-parser-0.15))))
    (home-page "https://github.com/poem-web/poem")
    (synopsis
     "Poem is a full-featured and easy-to-use web framework with the Rust programming language.")
    (description
     "Poem is a full-featured and easy-to-use web framework with the Rust programming
language.")
    (license (list license:expat license:asl2.0))))

(define-public rust-include-flate-codegen-0.1
  (package
    (name "rust-include-flate-codegen")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "include-flate-codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1s34ssq0l3d2sn8n3mxmkz3jbm600fbckd0213mjjcgs34a6wz9s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libflate" ,rust-libflate-1)
                       ("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/SOF3/include-flate")
    (synopsis "Macro codegen for the include-flate crate")
    (description "Macro codegen for the include-flate crate")
    (license license:asl2.0)))

(define-public rust-include-flate-codegen-exports-0.1
  (package
    (name "rust-include-flate-codegen-exports")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "include-flate-codegen-exports" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00qswg7avv92mjp0p3kmswp3jask0psz1bmq3h7jin73zx1p0rbm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-include-flate-codegen" ,rust-include-flate-codegen-0.1)
                       ("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5))))
    (home-page "https://github.com/SOF3/include-flate")
    (synopsis "Macro codegen for the include-flate crate")
    (description "Macro codegen for the include-flate crate")
    (license license:asl2.0)))

(define-public rust-include-flate-0.2
  (package
    (name "rust-include-flate")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "include-flate" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c5dsx6j9jwrd6calhxdgip85qjy45hc8v1740fr61k46ilibqf2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-include-flate-codegen-exports" ,rust-include-flate-codegen-exports-0.1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libflate" ,rust-libflate-1))))
    (home-page "https://github.com/SOF3/include-flate")
    (synopsis
     "A variant of include_bytes!/include_str! with compile-time deflation and runtime lazy inflation")
    (description
     "This package provides a variant of include_bytes!/include_str! with compile-time
deflation and runtime lazy inflation")
    (license license:asl2.0)))

(define-public rust-actix-web-codegen-4
  (package
    (name "rust-actix-web-codegen")
    (version "4.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-web-codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xalrv1s7imzfgxyql6zii5bpxxkk11rlcc8n4ia3v1hpgmm07zb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-router" ,rust-actix-router-0.5)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://actix.rs")
    (synopsis "Routing and runtime macros for Actix Web")
    (description "Routing and runtime macros for Actix Web")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-server-2
  (package
    (name "rust-actix-server")
    (version "2.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-server" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1m62qbg7vl1wddr6mm8sd4rnvd3w5v3zcn8fmdpfl8q4xxz3xc9y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-rt" ,rust-actix-rt-2)
                       ("rust-actix-service" ,rust-actix-service-2)
                       ("rust-actix-utils" ,rust-actix-utils-3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-uring" ,rust-tokio-uring-0.4)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://actix.rs")
    (synopsis "General purpose TCP server built for the Actix ecosystem")
    (description "General purpose TCP server built for the Actix ecosystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-router-0.5
  (package
    (name "rust-actix-router")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-router" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16c7lcis96plz0rl23l44wsq61jpx1bn91m23y361cfj8z9g8vyn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytestring" ,rust-bytestring-0.1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/actix/actix-web.git")
    (synopsis "Resource path matching and router")
    (description "Resource path matching and router")
    (license (list license:expat license:asl2.0))))

(define-public rust-local-channel-0.1
  (package
    (name "rust-local-channel")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "local-channel" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y5iw3x96j5qcpmr0120viicbzrjhnxyx2dszj7qrwg5im497970"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-local-waker" ,rust-local-waker-0.1))))
    (home-page "https://github.com/actix/actix-net")
    (synopsis
     "A non-threadsafe multi-producer, single-consumer, futures-aware, FIFO queue")
    (description
     "This package provides a non-threadsafe multi-producer, single-consumer,
futures-aware, FIFO queue")
    (license (list license:expat license:asl2.0))))

(define-public rust-h2-0.3
  (package
    (name "rust-h2")
    (version "0.3.21")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "h2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cq8g5bgk3fihnqicy3g8gc3dpsalzqjg4bjyip9g4my26m27z4i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/hyperium/h2")
    (synopsis "An HTTP/2 client and server")
    (description "An HTTP/2 client and server")
    (license license:expat)))

(define-public rust-bytestring-1
  (package
    (name "rust-bytestring")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytestring" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1blscywg9gaw6zdc5hqsf9zwyqiym57q631nk7wc960dfs34i3i3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://actix.rs")
    (synopsis "An immutable UTF-8 encoded string using Bytes as storage")
    (description "An immutable UTF-8 encoded string using Bytes as storage")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustls-webpki-0.101
  (package
    (name "rust-rustls-webpki")
    (version "0.101.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustls-webpki" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zil7pjvqnbvg25l0d9vhx5ibq73r88969adlfdhv4a2wgn5sz9w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ring" ,rust-ring-0.16)
                       ("rust-untrusted" ,rust-untrusted-0.7))))
    (home-page "https://github.com/rustls/webpki")
    (synopsis "Web PKI X.509 Certificate Verification.")
    (description "Web PKI X.509 Certificate Verification.")
    (license license:isc)))

(define-public rust-openssl-src-300
  (package
    (name "rust-openssl-src")
    (version "300.1.5+3.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "openssl-src" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14b465p5v9rimdqf1y1zq17qvly04lbscmqqmbfdfl19q7j6i42m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1))))
    (home-page "https://github.com/alexcrichton/openssl-src-rs")
    (synopsis "Source of OpenSSL and logic to build it.
")
    (description "Source of @code{OpenSSL} and logic to build it.")
    (license (list license:expat license:asl2.0))))

(define-public rust-bssl-sys-0.1
  (package
    (name "rust-bssl-sys")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bssl-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p5v3ad1paf12db4hmwq4j8dvcrppsscf57dwvr880q67hwi4b9i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "")
    (synopsis "Placeholder package for boringssl bindings")
    (description "Placeholder package for boringssl bindings")
    (license license:expat)))

(define-public rust-openssl-sys-0.9
  (package
    (name "rust-openssl-sys")
    (version "0.9.93")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "openssl-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "078vnn4s18kj8m5sd7b684frhjnxjcjc9z7s7h4871s7q2j5ckfv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.64)
                       ("rust-bssl-sys" ,rust-bssl-sys-0.1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-openssl-src" ,rust-openssl-src-300)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-vcpkg" ,rust-vcpkg-0.2))))
    (home-page "https://github.com/sfackler/rust-openssl")
    (synopsis "FFI bindings to OpenSSL")
    (description "FFI bindings to @code{OpenSSL}")
    (license license:expat)))

(define-public rust-openssl-0.10
  (package
    (name "rust-openssl")
    (version "0.10.57")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "openssl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z0f8g84y0lvnbc60586ibjpf8r1q1dv672vfqan5d5bk7imxhms"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-foreign-types" ,rust-foreign-types-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-openssl-macros" ,rust-openssl-macros-0.1)
                       ("rust-openssl-sys" ,rust-openssl-sys-0.9))))
    (home-page "https://github.com/sfackler/rust-openssl")
    (synopsis "OpenSSL bindings")
    (description "@code{OpenSSL} bindings")
    (license license:asl2.0)))

(define-public rust-impl-more-0.1
  (package
    (name "rust-impl-more")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "impl-more" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bdv06br4p766rcgihhjwqyz8fcz31xyaq14rr53vfh3kifafv10"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/robjtede/impl-more")
    (synopsis "Concise, declarative trait implementation macros")
    (description "Concise, declarative trait implementation macros")
    (license (list license:expat license:asl2.0))))

(define-public rust-local-waker-0.1
  (package
    (name "rust-local-waker")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "local-waker" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1w9zqlh18mymvb82ya0sailiy5d3wsjamaakgl70x50i6vmpckz3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/actix/actix-net.git")
    (synopsis "A synchronization primitive for thread-local task wakeup")
    (description
     "This package provides a synchronization primitive for thread-local task wakeup")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-utils-3
  (package
    (name "rust-actix-utils")
    (version "3.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1n05nzwdkx6jhmzr6f9qsh57a8hqlwv5rjz1i0j3qvj6y7gxr8c8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-local-waker" ,rust-local-waker-0.1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2))))
    (home-page "https://github.com/actix/actix-net")
    (synopsis "Various utilities used in the Actix ecosystem")
    (description "Various utilities used in the Actix ecosystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-tls-3
  (package
    (name "rust-actix-tls")
    (version "3.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-tls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hzgw3rl8jl9mf6ck687dl1n0npz93x7fihnyg39kan0prznwqbj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-rt" ,rust-actix-rt-2)
                       ("rust-actix-service" ,rust-actix-service-2)
                       ("rust-actix-utils" ,rust-actix-utils-3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-impl-more" ,rust-impl-more-0.1)
                       ("rust-openssl" ,rust-openssl-0.10)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-webpki" ,rust-rustls-webpki-0.101)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-openssl" ,rust-tokio-openssl-0.6)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.23)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.25)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22))))
    (home-page "https://github.com/actix/actix-net.git")
    (synopsis "TLS acceptor and connector services for Actix ecosystem")
    (description "TLS acceptor and connector services for Actix ecosystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-service-2
  (package
    (name "rust-actix-service")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-service" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fipjcc5kma7j47jfrw55qm09dakgvx617jbriydrkqqz10lk29v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2))))
    (home-page "https://github.com/actix/actix-net")
    (synopsis
     "Service trait and combinators for representing asynchronous request/response operations.")
    (description
     "Service trait and combinators for representing asynchronous request/response
operations.")
    (license (list license:expat license:asl2.0))))

(define-public rust-sc-0.2
  (package
    (name "rust-sc")
    (version "0.2.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12x3c3mn36am3jfamswqfsd0vpr0hz3kdck6wskla7gx7fyih3h1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/japaric/syscall.rs")
    (synopsis "Raw system calls")
    (description "Raw system calls")
    (license (list license:expat license:asl2.0))))

(define-public rust-io-uring-0.5
  (package
    (name "rust-io-uring")
    (version "0.5.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "io-uring" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0k4qrzhnc8j50g79ki8n79d4yffvcmwq5dj3bj6gs95rrw0il7nx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.61)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-sc" ,rust-sc-0.2))))
    (home-page "https://github.com/tokio-rs/io-uring")
    (synopsis "The low-level `io_uring` userspace interface for Rust")
    (description "The low-level `io_uring` userspace interface for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-uring-0.4
  (package
    (name "rust-tokio-uring")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-uring" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vsmw482n01lj33dr7rnjxmdcdhq5yys6rbwahx0n0vy2fxh4phd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-io-uring" ,rust-io-uring-0.5)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-scoped-tls" ,rust-scoped-tls-1)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://tokio.rs")
    (synopsis "io-uring support for the Tokio asynchronous runtime.
")
    (description "io-uring support for the Tokio asynchronous runtime.")
    (license license:expat)))

(define-public rust-actix-macros-0.2
  (package
    (name "rust-actix-macros")
    (version "0.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jsmhq9k5nsms8sci2lqkihym5nrhlpfv8dgd0n4539g1cad67p0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/actix/actix-net.git")
    (synopsis "Macros for Actix system and runtime")
    (description "Macros for Actix system and runtime")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-rt-2
  (package
    (name "rust-actix-rt")
    (version "2.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-rt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "078mjccgha4xlqk2hjb9hxfg26pmpra9v2h2w0m40gvx5102vwr8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-macros" ,rust-actix-macros-0.2)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-uring" ,rust-tokio-uring-0.4))))
    (home-page "https://actix.rs")
    (synopsis
     "Tokio-based single-threaded async runtime for the Actix ecosystem")
    (description
     "Tokio-based single-threaded async runtime for the Actix ecosystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-http-3
  (package
    (name "rust-actix-http")
    (version "3.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-http" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j8v6pc0l0093wwz6mbhgsd7rn367r9hzhgpwiv3z86bk5bzhbm9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-codec" ,rust-actix-codec-0.5)
                       ("rust-actix-rt" ,rust-actix-rt-2)
                       ("rust-actix-service" ,rust-actix-service-2)
                       ("rust-actix-tls" ,rust-actix-tls-3)
                       ("rust-actix-utils" ,rust-actix-utils-3)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-brotli" ,rust-brotli-3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-bytestring" ,rust-bytestring-1)
                       ("rust-derive-more" ,rust-derive-more-0.99)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-h2" ,rust-h2-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-httpdate" ,rust-httpdate-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-language-tags" ,rust-language-tags-0.3)
                       ("rust-local-channel" ,rust-local-channel-0.1)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-sha1" ,rust-sha1-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-zstd" ,rust-zstd-0.12))))
    (home-page "https://actix.rs")
    (synopsis "HTTP primitives for the Actix ecosystem")
    (description "HTTP primitives for the Actix ecosystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-codec-0.5
  (package
    (name "rust-actix-codec")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-codec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f749khww3p9a1kw4yzf4w4l1xlylky2bngar7cf2zskwdl84yk1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/actix/actix-net")
    (synopsis "Codec utilities for working with framed protocols")
    (description "Codec utilities for working with framed protocols")
    (license (list license:expat license:asl2.0))))

(define-public rust-actix-web-4
  (package
    (name "rust-actix-web")
    (version "4.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "actix-web" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fb2yhd09kjabwz5qnic55hfp33ifkw5rikp9b4shg3055g5njhf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-codec" ,rust-actix-codec-0.5)
                       ("rust-actix-http" ,rust-actix-http-3)
                       ("rust-actix-macros" ,rust-actix-macros-0.2)
                       ("rust-actix-router" ,rust-actix-router-0.5)
                       ("rust-actix-rt" ,rust-actix-rt-2)
                       ("rust-actix-server" ,rust-actix-server-2)
                       ("rust-actix-service" ,rust-actix-service-2)
                       ("rust-actix-tls" ,rust-actix-tls-3)
                       ("rust-actix-utils" ,rust-actix-utils-3)
                       ("rust-actix-web-codegen" ,rust-actix-web-codegen-4)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-bytestring" ,rust-bytestring-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cookie" ,rust-cookie-0.16)
                       ("rust-derive-more" ,rust-derive-more-0.99)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-language-tags" ,rust-language-tags-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://actix.rs")
    (synopsis
     "Actix Web is a powerful, pragmatic, and extremely fast web framework for Rust")
    (description
     "Actix Web is a powerful, pragmatic, and extremely fast web framework for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-rust-embed-8
  (package
    (name "rust-rust-embed")
    (version "8.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rust-embed" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0h4sa3a46q01l8hdnw2x4r421kjfrbrmgdykydmhm7xmhl1xkrxi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-actix-web" ,rust-actix-web-4)
                       ("rust-axum" ,rust-axum-0.6)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-include-flate" ,rust-include-flate-0.2)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-poem" ,rust-poem-1)
                       ("rust-rocket" ,rust-rocket-0.5)
                       ("rust-rust-embed-impl" ,rust-rust-embed-impl-8)
                       ("rust-rust-embed-utils" ,rust-rust-embed-utils-8)
                       ("rust-salvo" ,rust-salvo-0.16)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-warp" ,rust-warp-0.3))))
    (home-page "https://github.com/pyros2097/rust-embed")
    (synopsis
     "Rust Custom Derive Macro which loads files into the rust binary at compile time during release and loads the file from the fs during dev")
    (description
     "Rust Custom Derive Macro which loads files into the rust binary at compile time
during release and loads the file from the fs during dev")
    (license license:expat)))

(define-public rust-nu-pretty-hex-0.86
  (package
    (name "rust-nu-pretty-hex")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-pretty-hex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fr7mzff4vavqqs47amzw7i8xf8a9d1vfdq8v0ji91c0vh12rm0g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-pretty-hex")
    (synopsis "Pretty hex dump of bytes slice in the common style.")
    (description "Pretty hex dump of bytes slice in the common style.")
    (license license:expat)))

(define-public rust-nu-cmd-extra-0.86
  (package
    (name "rust-nu-cmd-extra")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cmd-extra" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pj6gv1fggyyas3xvyiy56iqrwx3vymz30gimjf64dc0h8jh5g37"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-heck" ,rust-heck-0.4)
                       ("rust-htmlescape" ,rust-htmlescape-0.3)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-cmd-base" ,rust-nu-cmd-base-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-json" ,rust-nu-json-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rust-embed" ,rust-rust-embed-8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-cmd-extra")
    (synopsis
     "Nushell's extra commands that are not part of the 1.0 api standard.")
    (description
     "Nushell's extra commands that are not part of the 1.0 api standard.")
    (license license:expat)))

(define-public rust-sqlparser-derive-0.1
  (package
    (name "rust-sqlparser-derive")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sqlparser_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07knj4cvqd9r7jb7b6fzdifxipabv34bnzbcw1x7yk1n9b5pbzjm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/sqlparser-rs/sqlparser-rs")
    (synopsis "proc macro for sqlparser")
    (description "proc macro for sqlparser")
    (license license:asl2.0)))

(define-public rust-bigdecimal-0.4
  (package
    (name "rust-bigdecimal")
    (version "0.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bigdecimal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jcbzgna6292vgq0slw5iah929wl0xbps22zr63bp99y8az1jrn0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-integer" ,rust-num-integer-0.1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/akubera/bigdecimal-rs")
    (synopsis "Arbitrary precision decimal numbers")
    (description "Arbitrary precision decimal numbers")
    (license (list license:expat license:asl2.0))))

(define-public rust-sqlparser-0.36
  (package
    (name "rust-sqlparser")
    (version "0.36.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sqlparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11vx61pd687l6vzrlbr2nim61fwdq3qc6zcbsxh28b4dwy41xaif"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bigdecimal" ,rust-bigdecimal-0.4)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-sqlparser-derive" ,rust-sqlparser-derive-0.1))))
    (home-page "https://github.com/sqlparser-rs/sqlparser-rs")
    (synopsis "Extensible SQL Lexer and Parser with support for ANSI SQL:2011")
    (description
     "Extensible SQL Lexer and Parser with support for ANSI SQL:2011")
    (license license:asl2.0)))

(define-public rust-polars-sql-0.33
  (package
    (name "rust-polars-sql")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-sql" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z2n2i3h41k8kskq7pwpf4zy6l76237nhzr84bvicdby4ranhwad"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-lazy" ,rust-polars-lazy-0.33)
                       ("rust-polars-plan" ,rust-polars-plan-0.33)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-sqlparser" ,rust-sqlparser-0.36))))
    (home-page "https://www.pola.rs/")
    (synopsis
     "SQL transpiler for Polars. Converts SQL to Polars logical plans")
    (description
     "SQL transpiler for Polars.  Converts SQL to Polars logical plans")
    (license license:expat)))

(define-public rust-polars-ffi-0.33
  (package
    (name "rust-polars-ffi")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-ffi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cw07k7pdlhmx5f7p5kzrpd3s8qaml4zv952gfizcf9wfyhjr3m9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-polars-core" ,rust-polars-core-0.33))))
    (home-page "https://www.pola.rs/")
    (synopsis "FFI utils for the Polars project.")
    (description "FFI utils for the Polars project.")
    (license license:expat)))

(define-public rust-libloading-0.8
  (package
    (name "rust-libloading")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libloading" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0q812zvfag4m803ak640znl6cf8ngdd0ilzky498r6pwvmvbcwf5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/nagisa/rust_libloading/")
    (synopsis
     "Bindings around the platform's dynamic library loading primitives with greatly improved memory safety.")
    (description
     "Bindings around the platform's dynamic library loading primitives with greatly
improved memory safety.")
    (license license:isc)))

(define-public rust-polars-plan-0.33
  (package
    (name "rust-polars-plan")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-plan" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17ia6ajf9h26n3m6gikl788wcks52lni0i6qz3q517p262vvx337"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-ciborium" ,rust-ciborium-0.2)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libloading" ,rust-libloading-0.8)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-ffi" ,rust-polars-ffi-0.33)
                       ("rust-polars-io" ,rust-polars-io-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33)
                       ("rust-polars-time" ,rust-polars-time-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-pyo3" ,rust-pyo3-0.19)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-strum-macros" ,rust-strum-macros-0.25)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "Lazy query engine for the Polars DataFrame library")
    (description "Lazy query engine for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-polars-pipe-0.33
  (package
    (name "rust-polars-pipe")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-pipe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0frwlg2jmn4bg4fpwxjfr6lynbys47hf4vx4b34xv52mgkkwac0z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-crossbeam-queue" ,rust-crossbeam-queue-0.3)
                       ("rust-enum-dispatch" ,rust-enum-dispatch-0.3)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-io" ,rust-polars-io-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33)
                       ("rust-polars-plan" ,rust-polars-plan-0.33)
                       ("rust-polars-row" ,rust-polars-row-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "Lazy query engine for the Polars DataFrame library")
    (description "Lazy query engine for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-tokio-macros-2
  (package
    (name "rust-tokio-macros")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pk7y9dfanab886iaqwcbri39jkw33kgl7y07v0kg1pp8prdq2v3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://tokio.rs")
    (synopsis "Tokio's proc macros.
")
    (description "Tokio's proc macros.")
    (license license:expat)))

(define-public rust-socket2-0.5
  (package
    (name "rust-socket2")
    (version "0.5.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "socket2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17lqx8w2b3nysrkdbdz8y7fkikz5v77c052q57lxwajmxchfhca0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/rust-lang/socket2")
    (synopsis
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.
")
    (description
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-1
  (package
    (name "rust-tokio")
    (version "1.33.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lynj8nfqziviw72qns9mjlhmnm66bsc5bivy5g5x6gp7q720f2g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-num-cpus" ,rust-num-cpus-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-signal-hook-registry" ,rust-signal-hook-registry-1)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tokio-macros" ,rust-tokio-macros-2)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://tokio.rs")
    (synopsis
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O
backed applications.
")
    (description
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O backed
applications.")
    (license license:expat)))

(define-public rust-pin-project-lite-0.2
  (package
    (name "rust-pin-project-lite")
    (version "0.2.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pin-project-lite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0n0bwr5qxlf0mhn2xkl36sy55118s9qmvx2yl5f3ixkb007lbywa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/taiki-e/pin-project-lite")
    (synopsis
     "A lightweight version of pin-project written with declarative macros.
")
    (description
     "This package provides a lightweight version of pin-project written with
declarative macros.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-tokio-util-0.7
  (package
    (name "rust-tokio-util")
    (version "0.7.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-util" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03d63ivnd8pwi6qzrlw0gyqkiawq5vmkb5sdb4hhnypm4130fs0x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Additional utilities for working with Tokio.
")
    (description "Additional utilities for working with Tokio.")
    (license license:expat)))

(define-public rust-argminmax-0.6
  (package
    (name "rust-argminmax")
    (version "0.6.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "argminmax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1lnvpkvdsvdbsinhik6srx5c2j3gqkaj92iz93pnbdr9cjs0h890"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow" ,rust-arrow-5)
                       ("rust-arrow2" ,rust-arrow2-0.7)
                       ("rust-half" ,rust-half-2)
                       ("rust-ndarray" ,rust-ndarray-0.15)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/jvdd/argminmax")
    (synopsis
     "ArgMinMax (argmin & argmax in 1 function) with SIMD for floats and integers")
    (description
     "@code{ArgMinMax} (argmin & argmax in 1 function) with SIMD for floats and
integers")
    (license license:expat)))

(define-public rust-polars-ops-0.33
  (package
    (name "rust-polars-ops")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-ops" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lj2rv391qwqnrs1j3g8hzbdgz8nw4w9cnggz528181c9jydfh3p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-argminmax" ,rust-argminmax-0.6)
                       ("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-either" ,rust-either-1)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-jsonpath-lib" ,rust-jsonpath-lib-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-json" ,rust-polars-json-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "More operations on Polars data structures")
    (description "More operations on Polars data structures")
    (license license:expat)))

(define-public rust-now-0.1
  (package
    (name "rust-now")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "now" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l135786rb43rjfhwfdj7hi3b5zxxyl9gwf15yjz18cp8f3yk2bd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4))))
    (home-page "https://github.com/Kilerd/now")
    (synopsis "a time toolkit for chrono")
    (description "a time toolkit for chrono")
    (license license:expat)))

(define-public rust-polars-time-0.33
  (package
    (name "rust-polars-time")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-time" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qvh2aqqai6yjsagj4d98smaljg9lfi1kp2j1d05md8i9yi7bsx2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-atoi" ,rust-atoi-2)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-now" ,rust-now-0.1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smartstring" ,rust-smartstring-1))))
    (home-page "https://www.pola.rs/")
    (synopsis "Time related code for the Polars DataFrame library")
    (description "Time related code for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-tstr-proc-macros-0.2
  (package
    (name "rust-tstr-proc-macros")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tstr_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yklq0k0s3c4y0k5f0qm13lw7nvz5z97x3yhmyw1if0cdc3250g7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rodrimati1992/tstr_crates/")
    (synopsis "Implementation detail of tstr.")
    (description "Implementation detail of tstr.")
    (license license:zlib)))

(define-public rust-tstr-0.2
  (package
    (name "rust-tstr")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tstr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zidpsrn9b4i55cz832myxi2gw3qq6imbd7kxq7yq389f54jd8yc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-tstr-proc-macros" ,rust-tstr-proc-macros-0.2))))
    (home-page "https://github.com/rodrimati1992/tstr_crates/")
    (synopsis "Type-level strings")
    (description "Type-level strings")
    (license license:zlib)))

;; (define-public rust-regex-1
;;   (package
;;     (name "rust-regex")
;;     (version "1.2.1")
;;     (source
;;      (origin
;;        (method url-fetch)
;;        (uri (crate-uri "regex" version))
;;        (file-name (string-append name "-" version ".tar.gz"))
;;        (sha256
;;         (base32 "09jww0faqvdprr9482ppxm1asbp6lhihr8zl9ma5sa4474cxkhw8"))))
;;     (build-system cargo-build-system)
;;     (arguments
;;      `(#:skip-build? #t
;;        #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-0.7)
;;                        ("rust-memchr" ,rust-memchr-2)
;;                        ("rust-regex-syntax" ,rust-regex-syntax-0.6)
;;                        ("rust-thread-local" ,rust-thread-local-0.3))))
;;     (home-page "https://github.com/rust-lang/regex")
;;     (synopsis
;;      "An implementation of regular expressions for Rust. This implementation uses
;; finite automata and guarantees linear time matching on all inputs.
;; ")
;;     (description
;;      "An implementation of regular expressions for Rust.  This implementation uses
;; finite automata and guarantees linear time matching on all inputs.")
;;     (license (list license:expat license:asl2.0))))

(define-public rust-core-extensions-0.1
  (package
    (name "rust-core-extensions")
    (version "0.1.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "core_extensions" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nhgd5rlgp679qm4g3x806ywwhm6qr1y2j3y90wzjgyqllf7w49s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-version" ,rust-rustc-version-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-typenum" ,rust-typenum-1))))
    (home-page "https://github.com/rodrimati1992/core_extensions")
    (synopsis
     "Extensions for core/std library types, and other miscelaneous features.")
    (description
     "Extensions for core/std library types, and other miscelaneous features.")
    (license (list license:expat license:asl2.0))))

(define-public rust-as-derive-utils-0.8
  (package
    (name "rust-as-derive-utils")
    (version "0.8.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "as_derive_utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rjmbasb2spxdmm47kzw2zmr8icbdrcr0wa9kyn7lim5c0idh69b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-0.7)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-core-extensions" ,rust-core-extensions-0.1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-ron" ,rust-ron-0.5)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rodrimati1992/abi_stable_crates/")
    (synopsis "private derive utilities used by abi_stable and structural.")
    (description "private derive utilities used by abi_stable and structural.")
    (license (list license:expat license:asl2.0))))

(define-public rust-repr-offset-derive-0.2
  (package
    (name "rust-repr-offset-derive")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "repr_offset_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rwkbf12vmgi5v1llmgiirn0yaaiyw821rd7fc9fhpbkdxz95yh9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-as-derive-utils" ,rust-as-derive-utils-0.8)
                       ("rust-core-extensions" ,rust-core-extensions-0.1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rodrimati1992/repr_offset_crates/")
    (synopsis
     "For deriving the offsets of fields for types with a stable layout.")
    (description
     "For deriving the offsets of fields for types with a stable layout.")
    (license license:zlib)))

(define-public rust-repr-offset-0.2
  (package
    (name "rust-repr-offset")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "repr_offset" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1skj3cy77j7vwslnjjzgladq61z6jjvwlw89kp0zz7fjbdsp047v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-repr-offset-derive" ,rust-repr-offset-derive-0.2)
                       ("rust-tstr" ,rust-tstr-0.2))))
    (home-page "https://github.com/rodrimati1992/repr_offset_crates/")
    (synopsis "Offsets of fields for types with a stable layout.")
    (description "Offsets of fields for types with a stable layout.")
    (license license:zlib)))

(define-public rust-paste-1
  (package
    (name "rust-paste")
    (version "1.0.14")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "paste" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0k7d54zz8zrz0623l3xhvws61z5q2wd3hkwim6gylk8212placfy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dtolnay/paste")
    (synopsis "Macros for all your token pasting needs")
    (description "Macros for all your token pasting needs")
    (license (list license:expat license:asl2.0))))

(define-public rust-generational-arena-0.2
  (package
    (name "rust-generational-arena")
    (version "0.2.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "generational-arena" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rwnfyprjwqafkwdz2irkds5a41jcjb3bsma3djknx4fy2pr8zl7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/fitzgen/generational-arena")
    (synopsis
     "A safe arena allocator that supports deletion without suffering from the ABA problem by using generational indices.")
    (description
     "This package provides a safe arena allocator that supports deletion without
suffering from the ABA problem by using generational indices.")
    (license license:mpl2.0)))

(define-public rust-typewit-proc-macros-1
  (package
    (name "rust-typewit-proc-macros")
    (version "1.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "typewit_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mlkh4mhbn4b7xg9640blk74bm5ddaa44ihvl0sljw1w5gm86sp3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/typewit/")
    (synopsis "implementation detail of typewit")
    (description "implementation detail of typewit")
    (license license:zlib)))

(define-public rust-typewit-1
  (package
    (name "rust-typewit")
    (version "1.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "typewit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ajrz5y5l18bd4k4mrwsbwclb7hwxd9s7a50fj13i9zrqnfacyb7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-typewit-proc-macros" ,rust-typewit-proc-macros-1))))
    (home-page "https://github.com/rodrimati1992/typewit/")
    (synopsis
     "type-witness-based abstractions, mostly for emulating polymorphism in const fns")
    (description
     "type-witness-based abstractions, mostly for emulating polymorphism in const fns")
    (license license:zlib)))

(define-public rust-const-panic-proc-macros-0.2
  (package
    (name "rust-const-panic-proc-macros")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "const_panic_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1addx3a8vi02cdak3ygrqivv02jj73251h85x49aic78yznrhlrr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/rodrimati1992/const_panic/")
    (synopsis "Implementation detail of the `const_panic` crate")
    (description "Implementation detail of the `const_panic` crate")
    (license license:zlib)))

(define-public rust-const-panic-0.2
  (package
    (name "rust-const-panic")
    (version "0.2.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "const_panic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16w72mnzjqgwfhlq8cqm6xhd2n6lc1wan08987izv1pcxhwz4lb0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-panic-proc-macros" ,rust-const-panic-proc-macros-0.2)
                       ("rust-typewit" ,rust-typewit-1))))
    (home-page "https://github.com/rodrimati1992/const_panic/")
    (synopsis "const panic with formatting")
    (description "const panic with formatting")
    (license license:zlib)))

(define-public rust-as-derive-utils-0.11
  (package
    (name "rust-as-derive-utils")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "as_derive_utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1i2kwzxdhydicj9bqscz5w73nmx612yi3ha137qlr900b5j9cg7z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-0.7)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-core-extensions" ,rust-core-extensions-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-ron" ,rust-ron-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rodrimati1992/abi_stable_crates/")
    (synopsis "private derive utilities used by abi_stable and structural.")
    (description "private derive utilities used by abi_stable and structural.")
    (license (list license:expat license:asl2.0))))

(define-public rust-core-extensions-proc-macros-1
  (package
    (name "rust-core-extensions-proc-macros")
    (version "1.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "core_extensions_proc_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19k11haw8s00zxxignjmw0ian0q85r9grhbvr153nvlbs8cv5wv9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rodrimati1992/core_extensions")
    (synopsis "Implementation detail of the `core_extensions` crate")
    (description "Implementation detail of the `core_extensions` crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-core-extensions-1
  (package
    (name "rust-core-extensions")
    (version "1.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "core_extensions" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vn0jsn8nbi76i2jjadim31piscf0hv8640ng9z608cpgk01viwj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-core-extensions-proc-macros" ,rust-core-extensions-proc-macros-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rodrimati1992/core_extensions")
    (synopsis
     "Extensions for core/std library types, and other miscelaneous features.")
    (description
     "Extensions for core/std library types, and other miscelaneous features.")
    (license (list license:expat license:asl2.0))))

(define-public rust-abi-stable-shared-0.11
  (package
    (name "rust-abi-stable-shared")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "abi_stable_shared" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qrbmlypvxx3zij1c6w6yykpp5pjcfx9qr2d9lzyc8y1i1vdzddj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-core-extensions" ,rust-core-extensions-1))))
    (home-page "https://github.com/rodrimati1992/abi_stable_crates/")
    (synopsis "Implementation detail of abi_stable.")
    (description "Implementation detail of abi_stable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-abi-stable-derive-0.11
  (package
    (name "rust-abi-stable-derive")
    (version "0.11.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "abi_stable_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16780mmr2hwx8ajcq59nhvq3krv5i8r7mg41x08fx907nil885yp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-abi-stable-shared" ,rust-abi-stable-shared-0.11)
                       ("rust-as-derive-utils" ,rust-as-derive-utils-0.11)
                       ("rust-core-extensions" ,rust-core-extensions-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-typed-arena" ,rust-typed-arena-2))))
    (home-page "https://github.com/rodrimati1992/abi_stable_crates/")
    (synopsis "Implementation detail of abi_stable.")
    (description "Implementation detail of abi_stable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-abi-stable-0.11
  (package
    (name "rust-abi-stable")
    (version "0.11.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "abi_stable" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0if428pq8ly97zi6q1842nak977rwxnj17650i8gwpxh7qnm3mk9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-abi-stable-derive" ,rust-abi-stable-derive-0.11)
                       ("rust-abi-stable-shared" ,rust-abi-stable-shared-0.11)
                       ("rust-const-panic" ,rust-const-panic-0.2)
                       ("rust-core-extensions" ,rust-core-extensions-1)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-generational-arena" ,rust-generational-arena-0.2)
                       ("rust-libloading" ,rust-libloading-0.7)
                       ("rust-lock-api" ,rust-lock-api-0.4)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-repr-offset" ,rust-repr-offset-0.2)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/rodrimati1992/abi_stable_crates/")
    (synopsis
     "For doing Rust-to-Rust ffi,writing libraries loaded at program startup.")
    (description
     "For doing Rust-to-Rust ffi,writing libraries loaded at program startup.")
    (license (list license:expat license:asl2.0))))

(define-public rust-value-trait-0.6
  (package
    (name "rust-value-trait")
    (version "0.6.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "value-trait" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pllqs0gq31cwn4xh4zd1m4ls4q5cx58vi6ad6wn64mhrv4bd989"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-abi-stable" ,rust-abi-stable-0.11)
                       ("rust-float-cmp" ,rust-float-cmp-0.9)
                       ("rust-halfbrown" ,rust-halfbrown-0.2)
                       ("rust-hashbrown" ,rust-hashbrown-0.13)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1))))
    (home-page "https://github.com/simd-lite/value-trait")
    (synopsis "Traits to deal with JSONesque values")
    (description "Traits to deal with JSONesque values")
    (license (list license:asl2.0 license:expat))))

(define-public rust-x86-0.47
  (package
    (name "rust-x86")
    (version "0.47.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "x86" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jlddyczw168mcy4a6m3nbl203rxli2vr5gcmf57s0adqf6bxdam"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bit-field" ,rust-bit-field-0.10)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-phf" ,rust-phf-0.9)
                       ("rust-phf-codegen" ,rust-phf-codegen-0.9)
                       ("rust-raw-cpuid" ,rust-raw-cpuid-10)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/gz/rust-x86")
    (synopsis
     "Library to program x86 (amd64) hardware. Contains x86 specific data structure descriptions, data-tables, as well as convenience function to call assembly instructions typically not exposed in higher level languages.")
    (description
     "Library to program x86 (amd64) hardware.  Contains x86 specific data structure
descriptions, data-tables, as well as convenience function to call assembly
instructions typically not exposed in higher level languages.")
    (license license:expat)))

(define-public rust-libc-0.1
  (package
    (name "rust-libc")
    (version "0.1.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08k14zb7bw25avmaj227calcdglb4ac394kklr9nv175fp7p0ap3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-lang/libc")
    (synopsis "Raw FFI bindings to platform libraries like libc.
")
    (description "Raw FFI bindings to platform libraries like libc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-mmap-0.1
  (package
    (name "rust-mmap")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mmap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08xqhvr4l3rf1fkz2w4cwz3z5wd0m1jab1d34sxd4v80lr459j0b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.1)
                       ("rust-tempdir" ,rust-tempdir-0.3))))
    (home-page "https://github.com/rbranson/rust-mmap")
    (synopsis "A library for dealing with memory-mapped I/O
")
    (description
     "This package provides a library for dealing with memory-mapped I/O")
    (license license:expat)))

(define-public rust-perfcnt-0.8
  (package
    (name "rust-perfcnt")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "perfcnt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "008mrdd8zjk54qg8xh8crk9is98sxv2c0kk2v25nzjkhaaazv8ab"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mmap" ,rust-mmap-0.1)
                       ("rust-nom" ,rust-nom-4)
                       ("rust-x86" ,rust-x86-0.47))))
    (home-page "https://github.com/gz/rust-perfcnt")
    (synopsis
     "Library to configure and read hardware performance counters in rust.")
    (description
     "Library to configure and read hardware performance counters in rust.")
    (license license:expat)))

(define-public rust-halfbrown-0.2
  (package
    (name "rust-halfbrown")
    (version "0.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "halfbrown" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1v5h9hhyx29ac18rr8csvl0m7m39qy99h52zdqwl9zyxaisi70an"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-hashbrown" ,rust-hashbrown-0.13)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Licenser/halfbrown")
    (synopsis
     "Multi backend HashMap for higher performance on different key space sizes")
    (description
     "Multi backend @code{HashMap} for higher performance on different key space sizes")
    (license (list license:asl2.0 license:expat))))

(define-public rust-alloc-counter-macro-0.0.2
  (package
    (name "rust-alloc-counter-macro")
    (version "0.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "alloc_counter_macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nifqalryavmrdlkyv7cznp8yfjj16x0bjqzvjndw0fxk8gzhlhs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "")
    (synopsis "The #[no_alloc] macro for the alloc_counter crate.")
    (description "The #[no_alloc] macro for the alloc_counter crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-alloc-counter-0.0.4
  (package
    (name "rust-alloc-counter")
    (version "0.0.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "alloc_counter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1agxzprqi37bcy9hh3clbsl3n0awbb34vrlv4rp5afib8w53m31s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-alloc-counter-macro" ,rust-alloc-counter-macro-0.0.2)
                       ("rust-pin-utils" ,rust-pin-utils-0.1))))
    (home-page "https://gitlab.com/sio4/code/alloc-counter")
    (synopsis
     "Count allocations, reallocations, deallocations. Allow, deny, or forbid allocations on an expression or function basis.")
    (description
     "Count allocations, reallocations, deallocations.  Allow, deny, or forbid
allocations on an expression or function basis.")
    (license (list license:expat license:asl2.0))))

(define-public rust-simd-json-0.10
  (package
    (name "rust-simd-json")
    (version "0.10.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "simd-json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1syqpnymzlafk289zcvl43gf4asp0bsxdpf4gy36a2a05ky1vsl0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-alloc-counter" ,rust-alloc-counter-0.0.4)
                       ("rust-beef" ,rust-beef-0.5)
                       ("rust-colored" ,rust-colored-2)
                       ("rust-getopts" ,rust-getopts-0.2)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-halfbrown" ,rust-halfbrown-0.2)
                       ("rust-jemallocator" ,rust-jemallocator-0.5)
                       ("rust-lexical-core" ,rust-lexical-core-0.8)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-perfcnt" ,rust-perfcnt-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-simdutf8" ,rust-simdutf8-0.1)
                       ("rust-value-trait" ,rust-value-trait-0.6))))
    (home-page "https://github.com/simd-lite/simd-json")
    (synopsis "High performance JSON parser based on a port of simdjson")
    (description "High performance JSON parser based on a port of simdjson")
    (license (list license:asl2.0 license:expat))))

(define-public rust-polars-json-0.33
  (package
    (name "rust-polars-json")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f3ya8bg0k4vpsgqz59xifa92cy8jxssa1jsxxm710fnfrhndmfn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-fallible-streaming-iterator" ,rust-fallible-streaming-iterator-0.1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-simd-json" ,rust-simd-json-0.10))))
    (home-page "https://www.pola.rs/")
    (synopsis "JSON related logic for the Polars DataFrame library")
    (description "JSON related logic for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-memmap2-0.7
  (package
    (name "rust-memmap2")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memmap2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1il82b0mw304jlwvl0m89aa8bj5dgmm3vbb0jg8lqlrk0p98i4zl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))))
    (home-page "https://github.com/RazrFalcon/memmap2-rs")
    (synopsis "Cross-platform Rust API for memory-mapped file IO")
    (description "Cross-platform Rust API for memory-mapped file IO")
    (license (list license:expat license:asl2.0))))

(define-public rust-sval-test-2
  (package
    (name "rust-sval-test")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_test" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bgbcdl7vniil0xiyvxscmzcwymhz2w2iywqgxjmc5c0krzg0hd4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval" ,rust-sval-2)
                       ("rust-sval-fmt" ,rust-sval-fmt-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Utilities for testing sval::Value implementations")
    (description "Utilities for testing sval::Value implementations")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-serde-2
  (package
    (name "rust-sval-serde")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11h543cmg0qmprc7jn94crfxwv344wa04qf18hw7xdh5zz293wbz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-sval" ,rust-sval-2)
                       ("rust-sval-buffer" ,rust-sval-buffer-2)
                       ("rust-sval-fmt" ,rust-sval-fmt-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Integration between serde::Serialize and sval::Value")
    (description "Integration between serde::Serialize and sval::Value")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-json-2
  (package
    (name "rust-sval-json")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wp0yyaldqr6kgqsblav86j8fxjp2jbmrsbsiw0yxrhambc3pq3n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-sval" ,rust-sval-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "JSON support for sval")
    (description "JSON support for sval")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-fmt-2
  (package
    (name "rust-sval-fmt")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_fmt" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hqkjb7blcdqjlawnffmw0bq5gxf98i52lbgcnjabxr64a47ybsk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-sval" ,rust-sval-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Integration between std::fmt::Debug and sval::Value")
    (description "Integration between std::fmt::Debug and sval::Value")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-dynamic-2
  (package
    (name "rust-sval-dynamic")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_dynamic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f2p3xvq5qyg0w721as7dxrgqgrfqsc0m7qp2r1pn7fvkqjx54wx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval" ,rust-sval-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Object-safe versions of sval::Stream and sval::Value")
    (description "Object-safe versions of sval::Stream and sval::Value")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-buffer-2
  (package
    (name "rust-sval-buffer")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_buffer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yglk3ma67605f28mwip09maf531mm1fak2pdr2a1klapib0bs2p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval" ,rust-sval-2)
                       ("rust-sval-ref" ,rust-sval-ref-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Value buffering for sval")
    (description "Value buffering for sval")
    (license (list license:asl2.0 license:expat))))

(define-public rust-value-bag-sval2-1
  (package
    (name "rust-value-bag-sval2")
    (version "1.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "value-bag-sval2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i899mjnryxw0sp92n8qgnm1s2m56ba27l3qazsbnmqah486rq63"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval" ,rust-sval-2)
                       ("rust-sval-buffer" ,rust-sval-buffer-2)
                       ("rust-sval-dynamic" ,rust-sval-dynamic-2)
                       ("rust-sval-fmt" ,rust-sval-fmt-2)
                       ("rust-sval-json" ,rust-sval-json-2)
                       ("rust-sval-ref" ,rust-sval-ref-2)
                       ("rust-sval-serde" ,rust-sval-serde-2)
                       ("rust-sval-test" ,rust-sval-test-2))))
    (home-page "")
    (synopsis "Implementation detail for value-bag")
    (description "Implementation detail for value-bag")
    (license (list license:asl2.0 license:expat))))

(define-public rust-serde-buf-0.1
  (package
    (name "rust-serde-buf")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_buf" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k2nc3pa7rbzyhhnjakw6nkx2wa6da6nrxf65s6p2d3xdjfvx1is"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/KodrAus/serde_buf.git")
    (synopsis "Generic buffering for serde")
    (description "Generic buffering for serde")
    (license (list license:asl2.0 license:expat))))

(define-public rust-value-bag-serde1-1
  (package
    (name "rust-value-bag-serde1")
    (version "1.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "value-bag-serde1" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gsp0cn62ay2qq52wzck0j66iavf9k03y6ipmnx3bjqyg7f3kfh7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-erased-serde" ,rust-erased-serde-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-buf" ,rust-serde-buf-0.1)
                       ("rust-serde-fmt" ,rust-serde-fmt-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-test" ,rust-serde-test-1))))
    (home-page "")
    (synopsis "Implementation detail for value-bag")
    (description "Implementation detail for value-bag")
    (license (list license:asl2.0 license:expat))))

(define-public rust-value-bag-1
  (package
    (name "rust-value-bag")
    (version "1.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "value-bag" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gjvsnhhf9jp8h62zin6azqrpmgmnxq2ppj72d2dcayy5n8f2wja"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-value-bag-serde1" ,rust-value-bag-serde1-1)
                       ("rust-value-bag-sval2" ,rust-value-bag-sval2-1))))
    (home-page "https://github.com/sval-rs/value-bag")
    (synopsis "Anonymous structured values")
    (description "Anonymous structured values")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-ref-2
  (package
    (name "rust-sval-ref")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_ref" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qd9w4iqp8z7v0mf7icz1409g48jnibyrh9nbnms1hmq5x7hbvbm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval" ,rust-sval-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "A variant of sval::Value for types with internal references")
    (description
     "This package provides a variant of sval::Value for types with internal
references")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-derive-macros-2
  (package
    (name "rust-sval-derive-macros")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval_derive_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11vmfpr028n4z9x0nlaqa1v7p4fij6fz7wxbr3mmizp9v6267nry"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Minimal derive support for `sval`")
    (description "Minimal derive support for `sval`")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sval-2
  (package
    (name "rust-sval")
    (version "2.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sval" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wq8dpcwkxf9i5ivaqgi736kalqdsn88yhsb9fh1dhmpilmg2pdi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-sval-derive-macros" ,rust-sval-derive-macros-2))))
    (home-page "https://github.com/sval-rs/sval")
    (synopsis "Streaming, structured value serialization")
    (description "Streaming, structured value serialization")
    (license (list license:asl2.0 license:expat))))

(define-public rust-log-0.4
  (package
    (name "rust-log")
    (version "0.4.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "log" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13rf7wphnwd61vazpxr7fiycin6cb1g8fmvgqg18i464p0y1drmm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-sval" ,rust-sval-2)
                       ("rust-sval-ref" ,rust-sval-ref-2)
                       ("rust-value-bag" ,rust-value-bag-1))))
    (home-page "https://github.com/rust-lang/log")
    (synopsis "A lightweight logging facade for Rust
")
    (description "This package provides a lightweight logging facade for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-memchr-2
  (package
    (name "rust-memchr")
    (version "2.6.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memchr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rq1ka8790ns41j147npvxcqcl2anxyngsdimy85ag2api0fwrgn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/BurntSushi/memchr")
    (synopsis
     "Provides extremely fast (uses SIMD on x86_64, aarch64 and wasm32) routines for
1, 2 or 3 byte search and single substring search.
")
    (description
     "This package provides extremely fast (uses SIMD on x86_64, aarch64 and wasm32)
routines for 1, 2 or 3 byte search and single substring search.")
    (license (list license:unlicense license:expat))))

(define-public rust-home-0.5
  (package
    (name "rust-home")
    (version "0.5.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "home" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nqx1krijvpd03d96avsdyknd12h8hs3xhxwgqghf8v9xxzc4i2l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/rust-lang/cargo")
    (synopsis "Shared definitions of home directories.")
    (description "Shared definitions of home directories.")
    (license (list license:expat license:asl2.0))))

(define-public rust-polars-io-0.33
  (package
    (name "rust-polars-io")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-io" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0d0zrwwbg2y2sdsvfyzwfrdarm0anndd3pxwvwhar44aq64lmkw8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-fast-float" ,rust-fast-float-0.2)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-home" ,rust-home-0.5)
                       ("rust-lexical" ,rust-lexical-6)
                       ("rust-lexical-core" ,rust-lexical-core-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-memmap2" ,rust-memmap2-0.7)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-object-store" ,rust-object-store-0.7)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-polars-json" ,rust-polars-json-0.33)
                       ("rust-polars-time" ,rust-polars-time-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-simd-json" ,rust-simd-json-0.10)
                       ("rust-simdutf8" ,rust-simdutf8-0.1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://www.pola.rs/")
    (synopsis "IO related logic for the Polars DataFrame library")
    (description "IO related logic for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-polars-lazy-0.33
  (package
    (name "rust-polars-lazy")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-lazy" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kqgcfr4y1rka9qv803hf3yn7chvnb2znhgmqlf9i34472sfl42i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-io" ,rust-polars-io-0.33)
                       ("rust-polars-json" ,rust-polars-json-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33)
                       ("rust-polars-pipe" ,rust-polars-pipe-0.33)
                       ("rust-polars-plan" ,rust-polars-plan-0.33)
                       ("rust-polars-time" ,rust-polars-time-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-pyo3" ,rust-pyo3-0.19)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "Lazy query engine for the Polars DataFrame library")
    (description "Lazy query engine for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-xxhash-rust-0.8
  (package
    (name "rust-xxhash-rust")
    (version "0.8.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "xxhash-rust" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yz037yrkn0qa0g0r6733ynd1xbw7zvx58v6qylhyi2kv9wb2a4q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/DoumanAsh/xxhash-rust")
    (synopsis "Implementation of xxhash")
    (description "Implementation of xxhash")
    (license license:boost1.0)))

(define-public rust-polars-utils-0.33
  (package
    (name "rust-polars-utils")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xnfycj4fd8c1x53b8w3hisf57rjdvah94fkr8i662896ms5wjia"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-sysinfo" ,rust-sysinfo-0.29)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "Private utils for the Polars DataFrame library")
    (description "Private utils for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-polars-row-0.33
  (package
    (name "rust-polars-row")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-row" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1b0kqc1vpsfgqb6ij771yxizqydd46mzp54mhd4gh4wxbf4ghbn5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33))))
    (home-page "https://www.pola.rs/")
    (synopsis "Row encodings for the Polars DataFrame library")
    (description "Row encodings for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-polars-error-0.33
  (package
    (name "rust-polars-error")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-error" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jgrll191qrckm79a5mrh15rc5z05kf1jn4laj9rg6d2a6ba084v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-object-store" ,rust-object-store-0.7)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://www.pola.rs/")
    (synopsis "Error definitions for the Polars DataFrame library")
    (description "Error definitions for the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-atoi-2
  (package
    (name "rust-atoi")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atoi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a05h42fggmy7h0ajjv6m7z72l924i7igbx13hk9d8pyign9k3gj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/pacman82/atoi-rs")
    (synopsis "Parse integers directly from `[u8]` slices in safe code")
    (description "Parse integers directly from `[u8]` slices in safe code")
    (license license:expat)))

(define-public rust-polars-arrow-0.33
  (package
    (name "rust-polars-arrow")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-arrow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a0qgzcf8p9vz3z3nd8xk1f9j71k6qx47zaf1sczv2dk9yk3ik9m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-atoi" ,rust-atoi-2)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-ethnum" ,rust-ethnum-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-multiversion" ,rust-multiversion-0.7)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "Arrow interfaces for Polars DataFrame library")
    (description "Arrow interfaces for Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-quick-xml-0.30
  (package
    (name "rust-quick-xml")
    (version "0.30.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quick-xml" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mp9cqy06blsaka3r1n2p40ddmzhsf7bx37x22r5faw6hq753xpg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/tafia/quick-xml")
    (synopsis "High performance xml reader and writer")
    (description "High performance xml reader and writer")
    (license license:expat)))

(define-public rust-object-store-0.7
  (package
    (name "rust-object-store")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "object_store" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d5w3r2nbvdj5mihqlw1phnqi2dbmys9br6zfvkzdhxi8f5chc7r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-humantime" ,rust-humantime-2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-quick-xml" ,rust-quick-xml-0.30)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-reqwest" ,rust-reqwest-0.11)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-snafu" ,rust-snafu-0.7)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-url" ,rust-url-2)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://github.com/apache/arrow-rs/tree/master/object_store")
    (synopsis
     "A generic object store interface for uniformly interacting with AWS S3, Google Cloud Storage, Azure Blob Storage and local files.")
    (description
     "This package provides a generic object store interface for uniformly interacting
with AWS S3, Google Cloud Storage, Azure Blob Storage and local files.")
    (license (list license:expat license:asl2.0))))

(define-public rust-comfy-table-7
  (package
    (name "rust-comfy-table")
    (version "7.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "comfy-table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nrsv0iqzfw866csjfmflnl15wwmp4qicn20vgqg7jnyiaypvdws"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-console" ,rust-console-0.15)
                       ("rust-crossterm" ,rust-crossterm-0.26)
                       ("rust-strum" ,rust-strum-0.24)
                       ("rust-strum-macros" ,rust-strum-macros-0.24)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/nukesor/comfy-table")
    (synopsis
     "An easy to use library for building beautiful tables with automatic content wrapping")
    (description
     "An easy to use library for building beautiful tables with automatic content
wrapping")
    (license license:expat)))

(define-public rust-simdutf8-0.1
  (package
    (name "rust-simdutf8")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "simdutf8" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fi6zvnldaw7g726wnm9vvpv4s89s5jsk7fgp3rg2l99amw64zzj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rusticstuff/simdutf8")
    (synopsis "SIMD-accelerated UTF-8 validation.")
    (description "SIMD-accelerated UTF-8 validation.")
    (license (list license:expat license:asl2.0))))

(define-public rust-zstd-safe-6
  (package
    (name "rust-zstd-safe")
    (version "6.0.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zstd-safe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10cm0v8sw3jz3pi0wlwx9mbb2l25lm28w638a5n5xscfnk8gz67f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-zstd-sys" ,rust-zstd-sys-2))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Safe low-level bindings for the zstd compression library.")
    (description "Safe low-level bindings for the zstd compression library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-zstd-0.12
  (package
    (name "rust-zstd")
    (version "0.12.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zstd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0g654jj8z25rvzli2b1231pcp9y7n6vk44jaqwgifh9n2xg5j9qs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zstd-safe" ,rust-zstd-safe-6))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Binding for the zstd compression library.")
    (description "Binding for the zstd compression library.")
    (license license:expat)))

(define-public rust-snap-1
  (package
    (name "rust-snap")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "snap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0c882cs4wbyi34nw8njpxa729gyi6sj71h8rj4ykbdvyxyv0m7sy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/BurntSushi/rust-snappy")
    (synopsis
     "A pure Rust implementation of the Snappy compression algorithm. Includes
streaming compression and decompression.
")
    (description
     "This package provides a pure Rust implementation of the Snappy compression
algorithm.  Includes streaming compression and decompression.")
    (license license:bsd-3)))

(define-public rust-seq-macro-0.3
  (package
    (name "rust-seq-macro")
    (version "0.3.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "seq-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d50kbaslrrd0374ivx15jg57f03y5xzil1wd2ajlvajzlkbzw53"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dtolnay/seq-macro")
    (synopsis
     "Macro to repeat sequentially indexed copies of a fragment of code.")
    (description
     "Macro to repeat sequentially indexed copies of a fragment of code.")
    (license (list license:expat license:asl2.0))))

(define-public rust-parquet-format-safe-0.2
  (package
    (name "rust-parquet-format-safe")
    (version "0.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "parquet-format-safe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07wf6wf4jrxlq5p3xldxsnabp7jl06my2qp7kiwy9m3x2r5wac8i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-futures" ,rust-futures-0.3))))
    (home-page "https://github.com/jorgecarleitao/parquet-format-safe")
    (synopsis "Safe Parquet and Thrift reader and writer (sync and async)")
    (description "Safe Parquet and Thrift reader and writer (sync and async)")
    (license (list license:expat license:asl2.0))))

(define-public rust-twox-hash-1
  (package
    (name "rust-twox-hash")
    (version "1.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "twox-hash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xgn72j36a270l5ls1jk88n7bmq2dhlfkbhdh5554hbagjsydzlp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-digest" ,rust-digest-0.8)
                       ("rust-digest" ,rust-digest-0.9)
                       ("rust-digest" ,rust-digest-0.10)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-static-assertions" ,rust-static-assertions-1))))
    (home-page "https://github.com/shepmaster/twox-hash")
    (synopsis "A Rust implementation of the XXHash and XXH3 algorithms")
    (description
     "This package provides a Rust implementation of the XXHash and XXH3 algorithms")
    (license license:expat)))

(define-public rust-lz4-flex-0.9
  (package
    (name "rust-lz4-flex")
    (version "0.9.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lz4_flex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18xm7s81bpfgvvrra2kknrbgfbi295diz90mkhxvr00phfrbp30s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-twox-hash" ,rust-twox-hash-1))))
    (home-page "https://github.com/pseitz/lz4_flex")
    (synopsis "Fastest LZ4 implementation in Rust, no unsafe by default.")
    (description "Fastest LZ4 implementation in Rust, no unsafe by default.")
    (license license:expat)))

(define-public rust-async-stream-impl-0.3
  (package
    (name "rust-async-stream-impl")
    (version "0.3.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-stream-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14q179j4y8p2z1d0ic6aqgy9fhwz8p9cai1ia8kpw4bw7q12mrhn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/tokio-rs/async-stream")
    (synopsis "proc macros for async-stream crate")
    (description "proc macros for async-stream crate")
    (license license:expat)))

(define-public rust-async-stream-0.3
  (package
    (name "rust-async-stream")
    (version "0.3.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-stream" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0l8sjq1rylkb1ak0pdyjn83b3k6x36j22myngl4sqqgg7whdsmnd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-stream-impl" ,rust-async-stream-impl-0.3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2))))
    (home-page "https://github.com/tokio-rs/async-stream")
    (synopsis "Asynchronous streams using async & await notation")
    (description "Asynchronous streams using async & await notation")
    (license license:expat)))

(define-public rust-parquet2-0.17
  (package
    (name "rust-parquet2")
    (version "0.17.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "parquet2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kiv50rj44y6flsa2879wi4kwsfldwhyvgrnybaz7kh2bxsfb7sp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-stream" ,rust-async-stream-0.3)
                       ("rust-brotli" ,rust-brotli-3)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-lz4" ,rust-lz4-1)
                       ("rust-lz4-flex" ,rust-lz4-flex-0.9)
                       ("rust-parquet-format-safe" ,rust-parquet-format-safe-0.2)
                       ("rust-seq-macro" ,rust-seq-macro-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-snap" ,rust-snap-1)
                       ("rust-streaming-decompression" ,rust-streaming-decompression-0.1)
                       ("rust-xxhash-rust" ,rust-xxhash-rust-0.8)
                       ("rust-zstd" ,rust-zstd-0.12))))
    (home-page "https://github.com/jorgecarleitao/parquet2")
    (synopsis "Safe implementation of parquet IO.")
    (description "Safe implementation of parquet IO.")
    (license license:asl2.0)))

(define-public rust-orc-format-0.3
  (package
    (name "rust-orc-format")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "orc-format" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02qzqhy1zx9bmylvkmbjrc2mxyddjgn2sqiwwd7kr9zh2p7jsaj0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fallible-streaming-iterator" ,rust-fallible-streaming-iterator-0.1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-prost" ,rust-prost-0.9))))
    (home-page "https://github.com/DataEngineeringLabs/orc-format")
    (synopsis "Unofficial implementation of Apache ORC spec in safe Rust")
    (description "Unofficial implementation of Apache ORC spec in safe Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-odbc-sys-0.21
  (package
    (name "rust-odbc-sys")
    (version "0.21.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "odbc-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "024gylzq3q7s6b10qhbb8cjis6aj8a83jay553jdsiwgwm65qb2r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/pacman82/odbc-sys")
    (synopsis "ODBC ffi bindings")
    (description "ODBC ffi bindings")
    (license license:expat)))

(define-public rust-force-send-sync-1
  (package
    (name "rust-force-send-sync")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "force-send-sync" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dpy69psypanm8mx3k0mjmvb0mccyyd8yffcdr1899la8k68ss1j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/pacman82/force-send-sync")
    (synopsis "Unsafe wrappers to force Send and Sync.")
    (description "Unsafe wrappers to force Send and Sync.")
    (license license:expat)))

(define-public rust-odbc-api-0.36
  (package
    (name "rust-odbc-api")
    (version "0.36.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "odbc-api" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04xcqqhm7w24b1gj6v4b24z9j65r1zzyxjadlv3xf73fm92cmnd3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-force-send-sync" ,rust-force-send-sync-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-odbc-sys" ,rust-odbc-sys-0.21)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-widestring" ,rust-widestring-0.5)
                       ("rust-winit" ,rust-winit-0.26))))
    (home-page "https://github.com/pacman82/odbc-api")
    (synopsis "Write ODBC Applications in (mostly) safe Rust.")
    (description "Write ODBC Applications in (mostly) safe Rust.")
    (license license:expat)))

(define-public rust-target-features-0.1
  (package
    (name "rust-target-features")
    (version "0.1.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "target-features" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gb974chm9aj8ifkyibylxkyb5an4bf5y8dxb18pqmck698gmdfg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/calebzulawski/target-features")
    (synopsis "Rust compiler target feature database")
    (description "Rust compiler target feature database")
    (license (list license:expat license:asl2.0))))

(define-public rust-multiversion-macros-0.7
  (package
    (name "rust-multiversion-macros")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multiversion-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j1avbxw7jscyi7dmnywhlwbiny1fvg1vpp9fy4dc1pd022kva16"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-target-features" ,rust-target-features-0.1))))
    (home-page "https://github.com/calebzulawski/multiversion")
    (synopsis "Implementation crate for multiversion")
    (description "Implementation crate for multiversion")
    (license (list license:expat license:asl2.0))))

(define-public rust-multiversion-0.7
  (package
    (name "rust-multiversion")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multiversion" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0al7yrf489lqzxx291sx9566n7slk2njwlqrxbjhqxk1zvbvkixj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-multiversion-macros" ,rust-multiversion-macros-0.7)
                       ("rust-target-features" ,rust-target-features-0.1))))
    (home-page "https://github.com/calebzulawski/multiversion")
    (synopsis "Easy function multiversioning")
    (description "Easy function multiversioning")
    (license (list license:expat license:asl2.0))))

(define-public rust-lz4-sys-1
  (package
    (name "rust-lz4-sys")
    (version "1.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lz4-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0059ik4xlvnss5qfh6l691psk4g3350ljxaykzv10yr0gqqppljp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/10xGenomics/lz4-rs")
    (synopsis "Rust LZ4 sys package.")
    (description "Rust LZ4 sys package.")
    (license license:expat)))

(define-public rust-lz4-1
  (package
    (name "rust-lz4")
    (version "1.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lz4" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wad97k0asgvaj16ydd09gqs2yvgaanzcvqglrhffv7kdpc2v7ky"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-lz4-sys" ,rust-lz4-sys-1))))
    (home-page "https://github.com/10xGenomics/lz4-rs")
    (synopsis "Rust LZ4 bindings library.")
    (description "Rust LZ4 bindings library.")
    (license license:expat)))

(define-public rust-json-deserializer-0.4
  (package
    (name "rust-json-deserializer")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "json-deserializer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gv8qa9bprcw0ypz4kmpp844yfjg1dpzayk7xc5i1d3fw4hv8qsz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1))))
    (home-page "https://github.com/jorgecarleitao/json-deserializer")
    (synopsis "Performant library to deserialize JSON")
    (description "Performant library to deserialize JSON")
    (license license:asl2.0)))

(define-public rust-foreign-vec-0.1
  (package
    (name "rust-foreign-vec")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "foreign_vec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wv6p8yfahcqbdg2wg7wxgj4dm32g2b6spa5sg5sxg34v35ha6zf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/DataEngineeringLabs/foreign_vec")
    (synopsis "Unofficial implementation of Apache Arrow spec in safe Rust")
    (description "Unofficial implementation of Apache Arrow spec in safe Rust")
    (license license:expat)))

(define-public rust-ethnum-macros-1
  (package
    (name "rust-ethnum-macros")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ethnum-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0haq14b9jzs7qxi7mj6d7vx80rmd62b1jsmldfa2z786mc8vlsds"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/nlordell/ethnum-rs")
    (synopsis "256-bit integer literals")
    (description "256-bit integer literals")
    (license (list license:expat license:asl2.0))))

(define-public rust-ethnum-intrinsics-1
  (package
    (name "rust-ethnum-intrinsics")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ethnum-intrinsics" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qvb1r3vmnk5nplz6x1014rn6b9nfnig2qmlj8hi3jpq75j8cgh9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1))))
    (home-page "https://github.com/nlordell/ethnum-rs")
    (synopsis "LLVM generated 256-bit integer intrinsics")
    (description "LLVM generated 256-bit integer intrinsics")
    (license (list license:expat license:asl2.0))))

(define-public rust-ethnum-1
  (package
    (name "rust-ethnum")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ethnum" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1b5d4j4al7f40sq717bbrkiifgxvbgyfpvh6zfvpylpsna1g73vc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ethnum-intrinsics" ,rust-ethnum-intrinsics-1)
                       ("rust-ethnum-macros" ,rust-ethnum-macros-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/nlordell/ethnum-rs")
    (synopsis "256-bit integer implementation")
    (description "256-bit integer implementation")
    (license (list license:expat license:asl2.0))))

(define-public rust-either-1
  (package
    (name "rust-either")
    (version "1.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "either" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01qy3anr7jal5lpc20791vxrw0nl6vksb5j7x56q2fycgcyy8sm2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/bluss/either")
    (synopsis
     "The enum `Either` with variants `Left` and `Right` is a general purpose sum type with two cases.
")
    (description
     "The enum `Either` with variants `Left` and `Right` is a general purpose sum type
with two cases.")
    (license (list license:expat license:asl2.0))))

(define-public rust-csv-async-1
  (package
    (name "rust-csv-async")
    (version "1.2.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "csv-async" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x26022nqkhr120dz2n5ir2n26cnnqapp0dj3h8xb0845lzkv4vi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bstr" ,rust-bstr-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-csv-core" ,rust-csv-core-0.1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1))))
    (home-page "https://github.com/gwierzchowski/csv-async")
    (synopsis "CSV parsing for async.")
    (description "CSV parsing for async.")
    (license license:expat)))

(define-public rust-comfy-table-6
  (package
    (name "rust-comfy-table")
    (version "6.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "comfy-table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fmqjhry6xa6a9kr0769wiw06694n60kxs5c6nfvzqv8h9w9v5by"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-console" ,rust-console-0.15)
                       ("rust-crossterm" ,rust-crossterm-0.26)
                       ("rust-strum" ,rust-strum-0.24)
                       ("rust-strum-macros" ,rust-strum-macros-0.24)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/nukesor/comfy-table")
    (synopsis
     "An easy to use library for building beautiful tables with automatic content wrapping")
    (description
     "An easy to use library for building beautiful tables with automatic content
wrapping")
    (license license:expat)))

(define-public rust-avro-schema-0.3
  (package
    (name "rust-avro-schema")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "avro-schema" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gbvciwvi2isa6qanbzi4lbqzzgvhdlzjyzlsa29dflsndaiha5m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-stream" ,rust-async-stream-0.3)
                       ("rust-crc" ,rust-crc-2)
                       ("rust-fallible-streaming-iterator" ,rust-fallible-streaming-iterator-0.1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libflate" ,rust-libflate-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-snap" ,rust-snap-1))))
    (home-page "https://github.com/DataEngineeringLabs/avro-schema")
    (synopsis "Apache Avro specification")
    (description "Apache Avro specification")
    (license (list license:expat license:asl2.0))))

(define-public rust-tower-layer-0.3
  (package
    (name "rust-tower-layer")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower-layer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l7i17k9vlssrdg4s3b0ia5jjkmmxsvv8s9y9ih0jfi8ssz8s362"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/tower-rs/tower")
    (synopsis
     "Decorates a `Service` to allow easy composition between `Service`s.
")
    (description
     "Decorates a `Service` to allow easy composition between `Service`s.")
    (license license:expat)))

(define-public rust-tower-service-0.3
  (package
    (name "rust-tower-service")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower-service" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lmfzmmvid2yp2l36mbavhmqgsvzqf7r2wiwz73ml4xmwaf1rg5n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/tower-rs/tower")
    (synopsis
     "Trait representing an asynchronous, request / response based, client or server.
")
    (description
     "Trait representing an asynchronous, request / response based, client or server.")
    (license license:expat)))

(define-public rust-hdrhistogram-7
  (package
    (name "rust-hdrhistogram")
    (version "7.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hdrhistogram" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1a1al1rfxcqmx0n9h100ggvg036f4rv69fq12kimazvw9zsvj6bz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-nom" ,rust-nom-7)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/HdrHistogram/HdrHistogram_rust")
    (synopsis "A port of HdrHistogram to Rust")
    (description "This package provides a port of @code{HdrHistogram} to Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-tower-0.4
  (package
    (name "rust-tower")
    (version "0.4.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "073wncyqav4sak1p755hf6vl66njgfc1z1g1di9rxx3cvvh9pymq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-hdrhistogram" ,rust-hdrhistogram-7)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower-layer" ,rust-tower-layer-0.3)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/tower-rs/tower")
    (synopsis
     "Tower is a library of modular and reusable components for building robust
clients and servers.
")
    (description
     "Tower is a library of modular and reusable components for building robust
clients and servers.")
    (license license:expat)))

(define-public rust-webpki-roots-0.25
  (package
    (name "rust-webpki-roots")
    (version "0.25.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "webpki-roots" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z13850xvsijjxxvzx1wq3m6pz78ih5q6wjcp7gpgwz4gfspn90l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rustls/webpki-roots")
    (synopsis "Mozilla's CA root certificates for use with webpki")
    (description "Mozilla's CA root certificates for use with webpki")
    (license license:mpl2.0)))

(define-public rust-webpki-roots-0.24
  (package
    (name "rust-webpki-roots")
    (version "0.24.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "webpki-roots" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "120q85pvzpckvvrg085a5jhh91fby94pgiv9y1san7lxbmnm94dj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustls-webpki" ,rust-rustls-webpki-0.101))))
    (home-page "https://github.com/rustls/webpki-roots")
    (synopsis "Mozilla's CA root certificates for use with webpki")
    (description "Mozilla's CA root certificates for use with webpki")
    (license license:mpl2.0)))

(define-public rust-tungstenite-0.20
  (package
    (name "rust-tungstenite")
    (version "0.20.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tungstenite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fbgcv3h4h1bhhf5sqbwqsp7jnc44bi4m41sgmhzdsk2zl8aqgcy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-data-encoding" ,rust-data-encoding-2)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-sha1" ,rust-sha1-0.10)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-url" ,rust-url-2)
                       ("rust-utf-8" ,rust-utf-8-0.7)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.24))))
    (home-page "https://github.com/snapview/tungstenite-rs")
    (synopsis "Lightweight stream-based WebSocket implementation")
    (description "Lightweight stream-based @code{WebSocket} implementation")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-rustls-0.24
  (package
    (name "rust-tokio-rustls")
    (version "0.24.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-rustls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10bhibg57mqir7xjhb2xmf24xgfpx6fzpyw720a4ih8a737jg0y2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustls" ,rust-rustls-0.21)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/rustls/tokio-rustls")
    (synopsis "Asynchronous TLS/SSL streams for Tokio using Rustls.")
    (description "Asynchronous TLS/SSL streams for Tokio using Rustls.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-native-tls-0.3
  (package
    (name "rust-tokio-native-tls")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-native-tls" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wkfg6zn85zckmv4im7mv20ca6b1vmlib5xwz9p7g19wjfmpdbmv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://tokio.rs")
    (synopsis
     "An implementation of TLS/SSL streams for Tokio using native-tls giving an implementation of TLS
for nonblocking I/O streams.
")
    (description
     "An implementation of TLS/SSL streams for Tokio using native-tls giving an
implementation of TLS for nonblocking I/O streams.")
    (license license:expat)))

(define-public rust-rustls-native-certs-0.6
  (package
    (name "rust-rustls-native-certs")
    (version "0.6.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustls-native-certs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "007zind70rd5rfsrkdcfm8vn09j8sg02phg9334kark6rdscxam9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-openssl-probe" ,rust-openssl-probe-0.1)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-schannel" ,rust-schannel-0.1)
                       ("rust-security-framework" ,rust-security-framework-2))))
    (home-page "https://github.com/ctz/rustls-native-certs")
    (synopsis
     "rustls-native-certs allows rustls to use the platform native certificate store")
    (description
     "rustls-native-certs allows rustls to use the platform native certificate store")
    (license (list license:asl2.0 license:isc license:expat))))

(define-public rust-tokio-tungstenite-0.20
  (package
    (name "rust-tokio-tungstenite")
    (version "0.20.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-tungstenite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0v1v24l27hxi5hlchs7hfd5rgzi167x0ygbw220nvq0w5b5msb91"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tungstenite" ,rust-tungstenite-0.20)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.25))))
    (home-page "https://github.com/snapview/tokio-tungstenite")
    (synopsis
     "Tokio binding for Tungstenite, the Lightweight stream-based WebSocket implementation")
    (description
     "Tokio binding for Tungstenite, the Lightweight stream-based @code{WebSocket}
implementation")
    (license license:expat)))

(define-public rust-sync-wrapper-0.1
  (package
    (name "rust-sync-wrapper")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sync_wrapper" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0q01lyj0gr9a93n10nxsn8lwbzq97jqd6b768x17c8f7v7gccir0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3))))
    (home-page "https://docs.rs/sync_wrapper")
    (synopsis
     "A tool for enlisting the compilerâs help in proving the absence of concurrency")
    (description
     "This package provides a tool for enlisting the compilerâs help in proving the
absence of concurrency")
    (license license:asl2.0)))

(define-public rust-multer-2
  (package
    (name "rust-multer")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "multer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hjiphaypj3phqaj5igrzcia9xfmf4rr4ddigbh8zzb96k1bvb01"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-spin" ,rust-spin-0.9)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://github.com/rousan/multer-rs")
    (synopsis
     "An async parser for `multipart/form-data` content-type in Rust.")
    (description
     "An async parser for `multipart/form-data` content-type in Rust.")
    (license license:expat)))

(define-public rust-matchit-0.7
  (package
    (name "rust-matchit")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "matchit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "156bgdmmlv4crib31qhgg49nsjk88dxkdqp80ha2pk2rk6n6ax0f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/ibraheemdev/matchit")
    (synopsis "A high performance, zero-copy URL router.")
    (description
     "This package provides a high performance, zero-copy URL router.")
    (license (list license:expat license:bsd-3))))

(define-public rust-base64-0.21
  (package
    (name "rust-base64")
    (version "0.21.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "base64" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18jhmsli1l7zn6pgslgjdrnghqnz12g68n25fv48ids3yfk3x94v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/marshallpierce/rust-base64")
    (synopsis "encodes and decodes base64 as bytes or utf8")
    (description "encodes and decodes base64 as bytes or utf8")
    (license (list license:expat license:asl2.0))))

(define-public rust-headers-0.3
  (package
    (name "rust-headers")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "headers" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w62gnwh2p1lml0zqdkrx9dp438881nhz32zrzdy61qa0a9kns06"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-headers-core" ,rust-headers-core-0.2)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-httpdate" ,rust-httpdate-1)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-sha1" ,rust-sha1-0.10))))
    (home-page "https://hyper.rs")
    (synopsis "typed HTTP headers")
    (description "typed HTTP headers")
    (license license:expat)))

(define-public rust-axum-macros-0.3
  (package
    (name "rust-axum-macros")
    (version "0.3.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "axum-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qkb5cg06bnp8994ay0smk57shd5hpphcmp90kd7p65dxh86mjnd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/tokio-rs/axum")
    (synopsis "Macros for axum")
    (description "Macros for axum")
    (license license:expat)))

(define-public rust-mime-0.3
  (package
    (name "rust-mime")
    (version "0.3.17")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16hkibgvb9klh0w0jk5crr5xv90l3wlf77ggymzjmvl1818vnxv8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/hyperium/mime")
    (synopsis "Strongly Typed Mimes")
    (description "Strongly Typed Mimes")
    (license (list license:expat license:asl2.0))))

(define-public rust-iri-string-0.7
  (package
    (name "rust-iri-string")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "iri-string" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1h07hkfkkjjvgzlaqpr5fia7hrgv7qxqdw4xrpdc3936gmk9p191"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/lo48576/iri-string")
    (synopsis "IRI as string types")
    (description "IRI as string types")
    (license (list license:expat license:asl2.0))))

(define-public rust-http-range-header-0.3
  (package
    (name "rust-http-range-header")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "http-range-header" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13vm511vq3bhschkw2xi9nhxzkw53m55gn9vxg7qigfxc29spl5d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/MarcusGrass/parse-range-headers")
    (synopsis "No-dep range header parser")
    (description "No-dep range header parser")
    (license license:expat)))

(define-public rust-zstd-safe-7
  (package
    (name "rust-zstd-safe")
    (version "7.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zstd-safe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gpav2lcibrpmyslmjkcn3w0w64qif3jjljd2h8lr4p249s7qx23"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zstd-sys" ,rust-zstd-sys-2))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Safe low-level bindings for the zstd compression library.")
    (description "Safe low-level bindings for the zstd compression library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-zstd-0.13
  (package
    (name "rust-zstd")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zstd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0401q54s9r35x2i7m1kwppgkj79g0pb6xz3xpby7qlkdb44k7yxz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zstd-safe" ,rust-zstd-safe-7))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Binding for the zstd compression library.")
    (description "Binding for the zstd compression library.")
    (license license:expat)))

(define-public rust-deflate64-0.1
  (package
    (name "rust-deflate64")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "deflate64" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1aagh5mmyr8p08if33hizqwiq2as90v9smla89nydq6pivsfy766"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/anatawa12/deflate64-rs#readme")
    (synopsis "Deflate64 implementation based on .NET's implementation")
    (description "Deflate64 implementation based on .NET's implementation")
    (license license:expat)))

(define-public rust-async-compression-0.4
  (package
    (name "rust-async-compression")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-compression" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18lvgshffnnpvs8a0jgl04m56bz1p2zl4z0zdzra0nwixyxf4n7n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-brotli" ,rust-brotli-3)
                       ("rust-bzip2" ,rust-bzip2-0.4)
                       ("rust-deflate64" ,rust-deflate64-0.1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-xz2" ,rust-xz2-0.1)
                       ("rust-zstd" ,rust-zstd-0.13)
                       ("rust-zstd-safe" ,rust-zstd-safe-7))))
    (home-page "https://github.com/Nullus157/async-compression")
    (synopsis
     "Adaptors between compression crates and Rust's modern asynchronous IO types.
")
    (description
     "Adaptors between compression crates and Rust's modern asynchronous IO types.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tower-http-0.4
  (package
    (name "rust-tower-http")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower-http" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0h0i2flrw25zwxv72sifq4v5mwcb030spksy7r2a4xl2d4fvpib1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-compression" ,rust-async-compression-0.4)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-http-body" ,rust-http-body-0.4)
                       ("rust-http-range-header" ,rust-http-range-header-0.3)
                       ("rust-httpdate" ,rust-httpdate-1)
                       ("rust-iri-string" ,rust-iri-string-0.7)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower" ,rust-tower-0.4)
                       ("rust-tower-layer" ,rust-tower-layer-0.3)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/tower-rs/tower-http")
    (synopsis "Tower middleware and utilities for HTTP clients and servers")
    (description "Tower middleware and utilities for HTTP clients and servers")
    (license license:expat)))

(define-public rust-http-body-0.4
  (package
    (name "rust-http-body")
    (version "0.4.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "http-body" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l967qwwlvhp198xdrnc0p5d7jwfcp6q2lm510j6zqw4s4b8zwym"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2))))
    (home-page "https://github.com/hyperium/http-body")
    (synopsis
     "Trait representing an asynchronous, streaming, HTTP request or response body.
")
    (description
     "Trait representing an asynchronous, streaming, HTTP request or response body.")
    (license license:expat)))

(define-public rust-axum-core-0.3
  (package
    (name "rust-axum-core")
    (version "0.3.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "axum-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b1d9nkqb8znaba4qqzxzc968qwj4ybn4vgpyz9lz4a7l9vsb7vm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-http-body" ,rust-http-body-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-tower-http" ,rust-tower-http-0.4)
                       ("rust-tower-layer" ,rust-tower-layer-0.3)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/tokio-rs/axum")
    (synopsis "Core types and traits for axum")
    (description "Core types and traits for axum")
    (license license:expat)))

(define-public rust-axum-0.6
  (package
    (name "rust-axum")
    (version "0.6.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "axum" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gynqkg3dcy1zd7il69h8a3zax86v6qq5zpawqyn87mr6979x0iv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-axum-core" ,rust-axum-core-0.3)
                       ("rust-axum-macros" ,rust-axum-macros-0.3)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-headers" ,rust-headers-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-http-body" ,rust-http-body-0.4)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-matchit" ,rust-matchit-0.7)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-multer" ,rust-multer-2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-path-to-error" ,rust-serde-path-to-error-0.1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-sha1" ,rust-sha1-0.10)
                       ("rust-sync-wrapper" ,rust-sync-wrapper-0.1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-tungstenite" ,rust-tokio-tungstenite-0.20)
                       ("rust-tower" ,rust-tower-0.4)
                       ("rust-tower-http" ,rust-tower-http-0.4)
                       ("rust-tower-layer" ,rust-tower-layer-0.3)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/tokio-rs/axum")
    (synopsis "Web framework that focuses on ergonomics and modularity")
    (description "Web framework that focuses on ergonomics and modularity")
    (license license:expat)))

(define-public rust-tonic-0.8
  (package
    (name "rust-tonic")
    (version "0.8.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tonic" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yymp2xi1p60g81p5jfaybcawpfkb01vqvzqn4cyz6wj7fnry8cg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-stream" ,rust-async-stream-0.3)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-axum" ,rust-axum-0.6)
                       ("rust-base64" ,rust-base64-0.13)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-h2" ,rust-h2-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-http-body" ,rust-http-body-0.4)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-hyper-timeout" ,rust-hyper-timeout-0.4)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project" ,rust-pin-project-1)
                       ("rust-prost" ,rust-prost-0.11)
                       ("rust-prost-derive" ,rust-prost-derive-0.11)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.23)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower" ,rust-tower-0.4)
                       ("rust-tower-layer" ,rust-tower-layer-0.3)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracing-futures" ,rust-tracing-futures-0.2)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22))))
    (home-page "https://github.com/hyperium/tonic")
    (synopsis
     "A gRPC over HTTP/2 implementation focused on high performance, interoperability, and flexibility.
")
    (description
     "This package provides a @code{gRPC} over HTTP/2 implementation focused on high
performance, interoperability, and flexibility.")
    (license license:expat)))

(define-public rust-prost-derive-0.11
  (package
    (name "rust-prost-derive")
    (version "0.11.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prost-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d3mw2s2jba1f7wcjmjd6ha2a255p2rmynxhm1nysv9w1z8xilp5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/tokio-rs/prost")
    (synopsis "A Protocol Buffers implementation for the Rust Language.")
    (description
     "This package provides a Protocol Buffers implementation for the Rust Language.")
    (license license:asl2.0)))

(define-public rust-prost-0.11
  (package
    (name "rust-prost")
    (version "0.11.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prost" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kc1hva2h894hc0zf6r4r8fsxfpazf7xn5rj3jya9sbrsyhym0hb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-prost-derive" ,rust-prost-derive-0.11))))
    (home-page "https://github.com/tokio-rs/prost")
    (synopsis "A Protocol Buffers implementation for the Rust Language.")
    (description
     "This package provides a Protocol Buffers implementation for the Rust Language.")
    (license license:asl2.0)))

(define-public rust-array-init-cursor-0.2
  (package
    (name "rust-array-init-cursor")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "array-init-cursor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xpbqf7qkvzplpjd7f0wbcf2n1v9vygdccwxkd1amxp4il0hlzdz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/planus-org/planus")
    (synopsis "Utility crate to help keep track of arrays of MaybeUninit")
    (description
     "Utility crate to help keep track of arrays of @code{MaybeUninit}")
    (license (list license:expat license:asl2.0))))

(define-public rust-planus-0.3
  (package
    (name "rust-planus")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "planus" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17x8mr175b9clg998xpi5z45f9fsspb0ncfnx2644bz817fr25pw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-array-init-cursor" ,rust-array-init-cursor-0.2))))
    (home-page "https://github.com/planus-org/planus")
    (synopsis
     "Planus is an alternative compiler for flatbuffers, an efficient cross platform serialization library.")
    (description
     "Planus is an alternative compiler for flatbuffers, an efficient cross platform
serialization library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-arrow-format-0.8
  (package
    (name "rust-arrow-format")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow-format" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1irj67p6c224dzw86jr7j3z9r5zfid52gy6ml8rdqk4r2si4x207"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-planus" ,rust-planus-0.3)
                       ("rust-prost" ,rust-prost-0.11)
                       ("rust-prost-derive" ,rust-prost-derive-0.11)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tonic" ,rust-tonic-0.8))))
    (home-page "https://github.com/DataEngineeringLabs/arrow-format")
    (synopsis "Unofficial flatbuffers and tonic code of Apache Arrow spec")
    (description "Unofficial flatbuffers and tonic code of Apache Arrow spec")
    (license license:asl2.0)))

(define-public rust-packed-simd-0.3
  (package
    (name "rust-packed-simd")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "packed_simd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bck71ngyhx9icy7q3xzgmjxkylysxm6hgif5rqp2xc71jphi7qz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-core-arch" ,rust-core-arch-0.1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-sleef-sys" ,rust-sleef-sys-0.1))))
    (home-page "https://github.com/rust-lang/packed_simd")
    (synopsis "Portable Packed SIMD vectors")
    (description "Portable Packed SIMD vectors")
    (license (list license:expat license:asl2.0))))

(define-public rust-num-iter-0.1
  (package
    (name "rust-num-iter")
    (version "0.1.43")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "num-iter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lp22isvzmmnidbq9n5kbdh8gj0zm3yhxv1ddsn5rp65530fc0vx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-num-integer" ,rust-num-integer-0.1)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/rust-num/num-iter")
    (synopsis "External iterators for generic mathematics")
    (description "External iterators for generic mathematics")
    (license (list license:expat license:asl2.0))))

(define-public rust-num-integer-0.1
  (package
    (name "rust-num-integer")
    (version "0.1.45")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "num-integer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ncwavvwdmsqzxnn65phv6c6nn72pnv9xhpmjd6a429mzf4k6p92"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/rust-num/num-integer")
    (synopsis "Integer traits and functions")
    (description "Integer traits and functions")
    (license (list license:expat license:asl2.0))))

(define-public rust-num-complex-0.4
  (package
    (name "rust-num-complex")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "num-complex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "051j73vvdj07kdlpqv056s3a50ragsx3183cbpl1shc51355g88v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytecheck" ,rust-bytecheck-0.6)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rkyv" ,rust-rkyv-0.7)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-num/num-complex")
    (synopsis "Complex numbers implementation for Rust")
    (description "Complex numbers implementation for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-num-0.4
  (package
    (name "rust-num")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "num" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1bz7kvj94pyw4zi1pm7knziljzii218sw79ap8qfb81xkvb80ldh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-num-bigint" ,rust-num-bigint-0.4)
                       ("rust-num-complex" ,rust-num-complex-0.4)
                       ("rust-num-integer" ,rust-num-integer-0.1)
                       ("rust-num-iter" ,rust-num-iter-0.1)
                       ("rust-num-rational" ,rust-num-rational-0.4)
                       ("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "https://github.com/rust-num/num")
    (synopsis
     "A collection of numeric types and traits for Rust, including bigint,
complex, rational, range iterators, generic integers, and more!
")
    (description
     "This package provides a collection of numeric types and traits for Rust,
including bigint, complex, rational, range iterators, generic integers, and
more!")
    (license (list license:expat license:asl2.0))))

(define-public rust-chrono-tz-build-0.2
  (package
    (name "rust-chrono-tz-build")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chrono-tz-build" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kqywd9y8jn0kpw5npd2088qbrdsb6jd39k0snbfsmrgjkffpxg2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-parse-zoneinfo" ,rust-parse-zoneinfo-0.3)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-phf-codegen" ,rust-phf-codegen-0.11)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-uncased" ,rust-uncased-0.9))))
    (home-page "")
    (synopsis "internal build script for chrono-tz")
    (description "internal build script for chrono-tz")
    (license (list license:expat license:asl2.0))))

(define-public rust-chrono-tz-0.8
  (package
    (name "rust-chrono-tz")
    (version "0.8.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chrono-tz" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dxbx8jjxvkw4g05glr3km55b77ya70nwpq5wbddz9z9p739ndpi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz-build" ,rust-chrono-tz-build-0.2)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-uncased" ,rust-uncased-0.9))))
    (home-page "https://github.com/chronotope/chrono-tz")
    (synopsis "TimeZone implementations for chrono from the IANA database")
    (description
     "@code{TimeZone} implementations for chrono from the IANA database")
    (license (list license:expat license:asl2.0))))

(define-public rust-pure-rust-locales-0.7
  (package
    (name "rust-pure-rust-locales")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pure-rust-locales" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cl46srhxzj0jlvfp73l8l9qw54qwa04zywaxdf73hidwqlsh0pd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/cecton/pure-rust-locales")
    (synopsis
     "Pure Rust locales imported directly from the GNU C Library. `LC_COLLATE` and `LC_CTYPE` are not yet supported.")
    (description
     "Pure Rust locales imported directly from the GNU C Library. `LC_COLLATE` and
`LC_CTYPE` are not yet supported.")
    (license (list license:expat license:asl2.0))))

(define-public rust-android-tzdata-0.1
  (package
    (name "rust-android-tzdata")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "android-tzdata" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1w7ynjxrfs97xg3qlcdns4kgfpwcdv824g611fq32cag4cdr96g9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RumovZ/android-tzdata")
    (synopsis "Parser for the Android-specific tzdata file")
    (description "Parser for the Android-specific tzdata file")
    (license (list license:expat license:asl2.0))))

(define-public rust-chrono-0.4
  (package
    (name "rust-chrono")
    (version "0.4.31")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "chrono" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f6vg67pipm8cziad2yms6a639pssnvysk1m05dd9crymmdnhb3z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-android-tzdata" ,rust-android-tzdata-0.1)
                       ("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-iana-time-zone" ,rust-iana-time-zone-0.1)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-pure-rust-locales" ,rust-pure-rust-locales-0.7)
                       ("rust-rkyv" ,rust-rkyv-0.7)
                       ("rust-rustc-serialize" ,rust-rustc-serialize-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/chronotope/chrono")
    (synopsis "Date and time library for Rust")
    (description "Date and time library for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-arrow-schema-47
  (package
    (name "rust-arrow-schema")
    (version "47.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow-schema" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jyfw40m070zj2pv8mp3gvlnzs0mavnzn6qhw19qh5bv26f1f7ax"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/apache/arrow-rs")
    (synopsis "Defines the logical types for arrow arrays")
    (description "Defines the logical types for arrow arrays")
    (license license:asl2.0)))

(define-public rust-arrow-data-47
  (package
    (name "rust-arrow-data")
    (version "47.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow-data" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fpp09ykg6nb7jcaqnjzga242y7nlrfz3v0wlrf0kd68k4v4qnj7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrow-buffer" ,rust-arrow-buffer-47)
                       ("rust-arrow-schema" ,rust-arrow-schema-47)
                       ("rust-half" ,rust-half-2)
                       ("rust-num" ,rust-num-0.4))))
    (home-page "https://github.com/apache/arrow-rs")
    (synopsis "Array data abstractions for Apache Arrow")
    (description "Array data abstractions for Apache Arrow")
    (license license:asl2.0)))

(define-public rust-arrow-buffer-47
  (package
    (name "rust-arrow-buffer")
    (version "47.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow-buffer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15b1km7kb7cys2pdxgq1p9syiw7yzf9cch85rcw12504a8i1k8gx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-half" ,rust-half-2)
                       ("rust-num" ,rust-num-0.4))))
    (home-page "https://github.com/apache/arrow-rs")
    (synopsis "Buffer abstractions for Apache Arrow")
    (description "Buffer abstractions for Apache Arrow")
    (license license:asl2.0)))

(define-public rust-arrow-array-47
  (package
    (name "rust-arrow-array")
    (version "47.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow-array" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "139iwhc3j8mcn6avgjl4k3sc7g43kq92m02fbba05qgdadrglbnh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow-buffer" ,rust-arrow-buffer-47)
                       ("rust-arrow-data" ,rust-arrow-data-47)
                       ("rust-arrow-schema" ,rust-arrow-schema-47)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-half" ,rust-half-2)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-num" ,rust-num-0.4)
                       ("rust-packed-simd" ,rust-packed-simd-0.3))))
    (home-page "https://github.com/apache/arrow-rs")
    (synopsis "Array abstractions for Apache Arrow")
    (description "Array abstractions for Apache Arrow")
    (license license:asl2.0)))

(define-public rust-arrow2-0.18
  (package
    (name "rust-arrow2")
    (version "0.18.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arrow2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12fk0j37pchpfkwk3xgnyjclsqa5nfy27yjzkszwnyvmkd8fygwn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow-array" ,rust-arrow-array-47)
                       ("rust-arrow-buffer" ,rust-arrow-buffer-47)
                       ("rust-arrow-data" ,rust-arrow-data-47)
                       ("rust-arrow-format" ,rust-arrow-format-0.8)
                       ("rust-arrow-schema" ,rust-arrow-schema-47)
                       ("rust-async-stream" ,rust-async-stream-0.3)
                       ("rust-avro-schema" ,rust-avro-schema-0.3)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-comfy-table" ,rust-comfy-table-6)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-csv-async" ,rust-csv-async-1)
                       ("rust-csv-core" ,rust-csv-core-0.1)
                       ("rust-dyn-clone" ,rust-dyn-clone-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-ethnum" ,rust-ethnum-1)
                       ("rust-fallible-streaming-iterator" ,rust-fallible-streaming-iterator-0.1)
                       ("rust-foreign-vec" ,rust-foreign-vec-0.1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-hash-hasher" ,rust-hash-hasher-2)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-json-deserializer" ,rust-json-deserializer-0.4)
                       ("rust-lexical-core" ,rust-lexical-core-0.8)
                       ("rust-lz4" ,rust-lz4-1)
                       ("rust-multiversion" ,rust-multiversion-0.7)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-odbc-api" ,rust-odbc-api-0.36)
                       ("rust-orc-format" ,rust-orc-format-0.3)
                       ("rust-parquet2" ,rust-parquet2-0.17)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.7)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-simdutf8" ,rust-simdutf8-0.1)
                       ("rust-streaming-iterator" ,rust-streaming-iterator-0.1)
                       ("rust-strength-reduce" ,rust-strength-reduce-0.2)
                       ("rust-zstd" ,rust-zstd-0.12))))
    (home-page "https://github.com/jorgecarleitao/arrow2")
    (synopsis "Unofficial implementation of Apache Arrow spec in safe Rust")
    (description "Unofficial implementation of Apache Arrow spec in safe Rust")
    (license license:asl2.0)))

(define-public rust-polars-core-0.33
  (package
    (name "rust-polars-core")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wfa8pmlfdi2ybyah1cnhgza3cya4vwj9q402qa8zyh79h0pqdh8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arrow2" ,rust-arrow2-0.18)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-tz" ,rust-chrono-tz-0.8)
                       ("rust-comfy-table" ,rust-comfy-table-7)
                       ("rust-either" ,rust-either-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-itoap" ,rust-itoap-1)
                       ("rust-ndarray" ,rust-ndarray-0.15)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-object-store" ,rust-object-store-0.7)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-polars-arrow" ,rust-polars-arrow-0.33)
                       ("rust-polars-error" ,rust-polars-error-0.33)
                       ("rust-polars-row" ,rust-polars-row-0.33)
                       ("rust-polars-utils" ,rust-polars-utils-0.33)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-rand-distr" ,rust-rand-distr-0.4)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smartstring" ,rust-smartstring-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-url" ,rust-url-2)
                       ("rust-version-check" ,rust-version-check-0.9)
                       ("rust-xxhash-rust" ,rust-xxhash-rust-0.8))))
    (home-page "https://www.pola.rs/")
    (synopsis "Core of the Polars DataFrame library")
    (description "Core of the Polars @code{DataFrame} library")
    (license license:expat)))

(define-public rust-polars-algo-0.33
  (package
    (name "rust-polars-algo")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars-algo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03lr7yhj9w4v42a8mha4gc33baf2fl78hs03a78lvfvyfrr6a4xd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-lazy" ,rust-polars-lazy-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33))))
    (home-page "https://www.pola.rs/")
    (synopsis "Algorithms built upon Polars primitives")
    (description "Algorithms built upon Polars primitives")
    (license license:expat)))

(define-public rust-polars-0.33
  (package
    (name "rust-polars")
    (version "0.33.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "polars" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0snfb3abwbjrnbjd4z4fgjyg5h2wwadwnbd1r7dckwlz7cbdwc1h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-polars-algo" ,rust-polars-algo-0.33)
                       ("rust-polars-core" ,rust-polars-core-0.33)
                       ("rust-polars-io" ,rust-polars-io-0.33)
                       ("rust-polars-lazy" ,rust-polars-lazy-0.33)
                       ("rust-polars-ops" ,rust-polars-ops-0.33)
                       ("rust-polars-sql" ,rust-polars-sql-0.33)
                       ("rust-polars-time" ,rust-polars-time-0.33)
                       ("rust-version-check" ,rust-version-check-0.9))))
    (home-page "https://www.pola.rs/")
    (synopsis "DataFrame library based on Apache Arrow")
    (description "@code{DataFrame} library based on Apache Arrow")
    (license license:expat)))

(define-public rust-nu-cmd-dataframe-0.86
  (package
    (name "rust-nu-cmd-dataframe")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cmd-dataframe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0x8haq0kd00kgamzbcv5gdadcly5p528qxj2s4yqwdgaz478n7gw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-num" ,rust-num-0.4)
                       ("rust-polars" ,rust-polars-0.33)
                       ("rust-polars-io" ,rust-polars-io-0.33)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sqlparser" ,rust-sqlparser-0.36))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-cmd-dataframe")
    (synopsis "Nushell's dataframe commands based on polars.")
    (description "Nushell's dataframe commands based on polars.")
    (license license:expat)))

(define-public rust-uuid-macro-internal-1
  (package
    (name "rust-uuid-macro-internal")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uuid-macro-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1bxdhbapp23b5wshx2dipyn1vfrj7dickvysa0lyi7hlkfx6p31x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "")
    (synopsis "Private implementation details of the uuid! macro.")
    (description "Private implementation details of the uuid! macro.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-bytemuck-derive-1
  (package
    (name "rust-bytemuck-derive")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytemuck_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cgj75df2v32l4fmvnp25xxkkz4lp6hz76f7hfhd55wgbzmvfnln"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/Lokathor/bytemuck")
    (synopsis "derive proc-macros for `bytemuck`")
    (description "derive proc-macros for `bytemuck`")
    (license (list license:zlib license:asl2.0 license:expat))))

(define-public rust-bytemuck-1
  (package
    (name "rust-bytemuck")
    (version "1.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytemuck" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ik1ma5n3bg700skkzhx50zjk7kj7mbsphi773if17l04pn2hk9p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck-derive" ,rust-bytemuck-derive-1))))
    (home-page "https://github.com/Lokathor/bytemuck")
    (synopsis "A crate for mucking around with piles of bytes.")
    (description
     "This package provides a crate for mucking around with piles of bytes.")
    (license (list license:zlib license:asl2.0 license:expat))))

(define-public rust-borsh-schema-derive-internal-0.10
  (package
    (name "rust-borsh-schema-derive-internal")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "borsh-schema-derive-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kaw1xdprb8chqj50c8gxjb5dadx1rac91zg8s81njpp8g60ahk3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://borsh.io")
    (synopsis "Schema Generator for Borsh
")
    (description "Schema Generator for Borsh")
    (license license:asl2.0)))

(define-public rust-borsh-derive-internal-0.10
  (package
    (name "rust-borsh-derive-internal")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "borsh-derive-internal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yx27ic6aal83bdi1h6v80wfs9ixvw51qzmdgcn8sn8rd4akid5g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://borsh.io")
    (synopsis "Binary Object Representation Serializer for Hashing
")
    (description "Binary Object Representation Serializer for Hashing")
    (license license:asl2.0)))

(define-public rust-borsh-derive-0.10
  (package
    (name "rust-borsh-derive")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "borsh-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xslbx3qj531aq8ny1bkr45ibjmpsx0szsfc57rm33akj4v62m07"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-borsh-derive-internal" ,rust-borsh-derive-internal-0.10)
                       ("rust-borsh-schema-derive-internal" ,rust-borsh-schema-derive-internal-0.10)
                       ("rust-proc-macro-crate" ,rust-proc-macro-crate-0.1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://borsh.io")
    (synopsis "Binary Object Representation Serializer for Hashing
")
    (description "Binary Object Representation Serializer for Hashing")
    (license license:asl2.0)))

(define-public rust-borsh-0.10
  (package
    (name "rust-borsh")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "borsh" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sq4l9jfik5dmpy1islcj40bing1jkji2q1qbrkvq1d02n92f521"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-borsh-derive" ,rust-borsh-derive-0.10)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.13))))
    (home-page "https://borsh.io")
    (synopsis "Binary Object Representation Serializer for Hashing
")
    (description "Binary Object Representation Serializer for Hashing")
    (license (list license:expat license:asl2.0))))

(define-public rust-uuid-1
  (package
    (name "rust-uuid")
    (version "1.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "uuid" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z6dnvba224p8wvv4vx4xpgc2yxqy12sk4qh346sfh8baskmkbc8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-atomic" ,rust-atomic-0.5)
                       ("rust-borsh" ,rust-borsh-0.10)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-md-5" ,rust-md-5-0.10)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha1-smol" ,rust-sha1-smol-1)
                       ("rust-slog" ,rust-slog-2)
                       ("rust-uuid-macro-internal" ,rust-uuid-macro-internal-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-zerocopy" ,rust-zerocopy-0.6))))
    (home-page "https://github.com/uuid-rs/uuid")
    (synopsis "A library to generate and parse UUIDs.")
    (description
     "This package provides a library to generate and parse UUIDs.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-unicode-segmentation-1
  (package
    (name "rust-unicode-segmentation")
    (version "1.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-segmentation" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dky2hm5k51xy11hc3nk85p533rvghd462b6i0c532b7hl4j9mhx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/unicode-rs/unicode-segmentation")
    (synopsis
     "This crate provides Grapheme Cluster, Word and Sentence boundaries
according to Unicode Standard Annex #29 rules.
")
    (description
     "This crate provides Grapheme Cluster, Word and Sentence boundaries according to
Unicode Standard Annex #29 rules.")
    (license (list license:expat license:asl2.0))))

(define-public rust-heck-0.4
  (package
    (name "rust-heck")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "heck" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1a7mqsnycv5z4z5vnv1k34548jzmc0ajic7c1j8jsaspnhw5ql4m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-segmentation" ,rust-unicode-segmentation-1))))
    (home-page "https://github.com/withoutboats/heck")
    (synopsis "heck is a case conversion library.")
    (description "heck is a case conversion library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-strum-macros-0.25
  (package
    (name "rust-strum-macros")
    (version "0.25.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "strum_macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "184y62g474zqb2f7n16x3ghvlyjbh50viw32p9w9l5lwmjlizp13"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/Peternator7/strum")
    (synopsis "Helpful macros for working with enums and strings")
    (description "Helpful macros for working with enums and strings")
    (license license:expat)))

(define-public rust-strum-0.25
  (package
    (name "rust-strum")
    (version "0.25.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "strum" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09g1q55ms8vax1z0mxlbva3vm8n2r1179kfvbccnkjcidzm58399"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf" ,rust-phf-0.10)
                       ("rust-strum-macros" ,rust-strum-macros-0.25))))
    (home-page "https://github.com/Peternator7/strum")
    (synopsis "Helpful macros for working with enums and strings")
    (description "Helpful macros for working with enums and strings")
    (license license:expat)))

(define-public rust-linux-raw-sys-0.4
  (package
    (name "rust-linux-raw-sys")
    (version "0.4.10")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "linux-raw-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gz0671d4hgrdngrryaajxl962ny4g40pykg0vq0pr32q3l7j96s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/sunfishcode/linux-raw-sys")
    (synopsis "Generated bindings for Linux's userspace API")
    (description "Generated bindings for Linux's userspace API")
    (license (list license:asl2.0  license:asl2.0
                   license:expat))))

(define-public rust-bitflags-2
  (package
    (name "rust-bitflags")
    (version "2.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bitflags" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01ryy3kd671b0ll4bhdvhsz67vwz1lz53fz504injrd7wpv64xrj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/bitflags/bitflags")
    (synopsis "A macro to generate structures which behave like bitflags.
")
    (description
     "This package provides a macro to generate structures which behave like bitflags.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustix-0.38
  (package
    (name "rust-rustix")
    (version "0.38.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustix" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1858yxb7bk66br66m2wk9jflp9w7hgywrjyi60z91hhn5v5m1kk7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.3)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (description
     "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (license (list license:asl2.0  license:asl2.0
                   license:expat))))

(define-public rust-fd-lock-3
  (package
    (name "rust-fd-lock")
    (version "3.0.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fd-lock" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1df1jdncda67g65hrnmd2zsl7q5hdn8cm84chdalxndsx7akw0zg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/yoshuawuyts/fd-lock")
    (synopsis
     "Advisory cross-platform lock on a file using a file descriptor to it.")
    (description
     "Advisory cross-platform lock on a file using a file descriptor to it.")
    (license (list license:expat license:asl2.0))))

(define-public rust-xcb-0.8
  (package
    (name "rust-xcb")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "xcb" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ph27r9nxyfy3hh1c7x85g6dciwxcinf6514pvw9ybhl4hzpm4ay"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-x11" ,rust-x11-2))))
    (home-page "https://github.com/rust-x-bindings/rust-xcb")
    (synopsis "Rust safe bindings for XCB")
    (description "Rust safe bindings for XCB")
    (license license:expat)))

(define-public rust-x11-clipboard-0.3
  (package
    (name "rust-x11-clipboard")
    (version "0.3.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "x11-clipboard" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1smwyr23jns0dncm6bwv00xfxxy99bv6qlx6df7dkdcydk04kgc9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-xcb" ,rust-xcb-0.8))))
    (home-page "https://github.com/quininer/x11-clipboard")
    (synopsis "x11 clipboard support for Rust.")
    (description "x11 clipboard support for Rust.")
    (license license:expat)))

(define-public rust-clipboard-win-2
  (package
    (name "rust-clipboard-win")
    (version "2.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clipboard-win" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0svqk0lrw66abaxd6h7l4k4g2s5vd1dcipy34kzfan6mzvb97873"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/DoumanAsh/clipboard-win")
    (synopsis "Provides simple way to interact with Windows clipboard.")
    (description
     "This package provides simple way to interact with Windows clipboard.")
    (license license:expat)))

(define-public rust-clipboard-0.5
  (package
    (name "rust-clipboard")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clipboard" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rxjfn811h09g6jpjjs2vx7z52wj6dxnflbwryfj6h03dij09a95"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clipboard-win" ,rust-clipboard-win-2)
                       ("rust-objc" ,rust-objc-0.2)
                       ("rust-objc-foundation" ,rust-objc-foundation-0.1)
                       ("rust-objc-id" ,rust-objc-id-0.1)
                       ("rust-x11-clipboard" ,rust-x11-clipboard-0.3))))
    (home-page "https://github.com/aweinstock314/rust-clipboard")
    (synopsis
     "rust-clipboard is a cross-platform library for getting and setting the contents of the OS-level clipboard.")
    (description
     "rust-clipboard is a cross-platform library for getting and setting the contents
of the OS-level clipboard.")
    (license (list license:expat license:asl2.0))))

(define-public rust-reedline-0.25
  (package
    (name "rust-reedline")
    (version "0.25.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "reedline" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14b9s7r5wpmimcg1qgnz911crzm1mjbl686ckbvlq6cw6qfivp77"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-clipboard" ,rust-clipboard-0.5)
                       ("rust-crossbeam" ,rust-crossbeam-0.8)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-fd-lock" ,rust-fd-lock-3)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-rusqlite" ,rust-rusqlite-0.29)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.2)
                       ("rust-strum" ,rust-strum-0.25)
                       ("rust-strum-macros" ,rust-strum-macros-0.25)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/nushell/reedline")
    (synopsis "A readline-like crate for CLI text input")
    (description
     "This package provides a readline-like crate for CLI text input")
    (license license:expat)))

(define-public rust-nu-json-0.86
  (package
    (name "rust-nu-json")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hps5lnj706z8biv6ayv6438wvnw3zpvbnlp73p47m5jjkrcz88m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-linked-hash-map" ,rust-linked-hash-map-0.5)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-json")
    (synopsis "Fork of serde-hjson")
    (description "Fork of serde-hjson")
    (license license:expat)))

(define-public rust-nu-color-config-0.86
  (package
    (name "rust-nu-color-config")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-color-config" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0q7iyx8psylai7bsa4l1rh108hgwlzc2bjy7l4596365cqb98shd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-json" ,rust-nu-json-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-serde" ,rust-serde-1))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-color-config")
    (synopsis "Color configuration code used by Nushell")
    (description "Color configuration code used by Nushell")
    (license license:expat)))

(define-public rust-rmp-0.8
  (package
    (name "rust-rmp")
    (version "0.8.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rmp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "083bbqw8ibqp63v6scmaxmy5x8yznj4j0i2n6jjivv9qrjk6163z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-paste" ,rust-paste-1))))
    (home-page "https://github.com/3Hren/msgpack-rust")
    (synopsis "Pure Rust MessagePack serialization implementation")
    (description "Pure Rust @code{MessagePack} serialization implementation")
    (license license:expat)))

(define-public rust-rmp-serde-1
  (package
    (name "rust-rmp-serde")
    (version "1.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rmp-serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12i5aglyni58hlq19pi58z1z6a1hv6l04p9y8ms8l3cqx9gaizmz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-rmp" ,rust-rmp-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/3Hren/msgpack-rust")
    (synopsis "Serde bindings for RMP")
    (description "Serde bindings for RMP")
    (license license:expat)))

(define-public rust-nu-plugin-0.86
  (package
    (name "rust-nu-plugin")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-plugin" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hahbdif97fa6kqky1zaaq79aq0wfjr4l5jbf4wbc9ngrjklh435"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bincode" ,rust-bincode-1)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-rmp-serde" ,rust-rmp-serde-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-plugin")
    (synopsis "Functionality for building Nushell plugins")
    (description "Functionality for building Nushell plugins")
    (license license:expat)))

(define-public rust-itertools-0.11
  (package
    (name "rust-itertools")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "itertools" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mzyqcc59azx9g5cg6fs8k529gvh4463smmka6jvzs3cd2jp7hdi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1))))
    (home-page "https://github.com/rust-itertools/itertools")
    (synopsis
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (description
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.189")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1m9j5f5dd010arr75mipj4ykngk1ipv8qdqialaf770033wx2j0y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://serde.rs")
    (synopsis "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (description
     "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-1
  (package
    (name "rust-serde")
    (version "1.0.189")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dq542wki7rn2inhg70f35qjzd8aayjfkvcfvhdh1m2awx22lhlf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://serde.rs")
    (synopsis "A generic serialization/deserialization framework")
    (description
     "This package provides a generic serialization/deserialization framework")
    (license (list license:expat license:asl2.0))))

(define-public rust-bytesize-1
  (package
    (name "rust-bytesize")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytesize" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k3aak70iwz4s2gsjbxf0ws4xnixqbdz6p2ha96s06748fpniqx3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/hyunsik/bytesize/")
    (synopsis "an utility for human-readable bytes representations")
    (description "an utility for human-readable bytes representations")
    (license license:asl2.0)))

(define-public rust-nu-parser-0.86
  (package
    (name "rust-nu-parser")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mx64hzxwk11bdq2zmbp6ls1m0n25hhj3awrw8sb0mw9xm8w7j3n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytesize" ,rust-bytesize-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-itertools" ,rust-itertools-0.11)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-plugin" ,rust-nu-plugin-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-parser")
    (synopsis "Nushell's parser")
    (description "Nushell's parser")
    (license license:expat)))

(define-public rust-typetag-impl-0.2
  (package
    (name "rust-typetag-impl")
    (version "0.2.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "typetag-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03xlldhpzr1034s5xsdfifb9ni1xyjn4s1x31lh9b9n41m2kvhdz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dtolnay/typetag")
    (synopsis "Implementation detail of the typetag crate")
    (description "Implementation detail of the typetag crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-inventory-0.3
  (package
    (name "rust-inventory")
    (version "0.3.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "inventory" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13mcyn6adlkg42pm9fjl6czxvd4xm2768alrjig5kw0b8463igp1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dtolnay/inventory")
    (synopsis "Typed distributed plugin registration")
    (description "Typed distributed plugin registration")
    (license (list license:expat license:asl2.0))))

(define-public rust-erased-serde-0.3
  (package
    (name "rust-erased-serde")
    (version "0.3.31")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "erased-serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0v5jyid1v8irf2n2875iwhm80cw8x75gfkdh7qvzxrymz5s8j4vc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/dtolnay/erased-serde")
    (synopsis "Type-erased Serialize and Serializer traits")
    (description "Type-erased Serialize and Serializer traits")
    (license (list license:expat license:asl2.0))))

(define-public rust-typetag-0.2
  (package
    (name "rust-typetag")
    (version "0.2.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "typetag" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hxfmypv17x6pn7yzh4vwxlb9yw19gqhh2z6q1sn5jfl8g8hz5l0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-erased-serde" ,rust-erased-serde-0.3)
                       ("rust-inventory" ,rust-inventory-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-typetag-impl" ,rust-typetag-impl-0.2))))
    (home-page "https://github.com/dtolnay/typetag")
    (synopsis "Serde serializable and deserializable trait objects")
    (description "Serde serializable and deserializable trait objects")
    (license (list license:expat license:asl2.0))))

(define-public rust-sys-locale-0.3
  (package
    (name "rust-sys-locale")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sys-locale" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c29m5z9bbg4ix5vy25jma83xlakvmkhs9rxy1qwsv6dkqiwy0g8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/1Password/sys-locale")
    (synopsis
     "Small and lightweight library to obtain the active system locale")
    (description
     "Small and lightweight library to obtain the active system locale")
    (license (list license:expat license:asl2.0))))

(define-public rust-vte-0.11
  (package
    (name "rust-vte")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vte" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15r1ff4j8ndqj9vsyil3wqwxhhl7jsz5g58f31n0h1wlpxgjn0pm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-utf8parse" ,rust-utf8parse-0.2)
                       ("rust-vte-generate-state-changes" ,rust-vte-generate-state-changes-0.1))))
    (home-page "https://github.com/alacritty/vte")
    (synopsis "Parser for implementing terminal emulators")
    (description "Parser for implementing terminal emulators")
    (license (list license:asl2.0 license:expat))))

(define-public rust-strip-ansi-escapes-0.2
  (package
    (name "rust-strip-ansi-escapes")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "strip-ansi-escapes" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ymwcax1vyacqxx5xisfsynm7n1bvmhskvsaylac915k8gwqxzsm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-vte" ,rust-vte-0.11))))
    (home-page "https://github.com/luser/strip-ansi-escapes")
    (synopsis "Strip ANSI escape sequences from byte streams.")
    (description "Strip ANSI escape sequences from byte streams.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-crossterm-0.26
  (package
    (name "rust-crossterm")
    (version "0.26.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "crossterm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04rxvmbf3scywy0m7rhg586lf833vpb33czijxi80fakadkxlk58"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-crossterm-winapi" ,rust-crossterm-winapi-0.9)
                       ("rust-filedescriptor" ,rust-filedescriptor-0.8)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-signal-hook" ,rust-signal-hook-0.3)
                       ("rust-signal-hook-mio" ,rust-signal-hook-mio-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/crossterm-rs/crossterm")
    (synopsis "A crossplatform terminal library for manipulating terminals.")
    (description
     "This package provides a crossplatform terminal library for manipulating
terminals.")
    (license license:expat)))

(define-public rust-lscolors-0.15
  (package
    (name "rust-lscolors")
    (version "0.15.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lscolors" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "039jl8lwcw84cii5zpngs4i7jxhy2pnpjjvynympib8386h1aw5z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-term" ,rust-ansi-term-0.12)
                       ("rust-crossterm" ,rust-crossterm-0.26)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49))))
    (home-page "https://github.com/sharkdp/lscolors")
    (synopsis "Colorize paths using the LS_COLORS environment variable")
    (description "Colorize paths using the LS_COLORS environment variable")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-utils-0.86
  (package
    (name "rust-nu-utils")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17xrdrh0fy9kjxrk8malnv5sv5fp1rfwfiaslxcivbad0wwqrmih"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossterm-winapi" ,rust-crossterm-winapi-0.9)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-lscolors" ,rust-lscolors-0.15)
                       ("rust-num-format" ,rust-num-format-0.4)
                       ("rust-strip-ansi-escapes" ,rust-strip-ansi-escapes-0.2)
                       ("rust-sys-locale" ,rust-sys-locale-0.3))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-utils")
    (synopsis "Nushell utility functions")
    (description "Nushell utility functions")
    (license license:expat)))

(define-public rust-sysinfo-0.29
  (package
    (name "rust-sysinfo")
    (version "0.29.10")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "sysinfo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19cbs7d7fcq8cpfpr94n68h04d02lab8xg76j6la7b90shad260a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-core-foundation-sys" ,rust-core-foundation-sys-0.8)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-ntapi" ,rust-ntapi-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/GuillaumeGomez/sysinfo")
    (synopsis
     "Library to get system information such as processes, CPUs, disks, components and networks")
    (description
     "Library to get system information such as processes, CPUs, disks, components and
networks")
    (license license:expat)))

(define-public rust-procfs-0.15
  (package
    (name "rust-procfs")
    (version "0.15.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "procfs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07rz1qqv9ygy0aarnq5r5dibcsar5jcv7zfqxi25iawvybwsfg4l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-rustix" ,rust-rustix-0.36)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/eminence/procfs")
    (synopsis "Interface to the linux procfs pseudo-filesystem")
    (description "Interface to the linux procfs pseudo-filesystem")
    (license (list license:expat license:asl2.0))))

(define-public rust-mach2-0.4
  (package
    (name "rust-mach2")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mach2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1s5dbscwk0w6czzvhxp9ix9c2djv4fpnj4za9byaclfiphq1h3bd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/JohnTitor/mach2")
    (synopsis
     "A Rust interface to the user-space API of the Mach 3.0 kernel that underlies OSX.")
    (description
     "This package provides a Rust interface to the user-space API of the Mach 3.0
kernel that underlies OSX.")
    (license (list license:bsd-2 license:expat license:asl2.0))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.69")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-macro2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nljgyllbm3yr3pa081bf83gxh6l4zvjqzaldw7v4mj9xfgihk0k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/proc-macro2")
    (synopsis
     "A substitute implementation of the compiler's `proc_macro` API to decouple token-based libraries from the procedural macro use case.")
    (description
     "This package provides a substitute implementation of the compiler's `proc_macro`
API to decouple token-based libraries from the procedural macro use case.")
    (license (list license:expat license:asl2.0))))

(define-public rust-syn-2
  (package
    (name "rust-syn")
    (version "2.0.38")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "syn" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12s06bi068scc4fpv2x2bp3lx2vxnk4s0qv3w9hqznrpl6m7jsz9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/syn")
    (synopsis "Parser for Rust source code")
    (description "Parser for Rust source code")
    (license (list license:expat license:asl2.0))))

(define-public rust-prettyplease-0.2
  (package
    (name "rust-prettyplease")
    (version "0.2.15")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "prettyplease" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17az47j29q76gnyqvd5giryjz2fp7zw7vzcka1rb8ndbfgbmn05f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dtolnay/prettyplease")
    (synopsis "A minimal `syn` syntax tree pretty-printer")
    (description
     "This package provides a minimal `syn` syntax tree pretty-printer")
    (license (list license:expat license:asl2.0))))

(define-public rust-yansi-term-0.1
  (package
    (name "rust-yansi-term")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yansi-term" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1w8vjlvxba6yvidqdvxddx3crl6z66h39qxj8xi6aqayw2nk0p7y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/botika/yansi-term")
    (synopsis "Library for ANSI terminal colours and styles (bold, underline)")
    (description
     "Library for ANSI terminal colours and styles (bold, underline)")
    (license license:expat)))

(define-public rust-annotate-snippets-0.9
  (package
    (name "rust-annotate-snippets")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "annotate-snippets" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0dlw5zl4gbr8g9jqalzjbycxan2qyzzpakfzqs2rixxsxh8x9ff3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-yansi-term" ,rust-yansi-term-0.1))))
    (home-page "https://github.com/rust-lang/annotate-snippets-rs")
    (synopsis "Library for building code annotations")
    (description "Library for building code annotations")
    (license (list license:asl2.0 license:expat))))

(define-public rust-bindgen-0.68
  (package
    (name "rust-bindgen")
    (version "0.68.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bindgen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y40gndyay1fj8d3d8gsd9fyfzjlbghx92i560kmvhvfxc9l6vkj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-annotate-snippets" ,rust-annotate-snippets-0.9)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cexpr" ,rust-cexpr-0.6)
                       ("rust-clang-sys" ,rust-clang-sys-1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-lazycell" ,rust-lazycell-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-peeking-take-while" ,rust-peeking-take-while-0.1)
                       ("rust-prettyplease" ,rust-prettyplease-0.2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-shlex" ,rust-shlex-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-which" ,rust-which-4))))
    (home-page "https://rust-lang.github.io/rust-bindgen/")
    (synopsis
     "Automatically generates Rust FFI bindings to C and C++ libraries.")
    (description
     "Automatically generates Rust FFI bindings to C and C++ libraries.")
    (license license:bsd-3)))

(define-public rust-libproc-0.14
  (package
    (name "rust-libproc")
    (version "0.14.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libproc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vsahlxjx6gwwvvqgaznv53vnanmnqiiagv286pmq7cxpbmh9412"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.68)
                       ("rust-errno" ,rust-errno-0.3)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/andrewdavidmackenzie/libproc-rs")
    (synopsis
     "A library to get information about running processes - for Mac OS X and Linux")
    (description
     "This package provides a library to get information about running processes - for
Mac OS X and Linux")
    (license license:expat)))

(define-public rust-nu-system-0.86
  (package
    (name "rust-nu-system")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-system" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sklzwrdls47m2mrxy13k0qchliszy70rd1g4rs2hn1zz2vk1awq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libproc" ,rust-libproc-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mach2" ,rust-mach2-0.4)
                       ("rust-nix" ,rust-nix-0.27)
                       ("rust-ntapi" ,rust-ntapi-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-procfs" ,rust-procfs-0.15)
                       ("rust-sysinfo" ,rust-sysinfo-0.29)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-system")
    (synopsis "Nushell system querying")
    (description "Nushell system querying")
    (license license:expat)))

(define-public rust-lru-0.11
  (package
    (name "rust-lru")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lru" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08dzlpriy9xajga5k2rgsh7qq5zhx3rfd6jgwfh46dlbd6vkza54"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hashbrown" ,rust-hashbrown-0.14))))
    (home-page "https://github.com/jeromefroe/lru-rs")
    (synopsis "A LRU cache implementation")
    (description "This package provides a LRU cache implementation")
    (license license:expat)))

(define-public rust-nu-protocol-0.86
  (package
    (name "rust-nu-protocol")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-protocol" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fmh5w049clp4d0hwmsik68b3zgh1l6kan5zdyvjsw9cm0fp92md"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byte-unit" ,rust-byte-unit-4)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-humanize" ,rust-chrono-humanize-0.2)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-lru" ,rust-lru-0.11)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-system" ,rust-nu-system-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-num-format" ,rust-num-format-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-typetag" ,rust-typetag-0.2))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-protocol")
    (synopsis
     "Nushell's internal protocols, including its abstract syntax tree")
    (description
     "Nushell's internal protocols, including its abstract syntax tree")
    (license license:expat)))

(define-public rust-pwd-1
  (package
    (name "rust-pwd")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pwd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18p4j95sqqcxn3fbm6gbi7klxp8n40xmcjqy9vz1ww5rg461rivj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://gitlab.com/pwoolcoc/pwd.git")
    (synopsis "Safe interface to pwd.h
")
    (description "Safe interface to pwd.h")
    (license license:expat)))

(define-public rust-omnipath-0.1
  (package
    (name "rust-omnipath")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "omnipath" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xd5a4xwsfmhzk59v6wz65f59rk16d7gvkg90w1qhb0jg08b7bc0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/ChrisDenton/omnipath")
    (synopsis "Path utility library")
    (description "Path utility library")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-path-0.86
  (package
    (name "rust-nu-path")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-path" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1fkynjaw9b8q3dr16aq699hz2xw2cgs7ph3kpblymrspa2g9yhqc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dirs-next" ,rust-dirs-next-2)
                       ("rust-omnipath" ,rust-omnipath-0.1)
                       ("rust-pwd" ,rust-pwd-1))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-path")
    (synopsis "Path handling library for Nushell")
    (description "Path handling library for Nushell")
    (license license:expat)))

(define-public rust-nu-glob-0.86
  (package
    (name "rust-nu-glob")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-glob" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18fi029r2fqid59dd8pd5gfdgshaqfprkwzhm1fixjgkv47m6f15"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-glob")
    (synopsis
     "Fork of glob. Support for matching file paths against Unix shell style patterns.
")
    (description
     "Fork of glob.  Support for matching file paths against Unix shell style
patterns.")
    (license (list license:expat license:asl2.0))))

(define-public rust-nu-engine-0.86
  (package
    (name "rust-nu-engine")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-engine" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y29pl855mbr585pgj1bf3szpigvl9l5wr5p33l2spih50wsvjws"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nu-glob" ,rust-nu-glob-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-engine")
    (synopsis "Nushell's evaluation engine")
    (description "Nushell's evaluation engine")
    (license license:expat)))

(define-public rust-nu-cmd-base-0.86
  (package
    (name "rust-nu-cmd-base")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cmd-base" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cp13za0qs24nfasblcrcmndjvnmp723qf4b7jqnxlz0gwdip9l4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-cmd-base")
    (synopsis "The foundation tools to build Nushell commands.")
    (description "The foundation tools to build Nushell commands.")
    (license license:expat)))

(define-public rust-fancy-regex-0.11
  (package
    (name "rust-fancy-regex")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fancy-regex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18j0mmzfycibhxhhhfja00dxd1vf8x5c28lbry224574h037qpxr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bit-set" ,rust-bit-set-0.5)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://github.com/fancy-regex/fancy-regex")
    (synopsis
     "An implementation of regexes, supporting a relatively rich set of features, including backreferences and look-around.")
    (description
     "An implementation of regexes, supporting a relatively rich set of features,
including backreferences and look-around.")
    (license license:expat)))

(define-public rust-nu-cli-0.86
  (package
    (name "rust-nu-cli")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-cli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1v6lj1z4dn0ycqwmpqgni59n9rzyv1zh1mwkiv5ad66xib1fpdi3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.11)
                       ("rust-fuzzy-matcher" ,rust-fuzzy-matcher-0.3)
                       ("rust-is-executable" ,rust-is-executable-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-cmd-base" ,rust-nu-cmd-base-0.86)
                       ("rust-nu-color-config" ,rust-nu-color-config-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-pathdiff" ,rust-pathdiff-0.2)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-reedline" ,rust-reedline-0.25)
                       ("rust-sysinfo" ,rust-sysinfo-0.29)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/nushell/nushell/tree/main/crates/nu-cli")
    (synopsis "CLI-related functionality for Nushell")
    (description "CLI-related functionality for Nushell")
    (license license:expat)))

(define-public rust-nu-ansi-term-0.49
  (package
    (name "rust-nu-ansi-term")
    (version "0.49.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-ansi-term" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0s2svfnircd9jp06wk55qcbb9v5cadkfcjfg99vm21qdjg0x6wy0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/nushell/nu-ansi-term")
    (synopsis "Library for ANSI terminal colors and styles (bold, underline)")
    (description
     "Library for ANSI terminal colors and styles (bold, underline)")
    (license license:expat)))

(define-public rust-libmimalloc-sys-0.1
  (package
    (name "rust-libmimalloc-sys")
    (version "0.1.35")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libmimalloc-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r4nrd9xbmhmipw4bvh4xlbzbc7xf74frrsibqglysffgv1vay9r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-cty" ,rust-cty-0.2)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page
     "https://github.com/purpleprotocol/mimalloc_rust/tree/master/libmimalloc-sys")
    (synopsis "Sys crate wrapping the mimalloc allocator")
    (description "Sys crate wrapping the mimalloc allocator")
    (license license:expat)))

(define-public rust-mimalloc-0.1
  (package
    (name "rust-mimalloc")
    (version "0.1.39")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mimalloc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "176w9gf5qxs07kd2q39f0k25rzmp4kyx5r13wc8sk052bqmr40gs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libmimalloc-sys" ,rust-libmimalloc-sys-0.1))))
    (home-page "https://github.com/purpleprotocol/mimalloc_rust")
    (synopsis "Performance and security oriented drop-in allocator")
    (description "Performance and security oriented drop-in allocator")
    (license license:expat)))

(define-public rust-thiserror-impl-1
  (package
    (name "rust-thiserror-impl")
    (version "1.0.50")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "thiserror-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f0lmam4765sfnwr4b1n00y14vxh10g0311mkk0adr80pi02wsr6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dtolnay/thiserror")
    (synopsis "Implementation detail of the `thiserror` crate")
    (description "Implementation detail of the `thiserror` crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-thiserror-1
  (package
    (name "rust-thiserror")
    (version "1.0.50")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "thiserror" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ll2sfbrxks8jja161zh1pgm3yssr7aawdmaa2xmcwcsbh7j39zr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-thiserror-impl" ,rust-thiserror-impl-1))))
    (home-page "https://github.com/dtolnay/thiserror")
    (synopsis "derive(Error)")
    (description "derive(Error)")
    (license (list license:expat license:asl2.0))))

(define-public rust-supports-unicode-2
  (package
    (name "rust-supports-unicode")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "supports-unicode" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xxscsdjmdp7i3ikqnnivfn4hnpy4gp9as4hshgd4pdb82r2qv2b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-is-terminal" ,rust-is-terminal-0.4))))
    (home-page "https://github.com/zkat/supports-unicode")
    (synopsis "Detects whether a terminal supports unicode.")
    (description "Detects whether a terminal supports unicode.")
    (license license:asl2.0)))

(define-public rust-supports-hyperlinks-2
  (package
    (name "rust-supports-hyperlinks")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "supports-hyperlinks" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0g93nh1db3f9lyd0ry35bqjrxkg6sbysn36x9hgd9m5h5rlk2hpq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-is-terminal" ,rust-is-terminal-0.4))))
    (home-page "https://github.com/zkat/supports-hyperlinks")
    (synopsis "Detects whether a terminal supports rendering hyperlinks.")
    (description "Detects whether a terminal supports rendering hyperlinks.")
    (license license:asl2.0)))

(define-public rust-miette-derive-5
  (package
    (name "rust-miette-derive")
    (version "5.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "miette-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p33msrngkxlp5ajm8nijamii9vcwwpy8gfh4m53qnmrc0avrrs9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/zkat/miette")
    (synopsis "Derive macros for miette. Like `thiserror` for Diagnostics.")
    (description
     "Derive macros for miette.  Like `thiserror` for Diagnostics.")
    (license license:asl2.0)))

(define-public rust-backtrace-ext-0.2
  (package
    (name "rust-backtrace-ext")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "backtrace-ext" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0l4xacjnx4jrn9k14xbs2swks018mviq03sp7c1gn62apviywysk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "https://github.com/gankra/backtrace-ext")
    (synopsis "minor conveniences on top of the backtrace crate")
    (description "minor conveniences on top of the backtrace crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-miette-5
  (package
    (name "rust-miette")
    (version "5.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "miette" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vl5qvl3bgha6nnkdl7kiha6v4ypd6d51wyc4q1bvdpamr75ifsr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-backtrace-ext" ,rust-backtrace-ext-0.2)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-miette-derive" ,rust-miette-derive-5)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-owo-colors" ,rust-owo-colors-3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-supports-color" ,rust-supports-color-2)
                       ("rust-supports-hyperlinks" ,rust-supports-hyperlinks-2)
                       ("rust-supports-unicode" ,rust-supports-unicode-2)
                       ("rust-terminal-size" ,rust-terminal-size-0.1)
                       ("rust-textwrap" ,rust-textwrap-0.15)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/zkat/miette")
    (synopsis
     "Fancy diagnostic reporting library and protocol for us mere mortals who aren't compiler hackers.")
    (description
     "Fancy diagnostic reporting library and protocol for us mere mortals who aren't
compiler hackers.")
    (license license:asl2.0)))

(define-public rust-libc-0.2
  (package
    (name "rust-libc")
    (version "0.2.149")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16z2zqswcbk1qg5yigfyr0d44v0974amdaj564dmv5dpi2y770d0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/rust-lang/libc")
    (synopsis "Raw FFI bindings to platform libraries like libc.
")
    (description "Raw FFI bindings to platform libraries like libc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-nix-0.27
  (package
    (name "rust-nix")
    (version "0.27.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nix" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ly0kkmij5f0sqz35lx9czlbk6zpihb7yh1bsy4irzwfd2f4xc1f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-memoffset" ,rust-memoffset-0.9)
                       ("rust-pin-utils" ,rust-pin-utils-0.1))))
    (home-page "https://github.com/nix-rust/nix")
    (synopsis "Rust friendly bindings to *nix APIs")
    (description "Rust friendly bindings to *nix APIs")
    (license license:expat)))

(define-public rust-ctrlc-3
  (package
    (name "rust-ctrlc")
    (version "3.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ctrlc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pyglsl1j3b54mdgv1bkxnvgp823n11pkipxmxabh18rcaymzsc2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nix" ,rust-nix-0.27)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/Detegr/rust-ctrlc")
    (synopsis "Easy Ctrl-C handler for Rust projects")
    (description "Easy Ctrl-C handler for Rust projects")
    (license (list license:expat license:asl2.0))))

(define-public rust-signal-hook-0.3
  (package
    (name "rust-signal-hook")
    (version "0.3.17")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "signal-hook" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0098nsah04spqf3n8niirmfym4wsdgjl57c78kmzijlq8xymh8c6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-signal-hook-registry" ,rust-signal-hook-registry-1))))
    (home-page "https://github.com/vorner/signal-hook")
    (synopsis "Unix signal handling")
    (description "Unix signal handling")
    (license (list license:asl2.0 license:expat))))

(define-public rust-filedescriptor-0.8
  (package
    (name "rust-filedescriptor")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "filedescriptor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vplyh0cw35kzq7smmp2ablq0zsknk5rkvvrywqsqfrchmjxk6bi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "More ergonomic wrappers around RawFd and RawHandle")
    (description
     "More ergonomic wrappers around @code{RawFd} and @code{RawHandle}")
    (license license:expat)))

(define-public rust-crossterm-winapi-0.9
  (package
    (name "rust-crossterm-winapi")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "crossterm_winapi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0axbfb2ykbwbpf1hmxwpawwfs8wvmkcka5m561l7yp36ldi7rpdc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/crossterm-rs/crossterm-winapi")
    (synopsis
     "WinAPI wrapper that provides some basic simple abstractions around common WinAPI calls")
    (description
     "@code{WinAPI} wrapper that provides some basic simple abstractions around common
@code{WinAPI} calls")
    (license license:expat)))

(define-public rust-crossterm-0.27
  (package
    (name "rust-crossterm")
    (version "0.27.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "crossterm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pr413ki440xgddlmkrc4j1bfx1h8rpmll87zn8ykja1bm2gwxpl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-crossterm-winapi" ,rust-crossterm-winapi-0.9)
                       ("rust-filedescriptor" ,rust-filedescriptor-0.8)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-signal-hook" ,rust-signal-hook-0.3)
                       ("rust-signal-hook-mio" ,rust-signal-hook-mio-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/crossterm-rs/crossterm")
    (synopsis "A crossplatform terminal library for manipulating terminals.")
    (description
     "This package provides a crossplatform terminal library for manipulating
terminals.")
    (license license:expat)))

(define-public rust-nu-0.86
  (package
    (name "rust-nu")
    (version "0.86.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kv18sgvcszwb1prfnp3jsd3rdgbvfmrdbs3yb30pp61rdmnz1lw"))))
    (build-system cargo-build-system)
    (propagated-inputs (list openssl))
    (native-inputs (list pkg-config))
    (arguments
     `(#:tests? #f
       #:cargo-inputs (("rust-crossterm" ,rust-crossterm-0.27)
                       ("rust-ctrlc" ,rust-ctrlc-3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-miette" ,rust-miette-5)
                       ("rust-mimalloc" ,rust-mimalloc-0.1)
                       ("rust-nix" ,rust-nix-0.27)
                       ("rust-nu-ansi-term" ,rust-nu-ansi-term-0.49)
                       ("rust-nu-cli" ,rust-nu-cli-0.86)
                       ("rust-nu-cmd-base" ,rust-nu-cmd-base-0.86)
                       ("rust-nu-cmd-dataframe" ,rust-nu-cmd-dataframe-0.86)
                       ("rust-nu-cmd-extra" ,rust-nu-cmd-extra-0.86)
                       ("rust-nu-cmd-lang" ,rust-nu-cmd-lang-0.86)
                       ("rust-nu-color-config" ,rust-nu-color-config-0.86)
                       ("rust-nu-command" ,rust-nu-command-0.86)
                       ("rust-nu-engine" ,rust-nu-engine-0.86)
                       ("rust-nu-explore" ,rust-nu-explore-0.86)
                       ("rust-nu-json" ,rust-nu-json-0.86)
                       ("rust-nu-parser" ,rust-nu-parser-0.86)
                       ("rust-nu-path" ,rust-nu-path-0.86)
                       ("rust-nu-plugin" ,rust-nu-plugin-0.86)
                       ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.86)
                       ("rust-nu-protocol" ,rust-nu-protocol-0.86)
                       ("rust-nu-std" ,rust-nu-std-0.86)
                       ("rust-nu-system" ,rust-nu-system-0.86)
                       ("rust-nu-table" ,rust-nu-table-0.86)
                       ("rust-nu-term-grid" ,rust-nu-term-grid-0.86)
                       ("rust-nu-utils" ,rust-nu-utils-0.86)
                       ("rust-openssl" ,rust-openssl-0.10)
                       ("rust-reedline" ,rust-reedline-0.25)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-signal-hook" ,rust-signal-hook-0.3)
                       ("rust-simplelog" ,rust-simplelog-0.12)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-winresource" ,rust-winresource-0.1))
       #:cargo-development-inputs (("rust-assert-cmd" ,rust-assert-cmd-2)
                                   ("rust-criterion" ,rust-criterion-0.5)
                                   ("rust-nu-test-support" ,rust-nu-test-support-0.86)
                                   ("rust-pretty-assertions" ,rust-pretty-assertions-1)
                                   ("rust-rstest" ,rust-rstest-0.18)
                                   ("rust-serial-test" ,rust-serial-test-2)
                                   ("rust-tempfile" ,rust-tempfile-3))))
    (home-page "https://www.nushell.sh")
    (synopsis "A new type of shell")
    (description "This package provides a new type of shell")
    (license license:expat)))

(define-public rust-randomize-3
  (package
    (name "rust-randomize")
    (version "3.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "randomize" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02ll7r3rrpmhjx34w91m1yvqw1685bq2n9amqvycjcqznncqrhw8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rand-core" ,rust-rand-core-0.5)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Lokathor/randomize")
    (synopsis "Randomization routines")
    (description "Randomization routines")
    (license license:bsd-0)))

(define-public rust-oorandom-11
  (package
    (name "rust-oorandom")
    (version "11.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "oorandom" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xdm4vd89aiwnrk1xjwzklnchjqvib4klcihlc2bsd4x50mbrc8a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-development-inputs (("rust-rand-core" ,rust-rand-core-0.5)
                                   ("rust-rand-pcg" ,rust-rand-pcg-0.2)
                                   ("rust-random-fast-rng" ,rust-random-fast-rng-0.1)
                                   ("rust-randomize" ,rust-randomize-3))))
    (home-page "https://sr.ht/~icefox/oorandom/")
    (synopsis "A tiny, robust PRNG implementation.")
    (description "This package provides a tiny, robust PRNG implementation.")
    (license license:expat)))

;; (define-public rust-regex-1
;;   (package
;;     (name "rust-regex")
;;     (version "1.9.1")
;;     (source
;;      (origin
;;        (method url-fetch)
;;        (uri (crate-uri "regex" version))
;;        (file-name (string-append name "-" version ".tar.gz"))
;;        (sha256
;;         (base32 "0xdmrvs8fy7yw2bdk76mjbhzqibms7g4ljg468jwzxr0qa7ydsmj"))))
;;     (build-system cargo-build-system)
;;     (arguments
;;      `(#:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-1)
;;                        ("rust-memchr" ,rust-memchr-2)
;;                        ("rust-regex-automata" ,rust-regex-automata-0.3)
;;                        ("rust-regex-syntax" ,rust-regex-syntax-0.7))
;;        #:cargo-development-inputs (("rust-anyhow" ,rust-anyhow-1)
;;                                    ("rust-doc-comment" ,rust-doc-comment-0.3)
;;                                    ("rust-env-logger" ,rust-env-logger-0.9)
;;                                    ("rust-once-cell" ,rust-once-cell-1)
;;                                    ("rust-quickcheck" ,rust-quickcheck-1)
;;                                    ("rust-regex-test" ,rust-regex-test-0.1))))
;;     (home-page "https://github.com/rust-lang/regex")
;;     (synopsis
;;      "An implementation of regular expressions for Rust. This implementation uses
;; finite automata and guarantees linear time matching on all inputs.
;; ")
;;     (description
;;      "An implementation of regular expressions for Rust.  This implementation uses
;; finite automata and guarantees linear time matching on all inputs.")
;;     (license (list license:expat license:asl2.0))))

