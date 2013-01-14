;;; ts.el -*- coding: utf-8 -*-
;;;   - mode for editing *.ts type system files

;; Put this file on your emacs load path and add the following lines to your .emacs file:
;; (setq auto-mode-alist
;;       (append  auto-mode-alist
;; 	       '(("\\.ts$" . ts-mode))
;; 	       ))
;; (autoload 'ts-mode "ts.el" "" t)

(define-derived-mode ts-mode fundamental-mode "TS-checker"
  "Major mode for editing TS type system files.

\\{ts-mode-map}"
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-column) 60)
  (set (make-local-variable 'comment-start-skip) "# *")
  (set (make-local-variable 'comint-input-autoexpand) nil)
  (set (make-local-variable 'transient-mark-mode) t)
  (setq font-lock-defaults '( ts-mode-font-lock-keywords ))
  (setq truncate-lines t)
  (setq case-fold-search nil)
  )

(defvar ts-keywords '( "lambda" "Pi" "Sigma" "∏" "λ" "Σ" "Pi" "lambda" "Ulevel" "Type"
		       "uexp" "texp" "oexp" "istype" "hastype" "uequal" "tequal" "oequal" "tuequal" "ouequal" 
		       "a_type" "obj_of_type" "type_equality" "object_equality"
		       "max" "Singleton" "Sigma" "pair" "CAR" "CDR" ))

(defvar ts-commands '( "Mode" "Simple" "Relative" "Pairs" "Clear" "Universes" "LF" "TS"
		       "Check" "Alpha" "End" "Clear" "Show" "Include" ))

(defvar ts-mode-font-lock-keywords 
  `(
    ("@\\[\\([[:alnum:]∏∐Σλ_']+\\)\\(;[[:alnum:]_',]+\\)?\\]" 
     (1 font-lock-constant-face))
    (,(concat "\\<\\(" (regexp-opt ts-commands) "\\)\\>") 
     . font-lock-keyword-face)
    ("\\(Variable\\) +\\([[:alnum:]_']+\\)"
     (1 font-lock-keyword-face) 
     (2 font-lock-function-name-face))
    ("\\(Definition\\|Lemma\\|Proposition\\|Corollary\\|Axiom\\|Theorem\\)[[:space:]]*\\(LF\\)?\\( [0-9]+\\(\\.[0-9]+\\)*\\)?[[:space:]]+\\([[:alnum:]∏∐Σλ_']+\\)"
     (1 font-lock-keyword-face) 
     (5 font-lock-function-name-face))
    (,(concat "\\<\\(" (regexp-opt ts-keywords) "\\)\\>") 
     . font-lock-type-face)
    ))

(mapcar
 (function
  (lambda (syntax-table)

    (modify-syntax-entry ?# "<" syntax-table) (modify-syntax-entry ?\n ">" syntax-table)

    (modify-syntax-entry ?\' "w" syntax-table)
    (modify-syntax-entry ?∏ "w" syntax-table)
    (modify-syntax-entry ?Σ "w" syntax-table)
    (modify-syntax-entry ?λ "w" syntax-table)
    (modify-syntax-entry ?_ "w" syntax-table)
    (modify-syntax-entry ?∐ "w" syntax-table)

    (modify-syntax-entry ?⟶ "_" syntax-table)

    (modify-syntax-entry ?⟾ "." syntax-table)
    (modify-syntax-entry ?⟼ "." syntax-table)

    ))
 (list ts-mode-syntax-table))

(defgroup TS nil "Editing TS type system files.")

(provide 'ts)

; Local Variables:
; compile-command: "make -C .. . "
; End:
