;;; kde.scm --- Personal fixes for KDE packages.
;;;
;;; Why this exists:
;;;   Upstream kio@5.116.0 (KF5, the `kio-5' package) fails its
;;;   check phase in the Guix build sandbox: 52/53 tests pass, but
;;;   kiofilewidgets-kfilefiltercombotest fails
;;;   (KFileFilterComboTest::testSetMimeFilter*, "Compared lists
;;;   differ" -- the expected MIME filter list does not match what
;;;   the sandbox's MIME database produces).  There is currently
;;;   no substitute for kio@5.116.0 (checked 2026-11-19, guix
;;;   commit 7e547b4), so everything depending on it (krita, via
;;;   kparts/kxmlgui/...) cannot be built at all.
;;;
;;; Why plain rewriting does not fix krita:
;;;   Both `--without-tests=kio' and a whole-graph
;;;   package-input-rewriting/spec leave a tests-enabled kio
;;;   derivation in krita's graph.  Tracing the derivation graph
;;;   (2026-11-20) shows why: kdbusaddons-5 takes `kinit-bootstrap'
;;;   as an input -- a second, "primed" copy of the KF5 stack
;;;   that upstream builds by rewriting kinit once (swapping
;;;   kdbusaddons-5 for a bootstrap variant with no kinit input,
;;;   to break the kinit <-> kdbusaddons cycle; kdbusaddons-5
;;;   needs kinit's kdeinit5 executable at build time).  That
;;;   primed stack contains its own kio (a distinct package
;;;   object, also named "kio" version 5.116.0), and the stock
;;;   kparts/plasma-framework/kactivities/kdeclarative/kinit
;;;   derivations hang off it.
;;;
;;; Fix strategy:
;;;   Mirror upstream's structure with tests disabled:
;;;   - kio-5/fixed: stock kio-5 with tests off, its kdbusaddons
;;;     edge pointing at the fixed kdbusaddons.
;;;   - kdbusaddons-5/fixed: stock kdbusaddons-5, its kinit edge
;;;     pointing at the fixed bootstrap.
;;;   - kinit-bootstrap/fixed: the stock bootstrap rewritten by
;;;     spec, so every kio@5.116.0 in its (acyclic) graph becomes
;;;     tests-disabled.
;;;   - krita/fixed: krita rewritten by package identity, mapping
;;;     the three stock objects above to the fixed ones, with
;;;     #:recursive? #t so the replacements are also applied
;;;     inside the fixed packages' own inputs (kio's other inputs
;;;     -- ktextwidgets, kwallet, kded, kservice, ... -- themselves
;;;     depend on kdbusaddons-5 / kio-5; without recursion those
;;;     edges stay stock and drag the failing kio back in through
;;;     kservice -> kdbusaddons -> kinit).
;;;   Pointing the bootstrap back at kio-5/fixed instead would
;;;   close a real object cycle (kio -> kdbusaddons -> kinit ->
;;;   kio), which Guix rejects with "dependency cycle detected".
;;;
;;; Status (2026-11-20): with the definitions below,
;;; `guix build --dry-run' of krita/fixed lists exactly one
;;; kio-5.116.0 derivation and the failing stock derivation
;;; (pmi59y8z...) is gone from the graph.

(define-module (kde)
  #:use-module (gnu packages)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1))

;;; --- helpers ----------------------------------------------------

;;; The package object bound to LABEL among PKG's inputs (any of
;;; the three input fields), or #f.
(define (input-by-label pkg label)
  (let ((hit (find (lambda (inp)
                     (and (pair? inp) (equal? (car inp) label)))
                   (append (package-inputs pkg)
                           (package-propagated-inputs pkg)
                           (package-native-inputs pkg)))))
    (and hit (cadr hit))))

;;; Return PKG with the input labelled LABEL replaced by NEW, in
;;; whichever input field holds it.  Fields without LABEL are
;;; left untouched.
(define (swap-input pkg label new)
  (define (try inputs)
    (if (assoc label inputs)
        (modify-inputs inputs (replace label new))
        inputs))
  (package
    (inherit pkg)
    (inputs (try (package-inputs pkg)))
    (propagated-inputs (try (package-propagated-inputs pkg)))
    (native-inputs (try (package-native-inputs pkg)))))

;;; Any kio package with its tests disabled.
(define (kio->no-tests pkg)
  (package
    (inherit pkg)
    (arguments
     (substitute-keyword-arguments (package-arguments pkg)
       ((#:tests? _ #t) #f)))))

;;; --- the stock bootstrap, extracted by label ---------------------
;;; (kinit-bootstrap is not exported by name, so pull the exact
;;; object out of the package that uses it.)

(define stock-kinit-bootstrap
  (input-by-label kdbusaddons-5 "kinit"))

;;; --- the fixed packages -------------------------------------------

;;; kio with tests disabled; its kdbusaddons edge points at the
;;; fixed kdbusaddons below.  The inputs field is thunked, so the
;;; forward reference is fine.
(define-public kio-5/fixed
  (package
    (inherit kio-5)
    (arguments
     (substitute-keyword-arguments (package-arguments kio-5)
       ((#:tests? _ #t) #f)))
    (inputs
     (modify-inputs (package-inputs kio-5)
       (replace "kdbusaddons" kdbusaddons-5/fixed)))))

;;; The stock bootstrap, with every kio@5.116.0 in its graph
;;; (the primed kio included) made tests-disabled.  Its graph
;;; has no cycles, so the rewriting cannot be cut short.
(define-public kinit-bootstrap/fixed
  ((package-input-rewriting/spec
    `(("kio@5.116.0" . ,kio->no-tests))
    #:replace-hidden? #t)
   stock-kinit-bootstrap))

(define-public kdbusaddons-5/fixed
  (swap-input kdbusaddons-5 "kinit" kinit-bootstrap/fixed))

;;; --- krita --------------------------------------------------------

(define-public krita/fixed
  ;; krita with the three stock objects replaced by the fixed
  ;; variants above (identity-based rewriting, applied
  ;; recursively so the fixed packages' own inputs are rewritten
  ;; with the same mapping).
  ((package-input-rewriting
    `((,kio-5 . ,kio-5/fixed)
      (,kdbusaddons-5 . ,kdbusaddons-5/fixed)
      (,stock-kinit-bootstrap . ,kinit-bootstrap/fixed))
    #:recursive? #t)
   (specification->package "krita")))

;;; --- standalone variant, for direct use / debugging --------------
;;;   guix build -L <this-repo> kio-no-tests
;;; NOTE: installing this alone does not fix krita; krita must be
;;; the rewritten variant above so its whole graph uses it.
(define-public kio-5-no-tests
  (let ((orig (specification->package "kio@5.116.0")))
    (package
      (inherit orig)
      (name "kio-no-tests")
      (arguments
       (substitute-keyword-arguments (package-arguments orig)
         ((#:tests? _ #t) #f))))))
