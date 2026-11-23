;;; howdy.scm --- Howdy (face authentication) packages for Guix
;;;
;;; Draft packaging of boltgolt/howdy 3.0.2, which is not in Guix or
;;; nonguix yet.  Contains three packages:
;;;   inih             -- tiny INI parser library (C/C++), needed by pam_howdy
;;;   howdy-dlib-data  -- the three dlib model files howdy compares against
;;;   howdy            -- the PAM module (C++) and the Python CLI/recognizer

(define-module (howdy)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xorg))

;;; ---------------------------------------------------------------------------
;;; inih
;;; ---------------------------------------------------------------------------

(define-public inih
  (package
    (name "inih")
    (version "62")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/benhoyt/inih/archive/refs/tags/r"
                           version ".tar.gz"))
       (sha256
        (base32 "0lc19w6ldpnch5acs1375k1rhldlbq99y6xf5l23s2dq3dszl5cw"))))
    (build-system meson-build-system)
    (arguments
     (list #:configure-flags
           #~(list "-Ddistro_install=true"
                   "-Dwith_INIReader=true")))
    (home-page "https://github.com/benhoyt/inih")
    (synopsis "Simple INI file parser library in C")
    (description
     "inih is a tiny, single-file INI file parser written in C, with a
C++ wrapper (INIReader) used by Howdy's PAM module.")
    (license license:bsd-3)))

;;; ---------------------------------------------------------------------------
;;; howdy-dlib-data
;;; ---------------------------------------------------------------------------

(define (dlib-model-file file-name hash)
  (origin
    (method url-fetch)
    (uri (string-append
          "https://github.com/davisking/dlib-models/raw/master/"
          file-name ".bz2"))
    (sha256 (base32 hash))))

(define-public howdy-dlib-data
  (package
    (name "howdy-dlib-data")
    (version "0")
    (source
     (dlib-model-file "dlib_face_recognition_resnet_model_v1.dat"
                      "0fjm265l1fz5zdzx5n5yphl0v0vfajyw50ffamc4cd74848gdcdb"))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'build)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (string-append (assoc-ref outputs "out")
                                       "/share/dlib-data")))
               (mkdir-p out)
               ;; The package source (the resnet model) is a lone .bz2
               ;; file, which the unpack phase has already decompressed
               ;; into the build directory as a plain .dat file.  The
               ;; other two models arrive as labelled .bz2 inputs.
               (copy-file (car (find-files "." "\\.dat$"))
                          (string-append
                           out "/dlib_face_recognition_resnet_model_v1.dat"))
               (for-each
                (lambda (pair)
                  (invoke "sh" "-c"
                          (string-append "bunzip2 -c " (car pair)
                                         " > " out "/" (cdr pair))))
                (list (cons (assoc-ref inputs "mmod-model")
                            "mmod_human_face_detector.dat")
                      (cons (assoc-ref inputs "shape-model")
                            "shape_predictor_5_face_landmarks.dat")))
               #t))))))
    (native-inputs
     `(("mmod-model"
        ,(dlib-model-file "mmod_human_face_detector.dat"
                          "117wv582nsn585am2n9mg5q830qnn8skjr1yxgaiihcjy109x7nv"))
       ("shape-model"
        ,(dlib-model-file "shape_predictor_5_face_landmarks.dat"
                          "0wm4bbwnja7ik7r28pv00qrl3i1h6811zkgnjfvzv7jwpyz7ny3f"))
       ("bzip2" ,bzip2)))
    (home-page "https://github.com/davisking/dlib-models")
    (synopsis "Dlib face recognition model files for Howdy")
    (description
     "Pre-trained dlib model files (face recognition resnet, MMOD face
detector, 5-point shape predictor) that Howdy loads at runtime.")
    ;; The models are distributed under the dlib license terms.
    (license license:boost1.0)))

;;; ---------------------------------------------------------------------------
;;; howdy
;;; ---------------------------------------------------------------------------

(define-public howdy
  (package
    (name "howdy")
    (version "3.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/boltgolt/howdy/archive/refs/tags/v"
             version ".tar.gz"))
       (sha256
        (base32 "01cdxz8dbd7arkavn9czwlw44wmkxq44spw4l88bcnzymi4fqlkv"))))
    (build-system meson-build-system)
    (arguments
     (list #:tests? #f
           #:configure-flags
           ;; Bake the real runtime locations into the package:
           ;; config and face models live in /etc/howdy (writable, root
           ;; owned), and the interpreter is the PYTHONPATH wrapper
           ;; created by the create-python-wrapper phase below, so the
           ;; PAM module can import dlib/numpy/cv2 even as root.
           ;; install_config is off because meson would otherwise try
           ;; to write config.ini into /etc/howdy during the build.
           #~(list (string-append "-Dpython_path=" #$output
                                  "/lib/howdy/howdy-python")
                   "-Dconfig_dir=/etc/howdy"
                   "-Duser_models_dir=/etc/howdy/models"
                   "-Dinstall_config=false")
           #:phases
           #~(modify-phases %standard-phases
               ;; The tarball ships the meson project in the howdy/
               ;; subdirectory (next to howdy-gtk/).
               (add-before 'configure 'chdir-to-project
                 (lambda _
                   (chdir "howdy")))
               ;; Meson installs only helper files into the dlib data
               ;; dir; copy the actual model files from howdy-dlib-data.
               ;; (Pointing -Ddlib_data_dir at the input instead makes
               ;; meson try to install into the read-only store path.)
               (add-after 'install 'install-dlib-models
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (let ((models (string-append
                                  (assoc-ref inputs "howdy-dlib-data")
                                  "/share/dlib-data"))
                         (dest (string-append
                                (assoc-ref outputs "out")
                                "/share/dlib-data")))
                     (for-each (lambda (f)
                                 (copy-file (string-append models "/" f)
                                            (string-append dest "/" f)))
                               '("dlib_face_recognition_resnet_model_v1.dat"
                                 "mmod_human_face_detector.dat"
                                 "shape_predictor_5_face_landmarks.dat")))))
               ;; A tiny interpreter wrapper that carries the site
               ;; packages of the inputs on PYTHONPATH.  It must exist
               ;; before configure: meson executes the interpreter
               ;; named by python_path to probe it, so the wrapper is
               ;; written straight into the (future) output tree first.
               (add-before 'configure 'create-python-wrapper
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (let* ((out (assoc-ref outputs "out"))
                          (wrapper (string-append
                                    out "/lib/howdy/howdy-python"))
                          (site-dirs
                           (map (lambda (input)
                                  (car (find-files
                                        (assoc-ref inputs input)
                                        "site-packages$"
                                        #:directories? #t)))
                                '("python-dlib" "python-numpy" "opencv"))))
                     (mkdir-p (dirname wrapper))
                     (call-with-output-file wrapper
                       (lambda (port)
                         ;; The shebang must name a store shell: the
                         ;; build environment has no /bin/sh, and meson
                         ;; probes this interpreter during configure.
                         (format port "#!~a/bin/sh~%"
                                 (assoc-ref inputs "bash-minimal"))
                         (format port "PYTHONPATH=\"~a${PYTHONPATH:+:$PYTHONPATH}\"~%"
                                 (string-join site-dirs ":"))
                         (format port "export PYTHONPATH~%")
                         (format port "exec \"~a/bin/python3\" \"$@\"~%"
                                 (assoc-ref inputs "python"))))
                     (chmod wrapper #o555)))))))
    (native-inputs
     (list pkg-config gettext-minimal bash-minimal))
    ;; python-dlib, python-numpy and opencv are plain inputs, not
    ;; propagated ones: the create-python-wrapper phase bakes their
    ;; store paths into the wrapper's PYTHONPATH, so profiles do not
    ;; need to pull them in.
    (inputs
     (list python
           python-dlib
           python-numpy
           opencv
           inih
           libevdev
           linux-pam
           howdy-dlib-data))
    (home-page "https://github.com/boltgolt/howdy")
    (synopsis "Windows Hello style face authentication for Linux")
    (description
     "Howdy provides face authentication for Linux using a PAM module
(pam_howdy) and a Python recognizer based on dlib and OpenCV.  It works
best with an infrared camera.")
    (license license:expat)))
