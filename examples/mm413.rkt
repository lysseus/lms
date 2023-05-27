#lang racket

;;;======================
;;; Murder Mystery L4 #13
;;;======================

(require "../lib/lms.rkt"
         rackunit)

(categories suspect murderer shoes hair umbrella car weight)

(clue (suspect fred-fox))
(clue (suspect brian-davis))
(clue (suspect jim-martin))
(clue (suspect john-stevenson))
(clue (suspect marty-graig))

(clue (suspect ?) (shoes white) (hair blond))
(clue (suspect john-stevenson) (shoes red))
(clue (suspect brian-davis) (hair red))
(clue (suspect ?) (hair black) (car black))
(clue (suspect ?) (car silver) (hair blond))
(clue (suspect ?) (car blue) (shoes blue))
(clue (suspect fred-fox) (shoes blue))
(clue (suspect ?) (umbrella orange) (hair ~bald))
(clue (suspect ?) (shoes brown) (car ~orange))
(clue (suspect ?) (shoes white) (weight 170))
(clue (suspect jim-martin) (weight 220))
(clue (suspect marty-graig) (umbrella purple))
(clue (suspect ?) (shoes tan) (hair black))
(clue (suspect ?) (murderer yes) (car orange))

(check-equal? (ans (suspect ?) (murderer yes))
              '((suspect john-stevenson) (murderer yes)))