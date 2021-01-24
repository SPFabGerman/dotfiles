(load-theme 'doom-gruvbox 't)
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
; (setq visible-bell t)
(set-face-attribute 'default nil :font "Fira Code Retina" :height 105)
(set-face-attribute 'fixed-pitch nil :inherit 'default)
(set-face-attribute 'variable-pitch nil :font "FreeSans" :height 105 :weight 'normal)
;; Set the line number explicitly, to avoid it being reset to variable-pitch by org mode
(set-face-attribute 'line-number nil :inherit 'fixed-pitch)
(set-face-attribute 'line-number-current-line nil :background 'unspecified :inherit '(hl-line line-number))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-:") 'eval-expression)

(show-paren-mode)

(global-hl-line-mode)

;; Better Scrolling
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-tilt-scroll 't)
(setq mouse-wheel-flip-direction 't)
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step 5)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode)

(dolist (mode '(term-mode-hook
		vterm-mode-hook
                eshell-mode-hook
                shell-mode-hook
		help-mode-hook
		helpful-mode-hook
		Info-mode-hook
		apropos-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Initialize Packages
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package all-the-icons)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 20)))
(use-package doom-themes)

(use-package which-key
  :init (which-key-mode))
;; (which-key-setup-side-window-right-bottom)
(global-set-key (kbd "<C-tab>") 'which-key-show-top-level)

; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;  '(term-color-black ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
;  '(term-color-blue ((t (:foreground "#7CB8BB" :background "#4C7073"))))
;  '(term-color-cyan ((t (:foreground "#93E0E3" :background "#8CD0D3"))))
;  '(term-color-green ((t (:foreground "#7F9F7F" :background "#9FC59F"))))
;  '(term-color-magenta ((t (:foreground "#DC8CC3" :background "#CC9393"))))
;  '(term-color-red ((t (:foreground "#AC7373" :background "#8C5353"))))
;  '(term-color-white ((t (:foreground "#DCDCCC" :background "#656555"))))
;  '(term-color-yellow ((t (:foreground "#DFAF8F" :background "#9FC59F"))))
;  '(term-default-bg-color ((t (:inherit term-color-black))))
;  '(term-default-fg-color ((t (:inherit term-color-white)))))

(require 'eshell) ; or use with-eval-after-load
(use-package xterm-color)
(setq comint-output-filter-functions
      (remove 'ansi-color-process-output comint-output-filter-functions))

(add-hook 'shell-mode-hook
          (lambda ()
            ;; Disable font-locking in this buffer to improve performance
            (font-lock-mode -1)
            ;; Prevent font-locking from being re-enabled in this buffer
            (make-local-variable 'font-lock-function)
            (setq font-lock-function (lambda (_) nil))
            (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

(use-package eterm-256color)
(add-hook 'term-mode-hook #'eterm-256color-mode)

(use-package vterm)

(add-hook 'term-mode-hook
      (defun my-term-mode-hook ()
	(setq bidi-paragraph-direction 'left-to-right)))

;; Also set TERM accordingly (xterm-256color) in the shell itself.

;; An example configuration for eshell


; (add-hook 'eshell-before-prompt-hook
;           (lambda ()
;             (setq xterm-color-preserve-properties t)))

; (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
; (setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
					; (setenv "TERM" "xterm-256color")

(with-eval-after-load 'esh-mode
  (add-hook 'eshell-mode-hook
          (lambda () (progn
            (setq xterm-color-preserve-properties t)
            (setenv "TERM" "xterm-256color"))))

  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)

  (setq eshell-output-filter-functions
  (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
)

(setq shell-file-name "/bin/bash")

; (require 'evil)
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("lightblue" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hbar))

; (setq evil-want-C-w-in-emacs-state 't)
(setq evil-want-Y-yank-to-eol 't)
(setq evil-split-window-below 't)
(setq evil-vsplit-window-right 't)
(setq evil-undo-system 'undo-redo)
(setq evil-echo-state nil)
(setq evil-want-keybinding nil)
(setq evil-want-integration 't)

(use-package evil)
(evil-mode 1)
;; (add-to-list 'evil-insert-state-modes 'vterm-mode)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-normal-state-map (kbd "#") 'comment-line)
(define-key evil-visual-state-map (kbd "#") 'comment-or-uncomment-region)
(define-key evil-normal-state-map (kbd "<M-right>") 'evil-window-right)
(define-key evil-normal-state-map (kbd "<M-left>") 'evil-window-left)
(define-key evil-normal-state-map (kbd "<M-up>") 'evil-window-up)
(define-key evil-normal-state-map (kbd "<M-down>") 'evil-window-down)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; (use-package helm
;;   :defer 2
;;   :bind
;;   ("M-x" . helm-M-x)
;;   ("C-x C-f" . helm-find-files)
;;   ("M-y" . helm-show-kill-ring)
;;   ("C-x b" . helm-mini)
;;   :config
;;   (require 'helm-config)
;;   (helm-mode 1)
;;   (setq helm-split-window-inside-p t
;;     helm-move-to-line-cycle-in-source t)
;;   (setq helm-autoresize-max-height 0)
;;   (setq helm-autoresize-min-height 20)
;;   (helm-autoresize-mode 1)
;;   (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;;   (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
;;   (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level)
;; )

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         :map ivy-switch-buffer-map
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (setq ivy-use-selectable-prompt 't)
  (setq ivy-wrap 't)
  ;; Ignore the the order of words
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  ;; Don't show . and .. directories
  (setq ivy-extra-directories '())
  :init
  (ivy-mode 1))

(use-package ivy-rich
  :config (setq ivy-rich-path-style 'abbrev)
  :init (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-switch-buffer)
	 ("C-x C-f" . counsel-find-file))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

; (add-to-list 'load-path "/path-to/emacs-tree-sitter/core")
; (add-to-list 'load-path "/path-to/emacs-tree-sitter/lisp")
; (add-to-list 'load-path "/path-to/emacs-tree-sitter/langs")

; (require 'tree-sitter)
; (require 'tree-sitter-hl)
; (require 'tree-sitter-langs)
; (require 'tree-sitter-debug)
; (require 'tree-sitter-query)

; (use-package tree-sitter)
; (use-package tree-sitter-langs)

;; (font-lock-add-keywords 'c-mode
;;                    '(("\\<\\([a-zA-Z_]*\\) *("  1 font-lock-function-name-face append)) 'append)

(add-hook 'c-mode-common-hook
	  (lambda ()
	    (font-lock-add-keywords nil
		'(("\\<\\([a-zA-Z_]*\\) *(" 1 font-lock-function-name-face)) 't)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(defun fab/org-mode-setup ()
  ;; (org-indent-mode)
  (variable-pitch-mode 1)
  (display-line-numbers-mode 0)
  (visual-line-mode 1))

(defun fab/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 2.0)
		  (org-level-2 . 1.5)
		  (org-level-3 . 1.25)
		  (org-level-4 . 1.15)
		  (org-level-5 . 1.05)
		  (org-level-6 . 1.0)
		  (org-level-7 . 1.0)
		  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "FreeSans" :weight 'regular :height (cdr face)))

  (set-face-attribute 'org-document-title nil :font "FreeSans" :weight 'bold :height 3.0)

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-block-begin-line nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-document-info-keyword nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch))

(use-package org
  :pin org ;; Use Org-Mode Archive
  :hook (org-mode . fab/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-hide-emphasis-markers 't)
  (setq org-pretty-entities 't)
  (fab/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "●" "○" "●" "○" "●" "○")))

(use-package org-emphtog
  :load-path "~/.config/emacs/org-emphtog"
  :after org
  :hook (org-mode . org-emphtog-mode))

(defun fab/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(defun fab/center-text-visual ()
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . fab/org-mode-visual-fill)
  :hook (Info-mode . fab/center-text-visual))


(use-package ligature
  :load-path "~/.config/emacs/ligature.el"
  :config
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/=" "/>" "//" "__" "~~" "://"))
  (global-ligature-mode 't)
  )


;; (use-package good-scroll
;;   :config
;;   (setq good-scroll-step 50)
;;   (setq good-scroll-duration 0.05)
;;   (setq good-scroll-render-rate 0.01)
;;   (good-scroll-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes 'nil)
 '(package-selected-packages
   '(good-scroll visual-fill-column org-bullets ligature evil-collection doom-themes helpful counsel ivy-rich rainbow-delimiters tree-sitter-langs tree-sitter vterm eterm-256color eterm-color xterm-color which-key evil doom-modeline use-package)))

; (custom-set-faces
;  ;; custom-set-faces was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
;  '(default ((t (:background "#282c34" :foreground "#eceff4"))))
;  '(font-lock-comment-face ((t (:foreground "#5c667a"))))
;  '(font-lock-function-name-face ((t (:foreground "#81a1c1"))))
;  '(font-lock-type-face ((t (:foreground "#8fbcbb"))))
;  '(font-lock-variable-name-face ((t (:foreground "#88c0d0")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-directory ((t (:inherit font-lock-negation-char-face)))))
