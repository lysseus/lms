#lang racket

;;;===================================================================
;;; Init: Defines globals and functions rquired to set and manipulate
;;;       categories and clues.
;;;===================================================================

(require "lms-utils.rkt")

(provide current-categories)
(define current-categories (make-parameter #f))

(provide current-cvals)
(define current-cvals (make-parameter #f))

(provide current-clues)
(define current-clues (make-parameter empty))

(provide categories)
(define-syntax-rule (categories val ...)
  (begin
    (setup-categories (quote val) ...)))

(provide clue)
(define-syntax-rule (clue (key val) ...)
  (add-clue! (list (list (quote key) (quote val)) ...)))

(define (setup-categories . lst)
  (current-clues empty) ; initialize clues
  (current-categories (apply vector lst))
  (current-cvals (make-vector (vector-length (current-categories)) empty)))

(define (log-val idx val)
  (define new-sym (symbol-trim val))
    (unless (or (member new-sym (vector-ref (current-cvals) idx))
                (and (symbol? new-sym) (not (symbol-interned? new-sym))))
      (vector-set! (current-cvals) idx
                   (cons new-sym (vector-ref (current-cvals) idx)))))

(provide set-clues!)
(define (set-clues! clues) (current-clues clues))

(provide push-clue!)
(define (push-clue! curr) (current-clues (cons curr (current-clues))))

(provide pull-clue!)
(define (pull-clue! curr) (current-clues (remove curr (current-clues))))

(define (add-clue! kvals (cats (current-categories)))
  ;; create an empty clue
  (define curr (make-vector (vector-length cats) #f))
  (for ([kval kvals])
    (define key (first kval))
    ;; convert clue key to category index
    (define idx (vector-member key cats))
    ;; validate clue key against categories.
    (when (false? idx)
      (error (format "Invalid category ~a in clue ~a~%" key kvals)))
    ;; get and convert value to symbol
    (define val (value->symbol (second kval)))
    ;; log val 
    (log-val idx val)
    ;; assign val to clue slot idx
    (vector-set! curr idx val))
  ;; add clue to CLUES
  (push-clue! curr))