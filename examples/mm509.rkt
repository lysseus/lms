#lang racket

;;;======================
;;; Murder Mystery L5 #09
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect umbrella shirt height car wife murderer)

(clue (suspect jack-stevenson))
(clue (suspect marty-edison))
(clue (suspect tom-alberts))
(clue (suspect fred-smith))
(clue (suspect jim-morrison))

(clue (suspect tom-alberts) (umbrella white))
(clue (suspect marty-edison) (shirt blue))
(clue (suspect ?) (car orange) (umbrella red))
(clue (suspect fred-smith) (height 5.3))
(clue (suspect ?) (shirt black) (umbrella purple))
(clue (suspect ?) (shirt yellow) (umbrella yellow))
(clue (suspect ?) (umbrella yellow) (wife ~betty))
(clue (suspect jack-stevenson) (umbrella red))
(clue (suspect ?) (car silver) (shirt yellow))
(clue (suspect ?) (umbrella orange) (car ~black))
(clue (suspect ?) (car blue) (shirt black))
(clue (suspect ?) (car red) (murderer yes))
(clue (suspect ?) (shirt red) (height ~6.0))
(clue (suspect jim-morrison) (wife betty))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect marty-edison) (murderer yes)))