#lang racket

;;; Knowns:
;;; This process attempts to match the knowns, which are represented
;;; by one of the non-'? suspects, and checking the knowns category vals
;;; against the collected VALS for the CATEGORY.
;;;
;;; Here is a simple example:
;;;
;;;    VALS Cars: (blue white green red)
;;; 
;;;    Suspect   Car
;;;    -------   ----
;;;    bob       blue
;;;    tom       white
;;;    fred      #f
;;;    carl      ~red
;;;
;;; The process breaks the knowns into 3 lists: symbols, ~symbols, and ?s that
;;; in the example above would look like this:
;;; '(#(bob blue) #(tom white))
;;;   '(#(carl ~red))
;;;   '(#(fred #f))
;;;
;;; It then pairs the elements in each list with a val where it can:
;;;
;;; '((#(bob blue) blue) (#(tom white) white))
;;; '((#(carl ~red) green))
;;; '((#(fred #f) red))
;;;
;;; We can then assign the green car to carl, and the red car to fred.
;;;===============================================================================

(require "lms-utils.rkt"
         (only-in "init.rkt" current-categories current-cvals))

(module+ test (require rackunit
                       (submod "..")))

(define (match-slot slot vals)
  (define tmp-vals
    (cond
      [(~symbol? slot) (remove (symbol-trim slot) vals)]
      [(false? slot) vals]
      [else empty]))
  (if (empty? tmp-vals) #f (first tmp-vals)))

(define (loop idx knowns vals knowns-modified?)
  (cond
    [(empty? knowns) knowns-modified?]
    [else
     (define known (first knowns))
     (define known-val (vector-ref known idx))
     (define match-val (match-slot known-val vals))
     (when match-val (vector-set! known idx match-val))
     (loop idx
           (rest knowns)
           (remove (vector-ref known idx) vals)
           (or (not (false? match-val)) knowns-modified?))]))

#;(define (loop idx knowns vals knowns-modified?)
  (cond
    [(empty? knowns) knowns-modified?]
    [else
     (define known (first knowns))
     (define known-val (vector-ref known idx))
     (cond
       [(~symbol? known-val)
        (define tmp-vals (remove (symbol-trim known-val) vals))
        (define known-modified? (not (empty? tmp-vals)))
        (when known-modified? (vector-set! known idx (first tmp-vals)))
        (loop idx
              (rest knowns)
              (remove (vector-ref known idx) vals)
              (or known-modified? knowns-modified?))]
       [(false? known-val)
        (define known-modified? (not (empty? vals)))
        (when known-modified? (vector-set! known idx (first vals)))
        (loop idx
              (rest knowns)
              (remove (vector-ref known idx) vals)
              (or known-modified? knowns-modified?))]
       [else (loop idx
                   (rest knowns)
                   (remove (vector-ref known idx) vals)
                   knowns-modified?)])]))

(define (foo idx knowns cvals)
  (let/cc return
    ;; get the˘ vals for the category
    (define vals (vector-ref cvals idx))
    ;; if there's not enough vals to match with knowns we return
    (unless (= (length knowns) (length vals))
      (return #f))
    ;; if the known values at idx are not unique we return
    (unless (= (length knowns)
               (length (remove-duplicates (map (λ (c) (vector-ref c idx)) knowns))))
      (return #f))
    ;; split the knowns into groups
    (define-values (ss ns ?s) (clues-split idx knowns))
    ;; concatenate known groups in matching order
    (define sorted (append ss ns ?s))
    ;; if ns + ?s > 2 we return
    (when (> (length (append ns ?s)) 2) (return #f))
    ;; if there's more than 2 ns we return
    (when (> (length ns) 2) (return #f))
    ;; loop over the knows, matching and unifying
    (loop idx sorted vals #f)))

(module+ test
  (test-case "foo tests"
             (define CVALS1 '#((adam bill carl dave ern)
                               (a b c d e)))
             (define KNOWNS1
               (list #(adam a)
                     #(bill b)
                     (vector 'carl '~c)
                     (vector 'dave '~d)
                     #(erin e)))
             (check-true (foo 1 KNOWNS1 CVALS1))
             (define KNOWNS2
               (list #(adam a)
                     #(bill b)
                     (vector 'carl '~c)
                     (vector 'dave #f)
                     #(erin e)))
             (check-true (foo 1 KNOWNS2 CVALS1))
             (define KNOWNS3
               (list #(adam a)
                     #(bill b)
                     (vector 'carl '~c)
                     (vector 'dave #f)
                     (vector 'erin '~e)))
             (check-false (foo 1 KNOWNS3 CVALS1))))

(provide normalize-knowns)
(define (normalize-knowns clues
                          #:cvals (cvals (current-cvals))
                          #:categories (categories (current-categories)))
  (define new-clues (map vector-copy clues))
  (define-values (knowns n/a unknowns) (clues-split
                                        (vector-member 'suspect categories)
                                        new-clues))
  (for ([idx (range (vector-length categories))])
    (foo idx knowns cvals))
  new-clues)

(module+ test
  (test-case "normalize-knowns tests 1"
             (define CATS1 #(suspect car shoes shirt umbrella weight murderer))
             (define CVALS1 '#((john-edison marty-smith jim-martin larry-jones tom-graig)
                               (green purple orange black white)
                               (brown white black orange)
                               (white black)
                               (orange black green purple white)
                               (|170| |200|)
                               (yes)))
             (define KNOWNS1
               '(#(larry-jones orange orange #f    white  |170| #f)
                 #(tom-graig   purple #f     #f    #f     #f    #f)
                 #(jim-martin  #f     brown  #f    #f     #f    #f)
                 #(john-edison black  #f     #f    green  #f    #f)
                 #(marty-smith white  black  white purple |200| #f)))
             (define RES1
               '(#(larry-jones orange orange #f    white  |170| #f)
                 #(tom-graig   purple #f     #f    #f     #f    #f)
                 #(jim-martin  green  brown  #f    #f     #f    #f)
                 #(john-edison black  #f     #f    green  #f    #f)
                 #(marty-smith white  black  white purple |200| #f)))
             (check-equal? (normalize-knowns KNOWNS1
                                             #:cvals CVALS1
                                             #:categories CATS1)
                           RES1))
  (test-case "normalize-knowns tests 2"
             (define CATS1 #(suspect car shoes shirt umbrella weight murderer))
             (define CVALS1 '#((john-edison marty-smith jim-martin larry-jones tom-graig)
                               (green purple orange black white)
                               (brown white black orange red)
                               (white black)
                               (orange black green purple white)
                               (|170| |200| |180| |160| |220|)
                               (yes)))
             (define KNOWNS1
               '(#(larry-jones orange orange #f    white  |170| #f)
                 #(tom-graig   purple ~red   #f    #f     ~160  #f)
                 #(jim-martin  #f     brown  #f    #f     |180| #f)
                 #(john-edison black  ~white #f    green  #f    #f)
                 #(marty-smith white  black  white purple |200| #f)))
             (define RES1
               '(#(larry-jones orange orange #f    white  |170| #f)
                 #(tom-graig   purple white  #f    #f     |220|  #f)
                 #(jim-martin  green  brown  #f    #f     |180|    #f)
                 #(john-edison black  red    #f    green  |160| #f)
                 #(marty-smith white  black  white purple |200| #f)))
             (check-equal? (normalize-knowns KNOWNS1
                                             #:cvals CVALS1
                                             #:categories CATS1)
                           RES1)))












