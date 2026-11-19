;;; kde.scm --- Personal fixes for KDE packages.
;;;
;;; Why this exists:
;;;   Upstream kio@5.116.0 (KF5) fails its check phase in the Guix
;;;   build sandbox: 52/53 tests pass, but
;;;   kiofilewidgets-kfilefiltercombotest fails
;;;   (KFileFilterComboTest::testSetMimeFilter*, "Compared lists
;;;   differ" -- the expected MIME filter list does not match what
;;;   the sandbox's MIME database produces).  There is currently no
;;;   substitute for kio@5.116.0 (checked 2026-11-19, guix commit
;;;   7e547b4), so everything depending on it (krita, via
;;;   kparts/kxmlgui/...) cannot be built at all.
;;;
;;;   The `--without-tests=kio' transformation does not fix krita:
;;;   the krita graph contains two kio-5.116.0 derivations and the
;;;   failing one stays in the graph.
;;;
;;; Fix strategy:
;;;   Rewrite *by specification* ("kio@5.116.0"), not by identity,
;;;   so every kio instance in the graph -- direct, indirect, or
;;;   propagated -- is replaced by a variant with tests disabled.
;;;   See "package-input-rewriting/spec" in the Guix manual,
;;;   "Defining Package Variants".
;;;
;;; Status (2026-11-19, verified on the laptop):
;;;   - Package level: works.  `package-transitive-inputs' of
;;;     krita/fixed contains exactly one kio, with #:tests? #f.
;;;   - Derivation level: NOT fully solved yet.  A stock KF5
;;;     sub-graph (kdbusaddons -> kinit -> {kparts,
;;;     plasma-framework} -> {kactivities, kdeclarative} -> kio)
;;;     survives the rewriting with upstream-identical derivations,
;;;     so `guix build --dry-run' still lists the failing kio
;;;     derivation.  It is neither a hidden package nor a graft;
;;;     the remaining hypothesis is a gexp-embedded reference that
;;;     input rewriting cannot reach.  Investigation continues.

(define-module (kde)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix utils))

;;; Standalone variant, for direct use / debugging:
;;;   guix build -L <this-repo> kio-no-tests
;;; NOTE: installing this alone does not fix krita; krita must be
;;; the rewritten variant below so its whole graph uses it.
(define-public kio-5-no-tests
  (let ((orig (specification->package "kio@5.116.0")))
    (package
      (inherit orig)
      (name "kio-no-tests")
      (arguments
       (substitute-keyword-arguments (package-arguments orig)
         ((#:tests? _ #t) #f))))))

;;; Procedure that turns any kio@5.116.0 instance into a no-tests
;;; variant, preserving that instance's other arguments.
(define (kio->no-tests pkg)
  (package
    (inherit pkg)
    (arguments
     (substitute-keyword-arguments (package-arguments pkg)
       ((#:tests? _ #t) #f)))))

(define-public krita/fixed
  ;; krita with every kio@5.116.0 in its dependency graph replaced
  ;; by a tests-disabled variant.
  ((package-input-rewriting/spec
    `(("kio@5.116.0" . ,kio->no-tests))
    #:replace-hidden? #t)
   (specification->package "krita")))
