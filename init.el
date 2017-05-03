;;(require 'mozc)
;;(set-language-environment "Japanese")
;;(setq default-input-method "japanese-mozc")
;;(prefer-coding-system 'utf-8)

(defadvice coq-mode-config
    (after deactivate-holes-mode () activate)
  (progn (holes-mode 0))
  )

(add-hook 'proof-mode-hook
	  '(lambda ()
	     (define-key proof-mode-map (kbd "C-c C-j") 'proof-goto-point)
	     )
	  )

;;(setq coq-load-path-include-current t)
(setq proof-splash-enable nil)
;;(setq proof-three-window-mode-policy 'hybrid)
;;(setq coq-compile-before-require t)

(setq coq-prog-args
        (cons "-R" (cons "/root/.opam/4.04.0/lib/coq/user-contrib/mathcomp" (cons "mathcomp" (cons "-emacs" nil)))))
