(define-module (cm)
  #:use-module (gnu packages)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages autogen)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages pulseaudio)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system cmake)
  #:use-module (guix build utils)
  #:use-module ((guix licenses) #:prefix license:))

(define-public grace
  (package
    (name "grace")
    (version "3.10.2")
    (source
     (origin
       (method url-fetch)
	 (uri
	  (string-append "https://downloads.sourceforge.net/project/commonmusic/cm/" version "/cm-" version ".zip"))
       (sha256
	(base32 "0dhkn6nl31fdaf68w7yclgpa0xvlmicjxqd385zpzzl2cpxw7631"))))
    (build-system gnu-build-system)
    (native-inputs (list premake4 pkg-config unzip gcc-toolchain-5 bash))
    (inputs (list alsa-lib libxext libxt freetype libxinerama libsamplerate gtk+ snd curl glu))
    (arguments (list #:tests? #f
		     #:parallel-build? #f
		     #:phases #~(modify-phases %standard-phases
;					       (with-directory-excursion "sndlib" configure)
					       (add-before 'patch-source-shebangs 'sh-to-bash
					       		(lambda* (#:key inputs outputs #:allow-other-keys) (invoke "sed" "-e" (string-append "s#/bin/sh#" #$bash "/bin/bash#g") "-i" "sndlib/configure")))
					       (replace 'configure 
							(lambda* (#:key build inputs outputs #:allow-other-keys)
;							  (copy-recursively (string-append #$config "/bin/") "./sndlib")
							  (with-directory-excursion
							   "sndlib"
							   (invoke "./configure"
								   (string-append "--prefix=" (assoc-ref outputs "out"))
								   (string-append "--build=" build)))))
					       (add-before 'build 'premake
							   (lambda* (#:key inputs outputs #:allow-other-keys)
					;						     (copy-recursively #$JUCE "juce")
							     (invoke "premake4")
							     ;; (invoke "sed" "-e" "s/premake/premake4/g" "-i" "./sndlib/config.sub")
							     
							     (invoke "sed" "-e" "s/-lsndlib/sndlib\\/libsndlib.a/g" "-i" "Grace.make")
							     ))
					       (replace 'install
							(lambda* (#:key outputs #:allow-other-keys)
							  (let ((out (assoc-ref outputs "out")))
							    (mkdir-p (string-append out "/usr/bin"))
							    (install-file "bin/Grace" (string-append out "/bin"))))))))
    (synopsis "Graphical Realtime Algorithmic Composition Environment")
    (description "Grace (Graphical Realtime Algorithmic Composition Environment) 
   A drag-and-drop GUI with embedded Scheme interpreter (Sndlib/S7),
   code editor, data plotter and realtime connections to various
   packages such as MIDI, OSC, CLM, Csound, Fomus and SDIF.")
    (home-page "https://sourceforge.net/projects/commonmusic/")
    (license license:gpl2)))

(define-public grace-3.9.0
  (package
    (name "grace")
    (version "3.9.0")
    (source
     (origin
       (method url-fetch)
	 (uri
	  (string-append "https://downloads.sourceforge.net/project/commonmusic/cm/" version "/cm-" version ".zip"))
       (sha256
	(base32 "02p8ja16g0wg15l9p4ivk4w57rc5z9s9iz1lbiq62m7y93v7n1cb"))))
    (build-system gnu-build-system)
    (native-inputs (list premake4 pkg-config unzip gcc-toolchain-5 bash))
    (inputs (list alsa-lib libxext libxt freetype libxinerama libsamplerate gtk+ snd curl glu))
    (arguments (list #:tests? #f
		     #:parallel-build? #f
		     #:phases #~(modify-phases %standard-phases
;					       (with-directory-excursion "sndlib" configure)
					       (add-before 'patch-source-shebangs 'sh-to-bash
					       		(lambda* (#:key inputs outputs #:allow-other-keys) (invoke "sed" "-e" (string-append "s#/bin/sh#" #$bash "/bin/bash#g") "-i" "sndlib/configure")))
					       (replace 'configure 
							(lambda* (#:key build inputs outputs #:allow-other-keys)
;							  (copy-recursively (string-append #$config "/bin/") "./sndlib")
							  (with-directory-excursion
							   "sndlib"
							   (invoke "./configure"
								   (string-append "--prefix=" (assoc-ref outputs "out"))
								   (string-append "--build=" build)))))
					       (add-before 'build 'premake
							   (lambda* (#:key inputs outputs #:allow-other-keys)
					;						     (copy-recursively #$JUCE "juce")
							     (invoke "premake4")
							     ;; (invoke "sed" "-e" "s/premake/premake4/g" "-i" "./sndlib/config.sub")
							     
							     (invoke "sed" "-e" "s/-lsndlib/sndlib\\/libsndlib.a/g" "-i" "Grace.make")
							     ))
					       (replace 'install
							(lambda* (#:key outputs #:allow-other-keys)
							  (let ((out (assoc-ref outputs "out")))
							    (mkdir-p (string-append out "/usr/bin"))
							    (install-file "bin/Grace" (string-append out "/bin"))))))))
    (synopsis "Graphical Realtime Algorithmic Composition Environment")
    (description "Grace (Graphical Realtime Algorithmic Composition Environment) 
   A drag-and-drop GUI with embedded Scheme interpreter (Sndlib/S7),
   code editor, data plotter and realtime connections to various
   packages such as MIDI, OSC, CLM, Csound, Fomus and SDIF.")
    (home-page "https://sourceforge.net/projects/commonmusic/")
    (license license:gpl2)))

;; (define-public JUCE
;;   (package
;;     (name "JUCE")
;;     (version "7.0.9")
;;     (source (origin (method git-fetch)
;; 		    (uri (git-reference (url "https://github.com/juce-framework/JUCE")
;; 					(commit version)))

;; 		    (sha256 (base32 "0s6qkklrmw52nz5l6fzab8kyb4vpmfx4hv47pyd06fpxy560viwk"))))
;;     (build-system copy-build-system)
;; ;    (native-inputs (list pkg-config))
;; ;    (inputs (list alsa-lib libxext libxt freetype libxinerama libsamplerate gtk+))
;; ;    (arguments `(#:tests? #f))
;;     ;; (arguments `(#:phases (modify-phases %standard-phases
;;     ;; 					 (delete 'configure)
;;     ;; 					 (add-before 'build 'premake (lambda _ (invoke "premake4"))))))
;;     (synopsis "Graphical Realtime Algorithmic Composition Environment")
;;     (description "JUCE is an open-source cross-platform C++ application framework for creating high quality desktop and mobile applications, including VST, VST3, AU, AUv3, AAX and LV2 audio plug-ins and plug-in hosts. JUCE can be easily integrated with existing projects via CMake, or can be used as a project generation tool via the Projucer, which supports exporting projects for Xcode (macOS and iOS), Visual Studio, Android Studio, Code::Blocks and Linux Makefiles as well as containing a source code editor.")
;;     (home-page "https://github.com/juce-framework/JUCE/")
;;     (license license:expat)))
