#lang racket

;;;======================
;;; Murder Mystery L5 #14
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect car umbrella height hair wife murderer)

(clue (suspect tom-edison))
(clue (suspect david-brown))
(clue (suspect brian-davis))
(clue (suspect marty-alberts))
(clue (suspect jack-smith))

(clue (suspect brian-davis) (wife cathy))
(clue (suspect ?) (height 5.3) (umbrella white))
(clue (suspect ?) (car purple) (wife betty))
(clue (suspect jack-smith) (car yellow))
(clue (suspect tom-edison) (height 5.0))
(clue (suspect ?) (hair red) (umbrella orange))
(clue (suspect ?) (umbrella orange) (car silver))
(clue (suspect david-brown) (umbrella green))
(clue (suspect ?) (hair white) (car orange))
(clue (suspect ?) (car purple) (umbrella yellow))
(clue (suspect ?) (umbrella yellow) (hair grey))
(clue (suspect ?) (car black) (hair ~black))
(clue (suspect marty-alberts) (hair white))
(clue (suspect ?) (hair brown) (murderer yes))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect david-brown) (murderer yes)))