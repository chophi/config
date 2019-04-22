#!/bin/bash

if [ $# -lt 1 ]; then
   echo org-to-latex <name> [cn]
fi

filename=$1
bn=`basename $filename .org`
emacsclient -s ~/.emacs.d/server/server -e "(with-current-buffer (get-file-buffer \"$filename\") (org-latex-export-to-latex))"
mkdir -p tmp
rm -rf tmp/*
mv ${bn}.tex tmp/${bn}.tex

if [ $# -ge 2 ] && [ "$2" == cn ]; then
    (cd tmp && latexmk -pdf -f -xelatex -shell-escape ${bn}.tex)
else
    (cd tmp && latexmk -pdf -f -shell-escape ${bn}.tex)
fi

mv tmp/${bn}.pdf .
