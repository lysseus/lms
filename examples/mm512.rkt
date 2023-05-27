#lang racket

;;;======================
;;; Murder Mystery L5 #12
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect umbrella height weight hair car murderer)

(clue (suspect bob-jones))
(clue (suspect bill-morrison))
(clue (suspect jack-alberts))
(clue (suspect brian-martin))
(clue (suspect john-stevenson))

(clue (suspect ?) (height 5.6) (hair white))
(clue (suspect ?) (umbrella yellow) (hair ~brown))
(clue (suspect ?) (height 5.0) (weight ~190))
(clue (suspect bill-morrison) (hair blond))
(clue (suspect bob-jones) (car black))
(clue (suspect ?) (umbrella green) (height 5.6))
(clue (suspect ?) (height 6.0) (umbrella red))
(clue (suspect john-stevenson) (umbrella black))
(clue (suspect ?) (hair red) (murderer yes))
(clue (suspect ?) (hair blond) (umbrella purple))
(clue (suspect ?) (umbrella green) (car purple))
(clue (suspect ?) (hair bald) (height 6.0))
(clue (suspect jack-alberts) (height 5.3))
(clue (suspect brian-martin) (weight 220))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jack-alberts) (murderer yes)))