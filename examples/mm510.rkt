#lang racket

;;;======================
;;; Murder Mystery L5 #10
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect wife weight shoes umbrella hair murderer)

(clue (suspect david-morrison))
(clue (suspect larry-edison))
(clue (suspect brian-graig))
(clue (suspect john-martin))
(clue (suspect bill-stevenson))

(clue (suspect ?) (weight 170) (umbrella orange))
(clue (suspect david-morrison) (wife sally))
(clue (suspect larry-edison) (weight 180))
(clue (suspect bill-stevenson) (shoes brown))
(clue (suspect ?) (umbrella red) (wife ~joyce))
(clue (suspect brian-graig) (wife cathy))
(clue (suspect ?) (weight 170) (wife mary))
(clue (suspect ?) (weight 160) (shoes ~blue))
(clue (suspect ?) (wife jill) (weight 140))
(clue (suspect ?) (umbrella black) (murderer yes))
(clue (suspect john-martin) (hair red))
(clue (suspect ?) (weight 140) (umbrella yellow))
(clue (suspect ?) (wife mary) (hair ~red))
(clue (suspect ?) (wife sally) (umbrella purple))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect larry-edison) (murderer yes)))

















