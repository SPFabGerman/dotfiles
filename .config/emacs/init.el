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
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina")
(set-face-attribute 'variable-pitch nil :font "FreeSans" :height 105 :weight 'normal)

(show-paren-mode)

(global-hl-line-mode)

;; Set the line number explicitly, to avoid it being reset to variable-pitch by org mode
(set-face-attribute 'line-number nil :inherit 'fixed-pitch)
(set-face-attribute 'line-number-current-line nil :background 'unspecified :inherit '(hl-line line-number))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
;; We don't need the line number in the modeline anymore
(line-number-mode -1)
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

(dolist (mode '(term-mode-hook
                vterm-mode-hook
                eshell-mode-hook
                shell-mode-hook))
  (add-hook mode (lambda () (setq-local global-hl-line-mode nil))))

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

(electric-pair-mode)

(recentf-mode 1)
(setq recentf-max-saved-items 100)
(setq recentf-max-menu-items recentf-max-saved-items)
;; (recentf-cleanup) ;; TODO: Make Async or when loaded
;; (load "~/.config/emacs/recentf-minibuffer") ;; TODO: Change to require

;; (setq-default tab-width 2)
;; (setq-default evil-shift-width tab-width)

;; Don't use Tabs
;; (setq-default indent-tabs-mode nil)

(setq tab-always-indent nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-:") 'eval-expression)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("lightblue" bar))
(setq evil-replace-state-cursor '("red" hollow))
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

;; Start with forward searches by default (important for Swiper)
(setq isearch-forward 't)
;; (setq evil-search-module 'evil-search)

(use-package evil)
(evil-mode 1)
;; (add-to-list 'evil-insert-state-modes 'vterm-mode)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

(use-package evil-surround
  :after evil
  :config
  (general-def '(normal visual) evil-surround-mode-map
    "s" 'evil-surround-region
    "S" 'evil-Surround-region)
  ;; TODO: Text objects for other common surround stuff
  (global-evil-surround-mode 1))

(use-package evil-collection
  :after evil
  :config
  ;; (delete 'info evil-collection-mode-list)
  (evil-collection-init))

(use-package which-key
  :init
  (setq which-key-idle-delay 0.1) ;; Can cause errors when 0
  (setq which-key-prefix-prefix "")
  ;; (setq which-key-allow-evil-operators 't)
  ;; (setq which-key-show-operator-state-maps 't)
  (which-key-mode))
;; (which-key-setup-side-window-right-bottom)
(global-set-key (kbd "<C-tab>") 'which-key-show-top-level)

(use-package general
  :config
  (general-evil-setup 't)
  (general-create-definer fab/leader-def
    :states '(normal visual)
    :prefix "SPC"))

(general-def 'normal
  ;; "#"         'comment-line
  "<M-down>"  'evil-window-down
  "<M-left>"  'evil-window-left
  "<M-right>" 'evil-window-right
  "<M-up>"    'evil-window-up
  "C-w C-q"   'evil-quit
  "U"         'evil-redo
  ;; "/"         'swiper)
)

(general-def 'normal
  [remap evil-ret] '(lambda () (interactive) (evil-open-below 0) (evil-normal-state)) 
  "S-<return>" '(lambda () (interactive) (evil-open-above 0) (evil-normal-state)))

(general-def 'insert
  ;; Terminal style paste
  "C-S-V" '(lambda () (interactive) (evil-paste-before 1) (right-char)))

(general-def '(normal insert emacs visual) 'override
  "C-SPC" 'execute-extended-command
  "C-a" 'universal-argument)

(general-def universal-argument-map
  "C-a" 'universal-argument-more)



(fab/leader-def :infix "f"
  ""  '(:ignore t :wk "Files")
  "f" 'find-file
  "r" '(counsel-recentf :wk "Recent Files")
  "e" '((lambda () (interactive) (find-file "~/.config/emacs/Emacs.org"))   :wk "Emacs Init")
  "o" '((lambda () (interactive) (find-file "~/Notes/Org_Mode_Basics.org")) :wk "Org Notes"))

(use-package evil-nerd-commenter
  :general ('(normal visual) "#" 'evilnc-comment-or-uncomment-lines))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-g" . ivy-beginning-of-buffer)
         ("C-o" . ivy-occur)
         ("C-a" . ivy-dispatching-done)
         ("C-S-a" . ivy-dispatching-call)
         ("C-r" . ivy-restrict-to-matches)
         ("C-p" . yank)
         :map ivy-switch-buffer-map
         ("C-d" . ivy-switch-buffer-kill))
  :config
  (setq ivy-use-selectable-prompt 't)
  (setq ivy-wrap 't)
  ;; Ignore the the order of words
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  ;; Don't show . and .. directories
  (setq ivy-extra-directories '())
  (fab/leader-def ivy-mode-map
    "I" '(ivy-resume :wk "Ivy Resume"))
  (ivy-mode 1))

(use-package ivy-rich
  :config (setq ivy-rich-path-style 'abbrev)
  :init (ivy-rich-mode 1))

(use-package counsel
  :after ivy
  ;; :bind (("M-x" . counsel-M-x)
  ;;        ("C-SPC" . counsel-M-x)
  ;;        ("C-x b" . counsel-switch-buffer)
  ;;        ("C-x C-f" . counsel-find-file))
  :config
  (setq ivy-initial-inputs-alist nil)
  (fab/leader-def ivy-mode-map
    "b" '(counsel-switch-buffer :wk "Buffers")
    "P" '(counsel-yank-pop :wk "Paste Kill Ring"))
  (counsel-mode 1))

(use-package ivy-prescient
  :after counsel
  :init
  (setq prescient-sort-length-enable nil)
  (setq prescient-sort-full-matches-first 't)
  ;; Use normal ivy filtering
  (setq ivy-prescient-enable-filtering nil)
  ;; (setq ivy-prescient-retain-classic-highlighting t)
  :config
  (ivy-prescient-mode 1)
  (prescient-persist-mode 1))

(ivy-set-actions 't nil)

(ivy-add-actions
 'counsel-switch-buffer
 '(("s" (lambda (BNAME) (interactive) (evil-window-split) (switch-to-buffer BNAME)) "Split")
   ("v" (lambda (BNAME) (interactive) (evil-window-vsplit) (switch-to-buffer BNAME)) "VSplit")))

(ivy-add-actions
 'counsel-find-file
 '(("s" (lambda (FNAME) (interactive) (evil-window-split nil FNAME)) "Split")
   ("v" (lambda (FNAME) (interactive) (evil-window-vsplit nil FNAME)) "VSplit")))

;; TODO: Open in same window
(use-package helpful
  :init
  (setq helpful-switch-buffer-function #'pop-to-buffer)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  (counsel-describe-symbol-function #'helpful-symbol)
  :bind
  ;; ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command) ;; TODO: Needed for what?
  ;; ([remap describe-variable] . counsel-describe-variable)
  ;; ([remap describe-symbol] . counsel-describe-symbol)
  ([remap describe-key] . helpful-key)
  ("C-h p" . helpful-at-point))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons)
(use-package doom-modeline
  :init
  (setq mode-line-percent-position nil)
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-indent-info 't)
  (doom-modeline-lsp nil)
  (doom-modeline-env-version nil))
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

(defun fab/center-text-visual (&optional width)
  (setq visual-fill-column-width (or width 80))
  (setq visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook ((org-mode     . (lambda () (fab/center-text-visual 90)))
         (helpful-mode . (lambda () (fab/center-text-visual 90)))
         (Info-mode    . (lambda () (fab/center-text-visual 100)))))

(defun fab/company-on-return ()
  "Complete Selection when a value is selected, otherwise insert a newline"
  (interactive)
  (if company-selection
      (company-complete-selection)
    (newline)))

(use-package company
  :hook ((prog-mode lsp-mode) . company-mode)
  :config
  (general-def  company-mode-map
   "<tab>"     'company-indent-or-complete-common)
  (general-def  company-active-map
    ;; "<tab>"    'company-complete-selection
    "<tab>"    'company-complete
    "<return>" 'fab/company-on-return
    "<escape>" 'company-abort
    "<down>"   'company-select-next
    "<up>"     'company-select-previous)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1))

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

(setq posframe-mouse-banish nil)

(use-package flycheck
  :after lsp-mode) ;; TODO: Configure

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . lsp-headerline-breadcrumb-mode)
  :init
  (setq lsp-keymap-prefix "C-l")
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  ;; (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-modeline-diagnostics-enable nil)
  :config
  (lsp-enable-which-key-integration t)
  (fab/leader-def lsp-mode-map "l" (general-simulate-key "C-l" :which-key "LSP"))
  (general-def 'normal lsp-mode-map
    "C-<return>" 'lsp-find-definition))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-sideline-delay 0)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-diagnostics 't)
  (lsp-ui-sideline-update-mode 't)

  (lsp-ui-doc-enable nil) ;; TODO: Better Binding for Glance and Focus and customize frame
  (lsp-ui-doc-position 'at-point))

(use-package lsp-ivy
  :after lsp-mode)

(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\([a-zA-Z_]*\\) *(" 1 font-lock-function-name-face)) 't)))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

(defun fab/org-mode-setup ()
  (setq tab-width 2)
  (variable-pitch-mode 1)
  (display-line-numbers-mode 0)
  (visual-line-mode 1)
  (electric-pair-local-mode -1))

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
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-latex-and-related nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-hide   nil   :inherit 'fixed-pitch)
  ;; (set-face-attribute 'org-indent nil   :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-meta-line nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-document-info-keyword nil :inherit '(shadow fixed-pitch))
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
  (setq org-startup-with-latex-preview 't)
  (setq org-cycle-global-at-bob 't)
  ;; (setq org-startup-folded 't)
  (setq org-catch-invisible-edits 'smart)
  (setq org-M-RET-may-split-line nil)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-highlight-latex-and-related '(latex))
  (setq org-list-indent-offset 1)
  (setq org-hide-leading-stars 't)
  (setq org-indent-indentation-per-level 2)
  (setq org-startup-indented 't)
  (setq org-edit-src-content-indentation 2)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.25))
  (setq org-preview-latex-image-directory (expand-file-name "ltximg/" user-emacs-directory))
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
  (org-superstar-item-bullet-alist '((?* . ?◆) (?+ . ?○) (?- . ?●)))
  :config
  (set-face-attribute 'org-superstar-item nil :height 0.5) 
  ;; :custom-face
  ;; (org-superstar-header-bullet ((t (:inherit 'fixed-pitch))))
  ;; (org-superstar-item ((t (:inherit 'fixed-pitch))))
  )

(use-package org-appear
  :load-path "~/.config/emacs/org-appear"
  :after org
  :init
  (setq org-appear-autolinks 't
        org-appear-autoentities 't
        org-appear-autosubmarkers 't
        org-appear-clearlatex 't)
  :hook (org-mode . org-appear-mode))


(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(use-package org-pretty-table
  :load-path "~/.config/emacs/org-pretty-table"
  :hook (org-mode . org-pretty-table-mode))

;; Automatically tangle our Emacs.org config file when we save it
(defun fab/org-auto-tangle ()
  (when (and (eq major-mode 'org-mode)
             (string-equal (file-name-directory (buffer-file-name))
                           (expand-file-name user-emacs-directory)))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'fab/org-auto-tangle)))

(general-def 'normal org-mode-map
  "<down>" 'evil-next-visual-line
  "<up>"   'evil-previous-visual-line
  "C-e"    '(lambda () (interactive) (org-edit-special) (evil-normal-state)))

(general-def 'insert org-mode-map
  "C-e"    '(lambda () (interactive) (org-edit-special) (evil-insert-state)))

(general-def '(normal insert) org-src-mode-map
  ;; TODO: Does not work imediatly?
  "C-e" 'org-edit-src-exit)

(fab/leader-def org-mode-map :infix "o"
  ""    '(:ignore t :wk "Org-Mode")
  "g"   '(counsel-org-goto :wk "Goto Counsel")
  "G"   '((lambda () (interactive) (evil-emacs-state) (org-goto) (evil-normal-state)) :wk "Goto")
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

  "m"   '(:ignore t :wk "Modes")
  "m a" '(org-appear-mode :wk "Appear")
  "m f" '(org-fragtog-mode :wk "Fragtog")
  "m F" '((lambda () (interactive) (org-fragtog-mode -1) (org-fragtog-mode 1)) :wk "Fragtog Restart")
  "m e" '(org-toggle-pretty-entities :wk "Entities")
  "m i" '(org-toggle-inline-images :wk "Images")

  "i"   '(:ignore t :wk "Insert")
  "i e" '(counsel-org-entity :wk "Entity")
  "i l" '(org-insert-link :wk "Link")
  "i L" '(counsel-org-link :wk "Link (Headline)")
  "i t" '(org-table-create :wk "Table")
  "i s" '((lambda () (interactive) (beginning-of-line) (org-babel-demarcate-block)) :wk "Source Block")

  "l"   '(org-latex-preview :wk "Latex Preview")

  "T"   '(org-todo :wk "Change TODO")
  "S"   '(org-sort :wk "Sort")
  )

(defun org-folded-p ()
  "Returns non-nil if point is on a folded headline or plain list item."
  (and (or (org-at-heading-p) (org-at-item-p))
       (invisible-p (point-at-eol))))

(defun fab/org-evil-list-open-item-above (insert)
  (interactive "P")
  (if insert
      (evil-open-above 1)
    (org-evil-list-open-item-above)))

(defun fab/org-evil-list-open-item-below (insert)
  (interactive "P")
  (if insert
      (evil-open-below 1)
    (org-evil-list-open-item-below)))

(defun fab/org-evil-list-insert-item (insert)
  (interactive "P")
  (if insert
      (org-return)
    (org-insert-item (org-at-item-checkbox-p))))

(defun fab/org-evil-heading-open-sibling-below (insert)
  (interactive "P")
  (if (or insert (org-folded-p))
      (org-evil-heading-open-sibling-below)
    (evil-open-below 1)))

(defun fab/org-evil-heading-open-sibling-above (insert)
  (interactive "P")
  (if (or insert (org-folded-p))
      (org-evil-heading-open-sibling-above)
    (evil-open-above 1)))

(evil-define-motion fab/org-evil-heading-beginning-of-line ()
  "Move to the beginning of the current heading."
  :type exclusive
  (org-back-to-heading)
  (re-search-forward "\*+ "))

(use-package org-evil
  :after org
  :load-path "~/.config/emacs/org-evil"
  :config
  (org-evil--define-key 'normal 'org-evil-list-mode
    "O" 'fab/org-evil-list-open-item-above
    "o" 'fab/org-evil-list-open-item-below)
  (org-evil--define-key 'insert 'org-evil-list-mode
    (kbd "RET") 'fab/org-evil-list-insert-item)
  (org-evil--define-key 'normal 'org-evil-heading-mode
    "O" 'fab/org-evil-heading-open-sibling-above
    "o" 'fab/org-evil-heading-open-sibling-below
    "^" 'fab/org-evil-heading-beginning-of-line))

(defun fab/org-prettify-symbols-setup ()
  (setq prettify-symbols-unprettify-at-point 't)
  (push '("[ ]" . ?) prettify-symbols-alist)
  (push '("[X]" . ?) prettify-symbols-alist)
  (prettify-symbols-mode))

(add-hook 'org-mode-hook 'fab/org-prettify-symbols-setup)
