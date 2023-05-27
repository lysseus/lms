#lang racket

;;;==========================================================================
;;; Clues:
;;; Normalize the clues through exact symbol matching unification.
;;;===========================================================

(require "lms-utils.rkt")

(module+ test (require rackunit
                       (submod "..")))

;; match-slot? slot1 slot2 => boolean?
;; Returns true if slot1 equals slot2, false otherwise.
(define (match-slot? slot1 slot2) (and (or slot1 slot2) (equal? slot1 slot2)))

(module+ test
  (test-case "match-slot? tests"
             (check-false (match-slot? #f #f))
             (check-false (match-slot? #f 'foo))
             (check-false (match-slot? (gensym) (gensym)))
             (check-true (match-slot? 'foo 'foo))))

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

;; match-clue clue clues: (or clue? boolean?)
;; Returns the first clue that has a symbol match for any given
;; slot, or #f if no matching clue is found. 
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

;; match-and-unify clues => list of clues
;; Iterates over each clue in clues, matching it against them.
;; If any matches are found the clue is unified with its match,
;; producing a new clue, which is added to the list of unified
;; clues. If there is no match for the clue it is simply added
;; to the unified list. Returns the unified list of clues.
(define (match-and-unify clues) 
  (define (loop matched? clues unified)
    (cond
      [(empty? clues) (values unified matched?)]
      [else
       (define curr (first clues))
       (define match (match-clue curr (remove curr unified)))
       (cond
         [(false? match)
          (loop (or #f matched?) (rest clues) (cons curr unified))]
         [else (loop (or #t matched?)
                     (rest clues)
                     (cons (unify curr match) (remove match unified)))])]))
  (loop #f clues empty))

(module+ test
  (test-case "match-and-unify tests"
             (define CLUES (list
                            #(a #f #f)
                            #(b #f #f)
                            #(a 10 #f)
                            (vector (gensym) 10 'foo)
                            (vector (gensym) 20 #f)
                            #(b 20 bar)))
             (define-values (u1 m1?)
               (match-and-unify CLUES))
             (check-true m1?)
             (check-equal? u1 '(#(b 20 bar) #(a 10 foo) #(b #f #f)))
             (define-values (u2 m2?) (match-and-unify u1))
             (check-true m2?)
             (check-equal? u2 '(#(b 20 bar) #(a 10 foo)))
             (define-values (u3 m3?) (match-and-unify u2))
             (check-false m3?)
             (check-equal? (list->set u2)
                           (list->set u3))))

(provide normalize-clues)
;; normalize-clues: clues => clues
;; Loops over match-and-unify until it returns false. Returns
;; a new list of unified clues. 
(define (normalize-clues clues)
  (until match-and-unify false? clues))

(module+ test
  (test-case "normalize-clues tests"
             (define CLUES (list
                            #(a #f #f)
                            #(b #f #f)
                            #(a 10 #f)
                            (vector (gensym) 10 'foo)
                            (vector (gensym) 20 #f)
                            #(b 20 bar)))
             (check-equal? (normalize-clues CLUES)
                           '(#(a 10 foo) #(b 20 bar)))))