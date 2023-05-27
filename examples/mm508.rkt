#lang racket

;;;======================
;;; Murder Mystery L5 #08
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect car weight height hair wife murderer)

(clue (suspect fred-graig))
(clue (suspect david-smith))
(clue (suspect jim-morrison))
(clue (suspect brian-stevenson))
(clue (suspect bob-davis))

(clue (suspect ?) (height 5.0) (weight ~180))
(clue (suspect bob-davis) (height 5.9))
(clue (suspect jim-morrison) (car white))
(clue (suspect ?) (car green) (hair ~white))
(clue (suspect ?) (weight 200) (car yellow))
(clue (suspect ?) (hair black) (car purple))
(clue (suspect david-smith) (wife betty))
(clue (suspect fred-graig) (weight 220))
(clue (suspect ?) (car blue) (wife ~betty))
(clue (suspect ?) (car blue) (weight 190))
(clue (suspect ?) (hair bald) (weight 190))
(clue (suspect ?) (weight 200) (hair blond))
(clue (suspect brian-stevenson) (car purple))
(clue (suspect ?) (hair brown) (murderer yes))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect fred-graig) (murderer yes)))