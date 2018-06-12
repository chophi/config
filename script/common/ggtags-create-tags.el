:;exec emacs -batch -Q -l "$0" -f main "$@"
(require 'cl)
(toggle-debug-on-error)
(defun main ()
  (interactive)
  (destructuring-bind (dir) command-line-args-left
    (add-to-list 'exec-path "/usr/local/bin")
    (load-file "~/.emacs.d/elpa/ggtags-20150325.2025/ggtags.el")
    (ggtags-create-tags dir)
    ))


