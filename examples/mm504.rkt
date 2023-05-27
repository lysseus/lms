#lang racket

;;;======================
;;; Murder Mystery L5 #04
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer height wife hair weight shoes)

(clue (suspect bill-smith))
(clue (suspect tom-davis))
(clue (suspect bob-jones))
(clue (suspect jack-alberts))
(clue (suspect marty-edison))

(clue (suspect tom-davis) (height 6.2))
(clue (suspect ?) (wife mary) (weight 190))
(clue (suspect ?) (wife judy) (hair ~white))
(clue (suspect ?) (murderer yes) (weight 170))
(clue (suspect marty-edison) (wife betty))
(clue (suspect ?) (height 5.3) (wife sue))
(clue (suspect ?) (wife mary) (height 5.9))
(clue (suspect ?) (weight 200) (height ~5.0))
(clue (suspect bill-smith) (shoes tan))
(clue (suspect ?) (height 5.3) (shoes ~tan))
(clue (suspect bob-jones) (weight 210))
(clue (suspect ?) (weight 150) (wife sue))
(clue (suspect jack-alberts) (hair brown))
(clue (suspect ?) (weight 210) (height 5.6))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect marty-edison) (murderer yes)))