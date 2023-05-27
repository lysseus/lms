#lang racket

;;;======================
;;; Murder Mystery L4 #12
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer shirt height umbrella weight car)

(clue (suspect jim-martin))
(clue (suspect david-brown))
(clue (suspect marty-jones))
(clue (suspect bob-morrison))
(clue (suspect jack-davis))

(clue (suspect ?) (shirt black) (height 5.0))
(clue (suspect ?) (height 5.0) (weight 170))
(clue (suspect david-brown) (umbrella orange))
(clue (suspect jim-martin) (car red))
(clue (suspect ?) (weight 160) (height 6.2))
(clue (suspect ?) (shirt purple) (car ~red))
(clue (suspect jack-davis) (shirt white))
(clue (suspect bob-morrison) (height 6.0))
(clue (suspect ?) (umbrella green) (height ~5.3))
(clue (suspect ?) (shirt purple) (height 6.2))
(clue (suspect ?) (shirt green) (weight 150))
(clue (suspect ?) (shirt yellow) (weight ~200))
(clue (suspect ?) (murderer yes) (weight 200))
(clue (suspect marty-jones) (shirt green))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jack-davis) (murderer yes)))