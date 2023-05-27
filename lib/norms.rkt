#lang racket

;;;=====================================================================
;;; Norms: Normalization process
;;;        This module performs the normalize-clues, normalize-unknowns,
;;;         and normalize-unknowns functions repeatedly until no further
;;;         changes in the clues are detected.
;;;         Also provides the ans query.
;;;=====================================================================

(require "lms-utils.rkt"
         "init.rkt"
         "clues.rkt"
         "knowns.rkt"
         "unknowns.rkt")

(module+ test
  (require rackunit
           (submod "..")))

(define (normalize clues (idx 0))
  #;(define norms (list normalize-clues normalize-unknowns normalize-knowns))
  (define norms (compose normalize-knowns normalize-unknowns normalize-clues))
  (define (f clues nf)
    (define old-clues (list->set (map vector-copy clues)))
    (define new-clues (nf clues))
    (values new-clues (not (set=? old-clues (list->set new-clues)))))
  
  #;(define-values (result modified?) (f clues (list-ref norms (modulo idx 3))))
  (define-values (result modified?) (f clues norms))
  (cond
    [(false? modified?) result]
    #;[else (normalize result (add1 idx))]
    [else (normalize result)]))

;; match-slot? slot1 slot2 => boolean?
;; Returns true if slot1 equals slot2, false otherwise.
(define (match-slot? slot1 slot2) (and (or slot1 slot2) (equal? slot1 slot2)))

(module+ test
  (test-case "match-slot? tests"
             (check-false (match-slot? #f #f))
             (check-false (match-slot? #f 'foo))
             (check-false (match-slot? (gensym) (gensym)))
             (check-true (match-slot? 'foo 'foo))))

(define (match-clue clue clues)
  (define (loop clue clues)
    (cond
      [(empty? clues) #f]
      [(match-clue? clue (first clues)) (first clues)]
      [else (match-clue clue (rest clues))]))
  (loop clue (remove clue clues)))

(module+ test
  (test-case "match-clue tests"
             (define CLUES '(#(tom #f #f #f)
                             #(fred #f white #f)
                             #(tom #f #f green)))
             (check-equal? (match-clue (first CLUES) CLUES)
                           #(tom #f #f green))
             (check-false (match-clue #(bob #f purple #f) CLUES))))

;; match-clue: clue1 clue2 => boolean?
;; Returnes true if any slot of clue1 symbol matches the
;; associated slot of clue2, false otherwise.
(define (match-clue? clue1 clue2)
  (define clue-f (λ (clue1 clue2) (or clue1 clue2)))
  (vector-match clue-f #f match-slot? clue1 clue2))

(module+ test
  (test-case "match-clue? tests"
             (check-true (match-clue? #(tom-edison #f #f #f #f #f)
                                      #(tom-edison #f #f #f white green)))
             (check-true (match-clue? #(tom-edison #f #f #f white #f)
                                      (vector (gensym) #f #f #f 'white 'green)))))

(define (answer . kvals)
  (define clues (normalize (current-clues)))
  (define srch (make-vector (vector-length (current-categories))))
  (for ([kval kvals])
    (define key (first kval))
    (define val (cond
                  [(eq? '? (second kval)) (gensym)]
                  [else (second kval)]))
    (define idx (vector-member key (current-categories)))
    (vector-set! srch idx val))
  (define match (match-clue srch clues))
  (if (false? match)
      #f
      (for/list ([kval kvals])
    (define key (first kval))
    (define val (second kval))
    (define idx (vector-member key (current-categories)))
    (list key (vector-ref match idx)))))

(provide ans)
(define-syntax-rule (ans (key val) ...)
  (answer (list (quote key) (quote val)) ...))