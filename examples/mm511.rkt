#lang racket

;;;======================
;;; Murder Mystery L5 #11
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect car shoes shirt umbrella weight murderer)

(clue (suspect tom-graig))
(clue (suspect larry-jones))
(clue (suspect jim-martin))
(clue (suspect marty-smith))
(clue (suspect john-edison))

(clue (suspect ?) (shoes orange) (umbrella white))
(clue (suspect ?) (car white) (shoes black))
(clue (suspect ?) (car white) (weight 200))
(clue (suspect ?) (shoes white) (shirt ~black)) 
(clue (suspect marty-smith) (shirt white))
(clue (suspect ?) (shoes black) (umbrella purple)) 
(clue (suspect ?) (umbrella green) (car black))
(clue (suspect ?) (car orange) (shoes orange))
(clue (suspect john-edison) (umbrella green))
(clue (suspect larry-jones) (weight 170))        
(clue (suspect ?) (umbrella black) (murderer yes))
(clue (suspect tom-graig) (car purple))
(clue (suspect jim-martin) (shoes brown)) 
(clue (suspect ?) (umbrella orange) (car ~green))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jim-martin) (murderer yes)))