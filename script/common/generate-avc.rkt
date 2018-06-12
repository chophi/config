#!/usr/bin/env racket

#lang racket

(printf "Current-directory: ~a\n" (current-directory))

(define input-file (vector-ref (current-command-line-arguments) 0))
(define output-file (path-replace-suffix input-file ".avc.org"))
(define this-file (build-path (find-system-path 'run-file)))
(define debug-file "debug.out")

(printf "This file: ~a\nInput file: ~a" this-file input-file)

(define (get-source-context avc-rule)
  (third (string-split (second (regexp-match #rx"scontext=(.*) " avc-rule)) ":")))

(define input (open-input-file input-file))
(define output (open-output-file output-file #:exists 'truncate))
(define debug (open-output-file debug-file #:exists 'truncate))

(define linum 1)
(define source-rule-table (make-hash))
(for ([full-line (in-lines input)])
  (when (regexp-match #rx"avc: denied" full-line)
    (let* ([line (second (string-split full-line " avc: "))]
           [source (get-source-context line)]
           [found-duplicate #f])
      (if (not (dict-ref source-rule-table source #f))
          (dict-set! source-rule-table source `((,line ,linum ,full-line)))
          (begin
           (for ([l (dict-ref source-rule-table source)])
            (when (equal? line (car l))
              (set! found-duplicate #t)))
           (when (not found-duplicate)
             (dict-set! source-rule-table source
                   (append (dict-ref source-rule-table source) `((,line ,linum ,full-line)))))))))
  (set! linum (+ 1 linum)))

(define input-file-abs-path (build-path (current-directory) input-file))
(for ([(key value) (in-hash source-rule-table)])
  (fprintf output "* ~a\n" key)
  (let ([counter 0]
        [denied-rules ""])
    (for ([rule value])
      (let ([line (first rule)]
            [linum (second rule)]
            [full-line (third rule)])
        (set! counter (+ 1 counter))
        (fprintf output "  ~a. [[~a::~a][~a::~a]]\n   avc: ~a\n"
                 counter
                 input-file-abs-path
                 linum
                 (last (string-split (~a input-file-abs-path) "/"))
                 linum
                 line)
        (set! denied-rules (string-append denied-rules full-line "\n" full-line "\n"))))
    (let ([command (format "echo -e ~s | /usr/bin/audit2allow" denied-rules)])
      (fprintf debug "run command:\n ~a\n" command)
      (fprintf output "Rules to add:\n#+BEGIN_SRC sh\n~a\n#+END_SRC\n"
               (string-trim (with-output-to-string (lambda () (system command))))))))

(close-input-port input)
(close-output-port output)
(close-output-port debug)

