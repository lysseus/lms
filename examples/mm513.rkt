#lang racket

;;;======================
;;; Murder Mystery L5 #13
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect wife hair shoes height shirt murderer)

(clue (suspect jack-brown))
(clue (suspect david-edison))
(clue (suspect brian-graig))
(clue (suspect marty-alberts))
(clue (suspect fred-smith))

(clue (suspect ?) (height 5.3) (wife joyce))
(clue (suspect ?) (wife judy) (shirt ~yellow))
(clue (suspect ?) (height 6.0) (murderer yes))
(clue (suspect ?) (wife sally) (height ~5.9))
(clue (suspect david-edison) (hair grey))
(clue (suspect marty-alberts) (height 5.3))
(clue (suspect jack-brown) (wife betty))
(clue (suspect ?) (hair black) (shoes ~brown))
(clue (suspect fred-smith) (shirt yellow))
(clue (suspect ?) (height 6.2) (hair bald))
(clue (suspect ?) (hair bald) (wife pam))
(clue (suspect ?) (hair brown) (height 5.6))
(clue (suspect ?) (hair brown) (wife judy))
(clue (suspect brian-graig) (shoes red))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect david-edison) (murderer yes)))