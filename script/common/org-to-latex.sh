#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: org-to-latex <name> [cn]"
    exit 0
fi

filename=$(realpath $1)

if ! [ -e $filename ]; then
    echo "$filenane is not exist!"
    exit 1
fi

md5sum=$(echo $filename | md5sum | cut -d " " -f 1)
bn=`basename $filename .org`
tmp_dir=/tmp/${bn}-${md5sum}
mkdir -p ${tmp_dir}
rm -rf ${tmp_dir}/*
cp -f $filename $tmp_dir

emacsclient \
    -s ~/.emacs.d/server/server \
    -e \
    "(cu-offline-org-to-latex \"$tmp_dir/$(basename $filename)\" \"$tmp_dir/${bn}.tex\")"

if [ $# -ge 2 ] && [ "$2" == cn ]; then
    (cd ${tmp_dir} && latexmk -pdf -f -xelatex -shell-escape ${bn}.tex)
else
    (cd ${tmp_dir} && latexmk -pdf -f -shell-escape ${bn}.tex)
fi

mkdir -p $HOME/Documents/pdf.org
mv ${tmp_dir}/${bn}.pdf ${HOME}/Documents/pdf.org
