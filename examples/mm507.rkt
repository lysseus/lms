#lang racket

;;;======================
;;; Murder Mystery L5 #07
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect shirt hair weight wife height murderer)

(clue (suspect bill-edison))
(clue (suspect brian-martin))
(clue (suspect david-smith))
(clue (suspect jim-brown))
(clue (suspect john-graig))

(clue (suspect ?) (hair bald) (wife sue))
(clue (suspect ?) (shirt yellow) (hair black))
(clue (suspect brian-martin) (weight 210))
(clue (suspect ?) (murderer yes) (wife cathy))
(clue (suspect ?) (wife betty) (hair black))
(clue (suspect ?) (wife pam) (shirt green))
(clue (suspect john-graig) (hair brown))
(clue (suspect ?) (hair red) (weight ~170))
(clue (suspect bill-edison) (height 5.3))
(clue (suspect ?) (shirt blue) (wife ~mary))
(clue (suspect david-smith) (shirt white))
(clue (suspect jim-brown) (shirt green))
(clue (suspect ?) (shirt black) (hair bald))
(clue (suspect ?) (shirt yellow) (height ~5.3))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect john-graig) (murderer yes)))