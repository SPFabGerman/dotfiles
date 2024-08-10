(require 'package)

(setq debug-on-error t
      no-byte-compile t
      byte-compile-warnings nil
      inhibit-startup-screen t
      package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/"))
      package-user-dir (make-temp-file "min-init")
      custom-file (expand-file-name "custom.el" package-user-dir))

(delete-file package-user-dir)
(add-hook 'kill-emacs-hook `(lambda ()
                              (delete-directory ,package-user-dir t)))

(let* ((pkg-list '(evil doom-modeline)))

  (package-initialize)
  (package-refresh-contents)

  (mapc (lambda (pkg)
          (unless (package-installed-p pkg)
            (package-install pkg))
          (require pkg))
        pkg-list))

(doom-modeline-mode)
(evil-mode)
(line-number-mode -1)

(run-with-timer 0.1 0.1 (lambda () (when (region-active-p) (message "%s" (region-end)))))

