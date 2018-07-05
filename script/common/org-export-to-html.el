:;exec emacs.sh -l "$0" -f main "$@"
(require 'cl)
(toggle-debug-on-error)
(require 'org)

(defun locate-dir-in-dir (dir subdir-prefix)
  (let* ((absdir (expand-file-name dir))
         (maybe-exist-name (file-name-completion subdir-prefix absdir)))
    (if maybe-exist-name
        (concat absdir "/" maybe-exist-name)
      nil)))

(let ((maybe-dir (locate-dir-in-dir "~/.emacs.d/elpa/" "org-20")))
  (if maybe-dir
      (add-to-list 'load-path maybe-dir)
    (error "no org-mode lisp files found")))

(require 'ox)

(defun main ()
  (interactive)
  (destructuring-bind (file &optional (outputfile nil)) command-line-args-left
    (print file outputfile)
    (with-current-buffer (find-file-noselect file)
      (org-export-to-file 'html (concat (file-name-sans-extension file) ".html") nil nil nil t))))
