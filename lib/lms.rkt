#lang racket

;;;====================================================================
;;; lms: logical mystery solver.
;;;      This is the library that should be required by all game files.
;;;====================================================================

(provide categories clue ans current-clues current-cvals)

(require "init.rkt"
         "norms.rkt")