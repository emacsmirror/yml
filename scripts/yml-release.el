;;; yml-release.el --- Update release versions for make release -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(let ((version (getenv "YML_RELEASE_VERSION"))
      updates)
  (dolist (spec '(("Cargo.toml" "^version = \"\\([^\"]+\\)\"")
                  ("Cargo.lock" "name = \"emacs-yml\"\nversion = \"\\([^\"]+\\)\"")
                  ("yml.el" "^;; Version: \\([^\n]+\\)")
                  ("yml-module-install.el" "^;; Version: \\([^\n]+\\)"
                   "(defconst yml--module-version \"\\([^\"]+\\)\"")))
    (with-temp-buffer
      (insert-file-contents (car spec))
      (dolist (pattern (cdr spec))
        (goto-char (point-min))
        (unless (re-search-forward pattern nil t)
          (error "Missing release version in %s" (car spec)))
        (replace-match version t t nil 1))
      (push (cons (car spec) (buffer-string)) updates)))
  (dolist (update updates)
    (write-region (cdr update) nil (car update) nil 'silent)))

;;; yml-release.el ends here
