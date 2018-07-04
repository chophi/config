#!/bin/bash

emacs_executable="/Applications/Emacs.app/Contents/MacOS/Emacs"
emacs_lisp_dir="/Applications/Emacs.app/Contents/Resources/lisp"
if [ -e $emacs_executable ]; then
    $emacs_executable -batch -Q --directory $emacs_lisp_dir "$@"
else
    echo "Emacs.app is not exist"
    exit 1
fi
