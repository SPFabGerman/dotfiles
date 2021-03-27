(defun list-faces (pos)
  "Get the font faces at POS."
  (interactive "d")
  (message "All Faces: %s" (remq nil
                                 (list
                                  (get-char-property pos 'read-face-name)
                                  (get-char-property pos 'face)
                                  (plist-get (text-properties-at pos) 'face)))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10) ;; Left and Right Border
(load-theme 'doom-gruvbox 't)
(setq inhibit-startup-message t)
;; (setq visible-bell t)

;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))

;; (set-fontset-font "fontset-default" nil "MesloLGS NF")
(set-face-attribute 'default nil :font "Fira Code Retina" :height 105)
(set-face-attribute 'fixed-pitch nil :inherit 'default)
(set-face-attribute 'variable-pitch nil :font "FreeSans" :height 105 :weight 'normal)

(show-paren-mode)

(global-hl-line-mode)

;; Set the line number explicitly, to avoid it being reset to variable-pitch by org mode
(set-face-attribute 'line-number nil :inherit 'fixed-pitch)
(set-face-attribute 'line-number-current-line nil :background 'unspecified :inherit '(hl-line line-number))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
;; (column-number-mode)

(dolist (mode '(term-mode-hook
                vterm-mode-hook
                eshell-mode-hook
                shell-mode-hook
                help-mode-hook
                helpful-mode-hook
                Info-mode-hook
                apropos-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-flip-direction 't)
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step 5)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :config
  (setq auto-package-update-interval 14)
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-prompt-before-update t)
  ;; (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

(global-auto-revert-mode)

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; (setq-default indent-tabs-mode nil)

(setq tab-always-indent nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-:") 'eval-expression)
(global-set-key (kbd "C-a") 'universal-argument)

(use-package which-key
  :init (which-key-mode))
;; (which-key-setup-side-window-right-bottom)
(global-set-key (kbd "<C-tab>") 'which-key-show-top-level)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("lightblue" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hbar))
(setq evil-motion-state-cursor '("orange" hbar))

;; (setq evil-want-C-w-in-emacs-state 't)
(setq evil-want-Y-yank-to-eol 't)
(setq evil-want-C-u-scroll 't)
(setq evil-respect-visual-line-mode 't)
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

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  ;; (delete 'info evil-collection-mode-list)
  (evil-collection-init))

(use-package general
  :config
  (general-evil-setup 't)
  (general-create-definer fab/leader-def
    :states '(normal visual)
    :prefix "SPC"))

(general-def 'normal
  "#"         'comment-line
  "<M-down>"  'evil-window-down
  "<M-left>"  'evil-window-left
  "<M-right>" 'evil-window-right
  "<M-up>"    'evil-window-up
  "C-w C-q"   'evil-quit
  "U"         'evil-redo
  "/"         'swiper)

(general-def 'normal
  "<return>"   '(lambda () (interactive) (evil-open-below 0) (evil-normal-state))
  "S-<return>" '(lambda () (interactive) (evil-open-above 0) (evil-normal-state)))

(general-def 'visual
  "#" 'comment-or-uncomment-region)

(fab/leader-def :infix "f"
  ""  '(:ignore t :wk "Files")
  "f" 'find-file
  "e" '((lambda () (interactive) (find-file "~/.config/emacs/Emacs.org"))   :wk "Emacs Init")
  "o" '((lambda () (interactive) (find-file "~/Notes/Org_Mode_Basics.org")) :wk "Org Notes"))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-g" . ivy-beginning-of-buffer)
         ("C-o" . ivy-occur)
         ;; TODO: Implement Ivy-resume
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

;; TODO: Open in same window
(use-package helpful
  :init
  (setq helpful-switch-buffer-function #'pop-to-buffer)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  (counsel-describe-symbol-function #'helpful-symbol)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-symbol] . counsel-describe-symbol)
  ([remap describe-key] . helpful-key))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 25)))
(use-package doom-themes)

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

(use-package yascroll
  :config
  (set-face-attribute 'yascroll:thumb-fringe nil :foreground "#3c3836" :background "#3c3836")
  (global-yascroll-bar-mode 1))

(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\([a-zA-Z_]*\\) *(" 1 font-lock-function-name-face)) 't)))

(defun fab/org-mode-setup ()
  (variable-pitch-mode 1)
  (display-line-numbers-mode 0)
  (org-latex-preview 16) ;; Preview all Latex segments
  (visual-line-mode 1))

(defun fab/org-font-setup ()
  ;; Replace list hyphen with dot
  ;; (font-lock-add-keywords 'org-mode
  ;;                         '(("^ *\\([-]\\) "
  ;;                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

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

  (require 'org-indent)
  (set-face-attribute 'org-document-title nil :font "FreeSans" :weight 'bold :height 3.0)

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-block-begin-line nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-code nil     :inherit 'fixed-pitch)
  (set-face-attribute 'org-document-info-keyword nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-hide   nil   :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-indent nil   :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-meta-line nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-keyword-face fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch)))
  (set-face-attribute 'org-verbatim nil :inherit 'fixed-pitch))

(use-package org
  :pin org ;; Use Org-Mode Archive
  :hook (org-mode . fab/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-hide-emphasis-markers 't)
  (setq org-pretty-entities 't)
  (setq org-cycle-global-at-bob 't)
  ;; (setq org-startup-folded 't)
  (setq org-catch-invisible-edits 'smart)
  (setq org-M-RET-may-split-line nil)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-list-indent-offset 1)
  (setq org-hide-leading-stars 't)
  (setq org-indent-indentation-per-level 2)
  (setq org-startup-indented 't)
  (setq org-edit-src-content-indentation 2)
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (fab/org-font-setup))

;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "◎" "●" "⊙" "○" "●" "◈" "◇")))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "◎" "●" "⊙" "○" "●" "◈" "◇"))
  ;; (org-superstar-remove-leading-stars 't)
  (org-superstar-item-bullet-alist '((?* . ?•) (?+ . ?•) (?- . ?•)))
  ;; :custom-face
  ;; (org-superstar-header-bullet ((t (:inherit 'fixed-pitch))))
  )

;; (use-package org-emphtog
;;   :load-path "~/.config/emacs/org-emphtog"
;;   :after org
;;   :hook (org-mode . org-emphtog-mode))

(use-package org-appear
  ;; :load-path "~/.config/emacs/org-appear"
  :after org
  :init
  (setq org-appear-autolinks 't
        org-appear-autosubmarkers 't)
  :hook (org-mode . org-appear-mode))

;; (use-package org-pretty-table
;;  :load-path "~/.config/emacs/org-pretty-table")

;; Automatically tangle our Emacs.org config file when we save it
(defun fab/org-auto-tangle ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'fab/org-auto-tangle)))


(defun fab/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(defun fab/center-text-visual ()
  (setq visual-fill-column-width 80)
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . fab/org-mode-visual-fill)
  :hook (Info-mode . fab/center-text-visual))

(general-def 'normal org-mode-map
  "<down>" 'evil-next-visual-line
  "<up>"   'evil-previous-visual-line)

(fab/leader-def org-mode-map :infix "o"
  ""    '(:ignore t :wk "Org-Mode")
  "g"   '((lambda () (interactive) (evil-emacs-state) (org-goto) (evil-normal-state)) :wk "Goto")
  "o"   '(org-occur :wk "Occur")
  "s"   '(:ignore t :wk "Src Blocks")
  "s s" '((lambda () (interactive) (beginning-of-line) (org-babel-demarcate-block)) :wk "Split or create")
  "t"   '(:ignore t :wk "Tables")
  "t t" '(org-table-create-or-convert-from-region :wk "Create")
  "t c" '(:ignore t :wk "Columns")
  "t c d" '(org-table-delete-column :wk "Delete")
  "t c i" '(org-table-insert-column :wk "Insert Left")
  "t s" '(org-table-sort-lines :wk "Sort by Column")
  ;; "t d" '(org-table-cut-region :wk "Delete")
  ;; "t y" '(org-table-copy-region :wk "Yank")
  ;; "t p" '(org-table-paste-rectangle :wk "Paste")
  "t i" '(org-table-import :wk "Import")
  "t e" '(org-table-export :wk "Export")
  "T"   '(org-todo :wk "Change TODO")
  "S"   '(org-sort :wk "Sort")
  )
