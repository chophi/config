export USE_CCACHE=0
export CCACHE_DIR=/local/ccache

append-to-variable PKG_CONFIG_PATH "/usr/local/lib/pkgconfig"
append-to-variable LD_LIBRARY_PATH "$HOME/bin/lib"
append-to-variable LD_LIBRARY_PATH "/usr/local/lib"
append-to-variable MANPATH "$HOME/git-repo/depot_tools/man/"
append-to-variable MANPATH "/usr/local/texlive/2015/texmf-dist/doc/man"
append-to-variable INFOPATH "/usr/local/texlive/2015/texmf-dist/doc/info"

_head_to_path_variable=(
    $HOME/.emacs-pkg
    /usr/lib/jvm/java-8-openjdk-amd64/bin #prefer java 8
    /usr/lib/jvm/java-7-openjdk-amd64/bin
)

_append_to_path_variable=(
    /sbin
    /usr/sbin
    $HOME/.rvm/bin
    $HOME/build/android-studio/bin
    $HOME/software/racket/bin/
    $HOME/software/swift-dev/bin
    $HOME/git-repo/depot_tools
    /usr/local/texlive/2015/bin/x86_64-linux
)

head-to-path "${_head_to_path_variable[@]}"
append-to-path "${_append_to_path_variable[@]}"

unset _append_to_path_variable
unset _head_to_path_variable

if [ "$TERM" != "eterm-color" ]; then
    source-if-exist "${HOME}/.iterm2_shell_integration.bash"
fi

source-if-exist "${HOME}/.bashrc_gitignore"
source-if-exist "$HOME/.rvm/scripts/rvm"
