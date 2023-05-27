#lang racket

;;;======================
;;; Murder Mystery L4 #11
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer umbrella height shirt car weight)

(clue (suspect marty-jones))
(clue (suspect jack-brown))
(clue (suspect fred-martin))
(clue (suspect brian-stevenson))
(clue (suspect jim-morrison))

(clue (suspect ?) (umbrella green) (height 5.0))
(clue (suspect ?) (murderer yes) (car blue))
(clue (suspect ?) (umbrella orange) (car ~blue))
(clue (suspect jim-morrison) (weight 210))
(clue (suspect ?) (car white) (height 5.3))
(clue (suspect fred-martin) (height 6.0))
(clue (suspect marty-jones) (umbrella yellow))
(clue (suspect ?) (height 5.3) (umbrella black))
(clue (suspect ?) (umbrella purple) (car silver))
(clue (suspect ?) (shirt yellow) (height ~6.2))
(clue (suspect jack-brown) (car silver))
(clue (suspect brian-stevenson) (shirt black))
(clue (suspect ?) (height 5.0) (car orange))
(clue (suspect ?) (umbrella green) (weight ~210))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect marty-jones) (murderer yes)))