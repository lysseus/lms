#lang racket

;;;======================
;;; Murder Mystery L5 #01
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer car weight hair shoes shirt)

(clue (suspect david-stevenson))
(clue (suspect john-davis))
(clue (suspect tom-graig))
(clue (suspect brian-brown))
(clue (suspect bill-edison))

(clue (suspect tom-graig) (hair bald))
(clue (suspect ?) (murderer yes) (shoes black))
(clue (suspect ?) (shoes orange) (car ~black))
(clue (suspect ?) (car purple) (weight 140))
(clue (suspect ?) (hair red) (weight ~160))
(clue (suspect ?) (shoes white) (weight 140))
(clue (suspect david-stevenson) (car red))
(clue (suspect ?) (car silver) (shoes brown))
(clue (suspect ?) (weight 150) (car yellow))
(clue (suspect john-davis) (shirt blue))
(clue (suspect bill-edison) (shoes brown))
(clue (suspect ?) (weight 150) (shoes red))
(clue (suspect brian-brown) (weight 200))
(clue (suspect ?) (car purple) (shirt ~blue))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect brian-brown) (murderer yes)))