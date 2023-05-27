#lang racket

;;;======================
;;; Murder Mystery L5 #02
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer height shirt shoes weight hair)

(clue (suspect larry-morrison))
(clue (suspect john-graig))
(clue (suspect david-martin))
(clue (suspect jim-fox))
(clue (suspect bill-edison))

(clue (suspect bill-edison) (shirt black))
(clue (suspect ?) (weight 160) (shirt yellow))
(clue (suspect jim-fox) (height 5.9))
(clue (suspect ?) (weight 190) (height ~5.6))
(clue (suspect ?) (shirt yellow) (height 5.0))
(clue (suspect john-graig) (hair blond))
(clue (suspect ?) (murderer yes) (weight 180))
(clue (suspect larry-morrison) (shoes red))
(clue (suspect david-martin) (height 6.2))
(clue (suspect ?) (height 5.0) (hair grey))
(clue (suspect ?) (shirt red) (height 6.0))
(clue (suspect ?) (shirt red) (weight 220))
(clue (suspect ?) (weight 210) (height 6.2))
(clue (suspect ?) (shoes orange) (shirt ~blue))


(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect bill-edison) (murderer yes)))