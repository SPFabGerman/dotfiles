;; This file is generated by Emacs.org. Make changes there.

;; Change Native-Comp cache
(when (native-comp-available-p)
  (push (convert-standard-filename (expand-file-name  "var/eln-cache/" user-emacs-directory)) native-comp-eln-load-path))

(setq package-user-dir (expand-file-name "var/elpa/" user-emacs-directory))