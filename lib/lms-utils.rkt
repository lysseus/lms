#lang racket

(module+ test (require rackunit
                       (submod "..")))

(provide for/listf)
(define-syntax (for/listf stx)
  (syntax-case stx ()
    [(_ pred (for-clause ...) body-or-break ... body)
     #'(filter pred (for/list (for-clause ...) body-or-break ... body))]))

(module+ test
  (test-case "for/listf tests"
             (check-equal?
              (for/listf number? ((n (range 7)))
                (when (odd? n) n))
              '(1 3 5))))

(provide for/listf-not)
(define-syntax (for/listf-not stx)
  (syntax-case stx ()
    [(_ pred (for-clause ...) body-or-break ... body)
     #'(filter-not pred (for/list (for-clause ...) body-or-break ... body))]))

(module+ test
  (test-case "for/listf-not tests"
             (check-equal?
              (for/listf-not void? ((n (range 7)))
                (when (odd? n) n))
              '(1 3 5))))

(provide value->symbol)
(define (value->symbol val)
  (cond
    [(and (symbol? val) (eq? val '?)) (gensym)]
    [(string? val) (string->symbol val)]
    [(number? val) (value->symbol (number->string val))]
    [else val]))

(module+ test
  (test-case "value->symbol tests"
             (check-equal? (value->symbol 5.0) '|5.0|)
             (check-true (not (symbol-interned? (value->symbol '?))))))

(provide gensym?)
(define (gensym? sym)
  (and (symbol? sym) (not (symbol-interned? sym))))

(module+ test
  (test-case "gensym? tests"
             (check-true (gensym? (gensym)))
             (check-false (gensym? 'foo))))

(provide symbol-trim)
(define (symbol-trim sym (val '~))
  (define new-sym (value->symbol sym))
  (cond
    [(and (symbol? new-sym) (not (symbol-interned? new-sym))) new-sym]
    [else (string->symbol (string-trim (symbol->string (value->symbol new-sym))
                                       (symbol->string val)))]))

(module+ test
  (test-case "symbol-trim tests"
             (check-equal? (symbol-trim 'foo) 'foo)
             (check-equal? (symbol-trim '~foo) 'foo)
             (let ([g (gensym)])
               (check-equal? (symbol-trim g) g)
               (check-equal? (symbol-trim 5.0) '|5.0|))))

(provide ~symbol?)
(define (~symbol? sym) (and (symbol? sym) (not (eq? sym (symbol-trim sym)))))

(module+ test
  (test-case "~symbol? tests"
             (check-false (~symbol? 'foo))
             (check-false (~symbol? (gensym)))
             (check-false (~symbol? 5.0))
             (check-false (~symbol? "~5.0"))
             (check-true (~symbol? '~5.0))))

;; until: proc test val
;; Applies val to proc, which must return a val and a modified boolean
;; indicating that val was modified from the previous application, until
;; test of the modifed boolean is true. At that point processing
;; stops and the final val is returned.
(provide until)
(define (until proc test val)
  (define-values (new-val modified) (proc val))
  (cond
    [(test modified) new-val]
    [else (until proc test new-val)]))

(module+ test
  (test-case "until tests"
             (define lst '(a b c d))
             (define (f ls)
               (cond
                 [(empty? ls) (values #f #f)]
                 [(eq? (car ls) 'c) (values ls #f)]
                 [else (values (rest ls) #t)]))
             (check-equal? (until f false? lst) '(c d))))

;; while: proc test val
;; Applies val to proc, which must return a val and a modified boolean
;; indicating that val was modified from the previous application, while
;; test of the modifed boolean is true. At that point processing
;; stops and the final val is returned.
(provide while)
(define (while proc test val)
  (define-values (new-val modified) (proc val))
  (cond
    [(not (test modified)) new-val]
    [else (until proc test new-val)]))

(module+ test
  (test-case "while tests"
             (define lst '(a b c d))
             (define (f ls)
               (cond
                 [(empty? ls) (values #f #f)]
                 [(eq? (car ls) 'c) (values ls #f)]
                 [else (values (rest ls) #t)]))
             (check-equal? (while f (compose not false?) lst) '(c d))))

(provide vector-match)
(define (vector-match clue-f init-val slot-f clue1 clue2)
  (foldl clue-f init-val (vector->list (vector-map slot-f clue1 clue2))))

(provide unify)
(define (unify c1 c2)
  ;; Convert uninterned symbols to #f.
  ;; Otherwise return orignal value.
  (define (uninterned-symbol->false val)
    (cond
      [(and (symbol? val) (not (symbol-interned? val))) #f]
      [else val]))
  ;; Convert clue element according to followng:
  ;; #f #f => #f
  ;; #f val => val
  ;; val #f => val
  ;; gsym val => val
  ;; val gsym => val
  ;; gsym1 gsym2 => gsym2
  ;; val1  val2  => val1
  (define (unify-elm p1 p2)
    (or (uninterned-symbol->false p1) p2))
  ;; unify clues
  (vector-map unify-elm c1 c2))

(module+ test
  (test-case "unify tests"
             (check-equal? (unify #(tom-edison #f #f #f black white)
                                  #((gensym) green blue yellow #f #f))
                           #(tom-edison green blue yellow black white))))

(provide clues-split)
;; clues-split: idx clues => (values list? list? list?)
;; Splits clues into 3 lists of symbols, ~symbols, and '?/#f values.
(define (clues-split idx clues)
  (define (loop clues syms ~syms ?s)
    (cond
      [(empty? clues) (values syms ~syms ?s)]
      [else
       (define clue (car clues))
       (define val (vector-ref clue idx))
       (cond
         [(or (false? val)
              (eq? val '?)
              (and (symbol? val) (not (symbol-interned? val))))
          (loop (rest clues) syms ~syms (cons clue ?s))]
         [(eq? val (symbol-trim val))
          (loop (rest clues) (cons clue syms) ~syms ?s)]
         [else (loop (rest clues) syms (cons clue ~syms) ?s)])]))
  (loop clues empty empty empty))

(module+ test  
  (test-case "clues-split "
             (define g1 (gensym))
             (define g2 (gensym))
             (define CLUES1 (list
                             #(tom #f)
                              (vector g1 'blue)
                              #(bill #f)
                              (vector g2 'green)))
             (define CLUES2 '(#(A a) #(B b) #(C ~c) #(D ~d) #(E #f)))
             
             (define-values (s1 n1 ?1) (clues-split 0 CLUES1))
             (check-equal? s1 '(#(bill #f) #(tom #f)))
             (check-equal? n1 '())
             (check-equal? ?1 (list (vector g2 'green) (vector g1 'blue)))
             (define-values (s2 n2 ?2) (clues-split 1 CLUES2))
             (check-equal? s2 '(#(B b) #(A a)))
             (check-equal? n2 '(#(D ~d) #(C ~c)))
             (check-equal? ?2 '(#(E #f)))))