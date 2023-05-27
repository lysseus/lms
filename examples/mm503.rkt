#lang racket

;;;======================
;;; Murder Mystery L5 #03
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer height car shirt hair shoes)

(clue (suspect fred-morrison))
(clue (suspect david-graig))
(clue (suspect marty-brown))
(clue (suspect john-martin))
(clue (suspect jim-davis))

(clue (suspect david-graig) (shirt black))
(clue (suspect marty-brown) (height 6.2))
(clue (suspect ?) (hair black) (height ~5.6))
(clue (suspect ?) (car blue) (height 5.3))
(clue (suspect ?) (murderer yes) (hair grey))
(clue (suspect ?) (height 5.0) (car green))
(clue (suspect ?) (car blue) (hair white))
(clue (suspect jim-davis) (car red))
(clue (suspect ?) (height 5.3) (shoes red))
(clue (suspect fred-morrison) (shoes blue))
(clue (suspect ?) (car green) (hair blond))
(clue (suspect ?) (hair bald) (height 5.9))
(clue (suspect ?) (shirt orange) (car ~black))
(clue (suspect john-martin) (hair bald))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jim-davis) (murderer yes)))