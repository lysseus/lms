#lang racket

;;;======================
;;; Murder Mystery L5 #06
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer shirt umbrella hair car shoes)

(clue (suspect larry-stevenson))
(clue (suspect marty-smith))
(clue (suspect jack-davis))
(clue (suspect fred-edison))
(clue (suspect bill-brown))

(clue (suspect ?) (umbrella orange) (hair blond))
(clue (suspect ?) (shirt orange) (car ~orange))
(clue (suspect fred-edison) (shirt green))
(clue (suspect ?) (shirt blue) (umbrella purple))
(clue (suspect marty-smith) (shirt purple))
(clue (suspect larry-stevenson) (shoes black))
(clue (suspect ?) (shirt green) (car purple))
(clue (suspect ?) (umbrella white) (car white))
(clue (suspect bill-brown) (hair white))
(clue (suspect ?) (umbrella white) (shirt white))
(clue (suspect ?) (murderer yes) (car red))
(clue (suspect jack-davis) (umbrella yellow))
(clue (suspect ?) (shirt blue) (shoes ~black))
(clue (suspect ?) (umbrella purple) (car yellow))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jack-davis) (murderer yes)))