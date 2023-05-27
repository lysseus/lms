#lang racket

;;;======================
;;; Murder Mystery L5 #15
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect weight car umbrella shirt height murderer)

(clue (suspect john-stevenson))
(clue (suspect larry-brown))
(clue (suspect brian-graig))
(clue (suspect tom-morrison))
(clue (suspect jack-smith))

(clue (suspect ?) (car orange) (weight 200))
(clue (suspect larry-brown) (weight 160))
(clue (suspect ?) (weight 220) (height 5.9))
(clue (suspect jack-smith) (car purple))
(clue (suspect ?) (car blue) (umbrella ~purple))
(clue (suspect tom-morrison) (weight 170))
(clue (suspect ?) (shirt white) (murderer yes))
(clue (suspect john-stevenson) (height 5.3))
(clue (suspect ?) (weight 220) (car white))
(clue (suspect ?) (car white) (shirt blue))
(clue (suspect brian-graig) (umbrella red))
(clue (suspect ?) (car orange) (shirt purple))
(clue (suspect ?) (weight 150) (shirt ~red))
(clue (suspect ?) (shirt black) (weight 160))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect jack-smith) (murderer yes)))