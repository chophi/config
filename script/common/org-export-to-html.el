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
     "https://rawgithub.com/\\1/\\2?sanitize=true")
    ("^.*git-repo/GraphvizImages/.*/\\\(.*\\\)\\.\\\(svg\\|png\\|jpeg\\|jpg\\\)$" .
     copy-and-publish-image)))

(defconst image-source-repo "~/git-repo/GraphvizImages/images")
(defconst target-image-dir "~/nanoc-site/content/assets/images")

(defun sha1sum-of-file (file)
  (substring
   (shell-command-to-string
    (format "md5sum %s | cut -d ' ' -f 1" (expand-file-name file)))
   0 -1))

(defun copy-and-publish-image (regexp source)
  (let* ((index (string-match regexp source))
         (basename (match-string 1 source))
         (extension (match-string 2 source))
         (source-dir (expand-file-name image-source-repo))
         (target-dir (expand-file-name target-image-dir))
         (source-file (concat source-dir "/" basename "." extension))
         (target-file (concat target-dir "/" basename "." extension)))
    (when (not (file-exists-p source-file))
      (error "source file not exist"))
    (when (or (not (file-exists-p target-file))
              (not (equal (sha1sum-of-file source-file) (sha1sum-of-file target-file))))
      (make-directory target-dir t)
      (copy-file source-file target-file))
    (format "/assets/images/%s.%s" basename extension)))

(defun* org-html--svg-image-hosting (source attributes info)
  "Embedding svg file for github raw image"
  (message "call with source=[%s]" source)
  (dolist (m svg-host-url-mapping)
    (when (string-match (car m) source)
      (message "found a match[%s]" (car m))
      (let ((source-link (if (stringp (cdr m))
                             (replace-regexp-in-string (car m) (cdr m) source)
                           (funcall (cdr m ) (car m) source))))
        (return-from org-html--svg-image-hosting
          (org-html-close-tag
           "img"
           (org-html--make-attribute-string
            (org-combine-plists
             (list :src source-link
	               :alt (file-name-nondirectory source)
                   :class "img-thumbnail img-fluid"
                   :data-remote source-link
                   :data-toggle "lightbox"
                   :data-type "image")
             attributes))
           info))))))

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
