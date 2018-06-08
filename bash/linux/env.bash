export USE_CCACHE=1
export CCACHE_DIR=/local/ccache

append-to-variable PKG_CONIFG_PATH /usr/local/lib/pkgconfig
append-to-variable LD_LIBRARY_PATH "$HOME/bin/lib"
append-to-variable LD_LIBRARY_PATH "/usr/local/lib"
append-to-variable MANPATH "$HOME/git-repo/depot_tools/man/"
append-to-variable MANPATH "/usr/local/texlive/2015/texmf-dist/doc/man"
append-to-variable INFOPATH "/usr/local/texlive/2015/texmf-dist/doc/info"

_head_to_path_variable=(
    $HOME/.emacs-pkg
)

for name in ${_head_to_path_variable[@]}; do
    head-to-path $name
done

_append_to_path_variable=(
    /sbin
    /usr/sbin
    $HOME/bin
    $HOME/bin/binfile
    $HOME/bin/common-scripts
    $HOME/bin/common-scripts/envs
    $HOME/bin/private-scripts
    $HOME/.rvm/bin
    $HOME/bin/common-scripts/android-decompile
    $HOME/build/android-studio/bin
    $HOME/software/racket/bin/
    $HOME/software/swift-dev/bin
    $HOME/git-repo/depot_tools
    /usr/local/texlive/2015/bin/x86_64-linux
)
for name in ${_append_to_path_variable[@]}; do
    append-to-path $name
done

if [ "$TERM" != "eterm-color" ]; then
    source-if-exist "${HOME}/.iterm2_shell_integration.bash"
fi

source-if-exist "${HOME}/.bashrc_gitignore"
source-if-exist "$HOME/.rvm/scripts/rvm"
unset _append_to_path_variable
unset _head_to_path_variable
