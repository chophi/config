:;exec emacs.sh -l "$0" -f main "$@"
(require 'cl)
(toggle-debug-on-error)

(defun add-to-load-path-maybe (dir subdir-prefix)
  (let* ((absdir (expand-file-name dir))
         (maybe-exist-name (file-name-completion subdir-prefix absdir)))
    (when maybe-exist-name
      (add-to-list 'load-path (concat absdir "/" maybe-exist-name)))))

(add-to-load-path-maybe "~/.emacs.d/elpa/" "org-20")
(add-to-load-path-maybe "~/.emacs.d/elpa/" "htmlize-")

(require 'org)
(require 'ox)
(require 'ox-html)

(defconst image-source-matching-alist
  '(("^https://github\\.com/\\\(.*\\\)/blob/\\\(.*\\.svg\\\)$"
     .
     "https://rawgithub.com/\\1/\\2?sanitize=true")
    ("^.*git-\\\(farm\\|repo\\\)/GraphvizImages?/.*/\\\(.*\\\)\\.\\\(svg\\|png\\|jpeg\\|jpg\\\)$" .
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
      (copy-file source-file target-file t))
    (format "/assets/images/%s.%s" basename extension)))

(defconst pre-defined-attributes-for-images
  (list :class "img-fluid img-thumbnail"
        :use-lightbox "2"))

(defun lightbox-1-image-string (source attributes info)
  (org-html-close-tag
   "img"
   (org-html--make-attribute-string
    (org-combine-plists
     (list :src source
	       :alt (file-name-nondirectory source))
     attributes
     (list :data-remote source
           :data-toggle "lightbox"
           :data-type "image")))
   info))

(defun lightbox-2-image-string (source attributes info)
  (format "<a href=\"%s\" data-lightbox=\"image\">%s</a>"
          source
          (org-html-close-tag
           "img"
           (org-html--make-attribute-string
            (org-combine-plists
             (list :src source
                   :alt (file-name-nondirectory source))
             attributes))
           info)))

(defun* org-html--format-image-add-attributes (source attributes)
  (let ((attrs
         (org-combine-plists
          pre-defined-attributes-for-images
          attributes)))
    attrs))

(defun* org-html--format-image-new (source attributes info)
  "Embedding svg file for github raw image"
  (message "call with source=[%s]" source)
  (let* ((attrs (org-html--format-image-add-attributes source attributes))
         (make-string-func (if (equal (plist-get attrs :use-lightbox) "1")
                               'lightbox-1-image-string
                             'lightbox-2-image-string)))
    (dolist (m image-source-matching-alist)
      (when (string-match (car m) source)
        (message "found a match[%s]" (car m))
        (let ((source-link (if (stringp (cdr m))
                               (replace-regexp-in-string (car m) (cdr m) source)
                             (funcall (cdr m ) (car m) source))))
          (return-from org-html--format-image-new
            (funcall make-string-func source-link attrs info)))))
    (funcall make-string-func source attrs info)))

(advice-add #'org-html--format-image :override
            #'org-html--format-image-new)

(defun main ()
  (interactive)
  (destructuring-bind (file &optional output-file) command-line-args-left
    (with-current-buffer (find-file-noselect file)
      ;; the org-html-htmlize-output-type controls whether export code as
      ;; css or inline-css
      ;; css: export selectors only
      ;; inline-css: selector and attributes
      ;; nil: plain text.
      (let ((org-html-htmlize-output-type 'nil))
        (org-export-to-file
            'html
            (or output-file
                (concat (file-name-sans-extension file) ".html"))
          nil nil nil t)))))
