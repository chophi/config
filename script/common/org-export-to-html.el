:;exec emacs.sh -l "$0" -f main "$@"
(require 'cl)
(toggle-debug-on-error)

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

(require 'org)
(require 'ox)
(require 'ox-html)

(defconst svg-host-url-mapping
  '(("^https://github\\.com/\\\(.*\\\)/blob/\\\(.*\\.svg\\\)$"
     .
     "https://rawgithub.com/\\1/\\2?sanitize=true")))

(defun* org-html--svg-image-hosting (source attributes info)
  "Embedding svg file for github raw image"
  (dolist (m svg-host-url-mapping)
    (when (string-match (car m) source)
      (return-from org-html--svg-image-hosting
        (org-html-close-tag
         "img"
         (org-html--make-attribute-string
          (org-combine-plists
           (list :src (replace-regexp-in-string (car m) (cdr m) source)
	             :alt (file-name-nondirectory source))
           attributes))
         info)
        ))))
(advice-add #'org-html--svg-image :before-until
            #'org-html--svg-image-hosting)

(defun main ()
  (interactive)
  (destructuring-bind (file &optional output-file) command-line-args-left
    (with-current-buffer (find-file-noselect file)
      (org-export-to-file
          'html
          (or output-file
              (concat (file-name-sans-extension file) ".html"))
        nil nil nil t))))
