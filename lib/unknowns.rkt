#lang racket

;;;================================================================================
;;; Unknowns:
;;; This step in solving the puzzle takes the unknown suspects, represented by
;;; (suspect ?) pairs, and attermpts to resolve them against the knowns. Unlike
;;; the normalization of clues this does not involve the exact matching of category
;;; values between clues, but rather finding those unknowns that uniquely match
;;; a known between all categories that have not yet been matched.
;;;
;;; Because of this, this step occurs after "Normalize Clues". 
;;;
;;; A simple example of this is the following:
;;;
;;;  suspect umbrella car
;;;  ------- -------- ----
;;;  bob     #f       #f
;;;  fred    #f       yellow
;;;  tom     brown    #f
;;;  ?       green   ~yellow
;;;
;;; In this example the unknown cannot match tom, because both
;;; have umbrella set to a value. Likewise fred is eliminated
;;; because ~yellow cannot match with yellow. So the only known
;;; remaining is bob. So we can unify bob with the unknown producing
;;; #(bob green ~yellow).  
;;;=================================================================

(require "lms-utils.rkt"
         (only-in "init.rkt" current-categories))

(module+ test (require rackunit
                       (submod "..")))

;; match-slot?: slot1 slot2 => boolean?
;; Returns true when one of the slots is false, gensym, equals the other,
;; or is a ~symbol not equal to its symbol-trim value, false toherwise.
(define (match-slot? slot1 slot2)
  (cond
    [(or (false? slot1) (false? slot2))]   ; either s1 or s2 is #f
    [(or (gensym? slot1) (gensym? slot2))] ; either s1 or s2 is gensym
    [(equal? slot1 slot2)]                 ; s1 = s2
    ;; ~symbol slot1 != slot2 
    [(and (~symbol? slot1) (not (eq? (symbol-trim slot1) slot2)))]
    ;; ~symbol slot2 != slot1
    [(and (~symbol? slot2) (not (eq? (symbol-trim slot2) slot1)))]
    [else #f]))

(module+ test
  (test-case "match-slot? tests"
             (check-true (match-slot? #f #f))
             (check-true (match-slot? #f 'foo))
             (check-true (match-slot? 'foo #f))
             (check-true (match-slot? 'foo 'foo))))

;; match-clue? clue1 clue2 => boolean?
;; Returns true if all of the slots of clue1 match the associated
;; slots of clue2, false otherwise.
(define (match-clue? clue1 clue2)
  (define clue-f (λ (slot1 slot2) (and slot1 slot2)))
  (vector-match clue-f #t match-slot? clue1 clue2))

(module+ test
  (test-case "match-clue? tests"
             (check-true (match-clue? #(tom #f blue) #(tom green ~yellow)))
             (check-true (match-clue? #(tom #f blue) (vector (gensym) 'blue '~yellow)))
             (check-false (match-clue? #(tom #f blue) #(fred blue #f)))))

;; match-unknown: unknown knowns (acc) => list of knowns
;; Returns a list of knowns matching this unknown.
(define (match-unknown unknown knowns (acc empty))  
  (cond
    [(empty? knowns) acc]
    [(match-clue? unknown (first knowns))
     (match-unknown unknown (rest knowns) (cons (first knowns) acc))]
    [else (match-unknown unknown (rest knowns) acc)]))

(module+ test
  (test-case "match-unknown tests"
             ;; bob  #f    red
             ;; fred #f    yellow
             ;; tom  brown #f
             ;; ?    green ~yellow => #(bob #f red)
             ;; 
             (check-equal? (match-unknown (vector (gensym) 'green '~yellow)
                                          '(#(bob #f red)
                                            #(fred #f yellow)
                                            #(tom brown #f)))
                           '(#(bob #f red)))))

;; match-and-unify: clues cats => (values clues modified)
;; Matches and unifies unknowns to knowns. Returns values of unified clues
;; and an indicator of whether the clues have been modified.
(define (match-and-unify clues (categories (current-categories)))
  (define new-clues clues)
  (define idx (vector-member 'suspect categories))
  (define-values (knowns n/a unknowns) (clues-split idx new-clues))
  (for ([unknown unknowns])
    (define matches (match-unknown unknown knowns))
    (when (= (length matches) 1)
      (define match (car matches))
      (set! new-clues (append (cons (unify match unknown)
                                    (remove match knowns))
                              (remove unknown unknowns)))))
  (define-values (s1 ns u1) (clues-split idx new-clues))
  (values new-clues
          (not (and (equal? knowns s1) (equal? unknowns u1)))))

(module+ test
  (test-case "match-and-unify tests"
             (define CATEGORIES #(suspect hair car))
             (define CLUES (list
                            #(bob            #f     red)
                            #(fred           #f     yellow)
                            #(tom            brown  #f)
                            (vector (gensym) 'green '~yellow)))
             (define-values (new-clues modified) (match-and-unify CLUES CATEGORIES))
             (check-equal? new-clues
                           '(#(bob green red)
                             #(tom brown #f)
                             #(fred #f yellow)))
             (check-true modified)))

(provide normalize-unknowns)
;; normalize-unknowns: clues => clues
;; Mathches and unifies unknowns to knowns until no further
;; modifications of clues is possible. Returns the list of
;; unified clues. 
(define (normalize-unknowns clues)
  (until match-and-unify false? clues))

#;(module+ test
    (test-case "normalize-unknowns tests"
               (define CATEGORIES #(suspect hair car))
               (define CLUES (list
                              #(bob            #f     red)
                              #(fred           #f     yellow)
                              #(tom            brown  #f)
                              (vector (gensym) 'green '~yellow)))
               (check-equal? (normalize-unknowns CLUES CATEGORIES)
                             '(#(bob green red)
                               #(tom brown #f)
                               #(fred #f yellow)))))