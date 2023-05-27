#lang racket

;;;======================
;;; Murder Mystery L5 #05
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer car shirt height umbrella wife)

(clue (suspect fred-smith))
(clue (suspect jim-graig))
(clue (suspect larry-jones))
(clue (suspect david-edison))
(clue (suspect bill-alberts))

(clue (suspect ?) (car purple) (wife cathy))
(clue (suspect ?) (car black) (shirt purple))
(clue (suspect ?) (car orange) (umbrella purple))
(clue (suspect bill-alberts) (car yellow))
(clue (suspect larry-jones) (height 5.0))
(clue (suspect ?) (murderer yes) (umbrella white))
(clue (suspect ?) (umbrella yellow) (car ~blue))
(clue (suspect fred-smith) (shirt orange))
(clue (suspect jim-graig) (wife judy))
(clue (suspect ?) (shirt purple) (umbrella orange))
(clue (suspect ?) (umbrella red) (shirt blue))
(clue (suspect ?) (height 6.0) (shirt ~green))
(clue (suspect ?) (car purple) (shirt blue))
(clue (suspect david-edison) (umbrella purple))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect fred-smith) (murderer yes)))