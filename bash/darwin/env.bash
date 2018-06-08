export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

export ANDROID_HOME=~/Library/Android/sdk/
export ANDROID_SDK_HOME=$ANDROID_HOME
export ANDROID_NDK_R14B_HOME=~/Library/Android/android-ndk-r14b/
export ANDROID_NDK_R10E_HOME=~/Library/Android/android-ndk-r10e/
export ANDROID_NDK_HOME=$ANDROID_NDK_R14B_HOME

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.*.jdk/Contents/Home
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH

append-to-variable PKG_CONIFG_PATH /usr/local/lib/pkgconfig
append-to-variable LD_LIBRARY_PATH "$HOME/bin/lib"
append-to-variable LD_LIBRARY_PATH "/usr/local/lib"
append-to-variable MANPATH "$HOME/git-repo/depot_tools/man/"
append-to-variable MANPATH "/usr/local/texlive/2015/texmf-dist/doc/man"
append-to-variable INFOPATH "/usr/local/texlive/2015/texmf-dist/doc/info"

# Need to change build/soong/cc/config/x86_darwin_host.go to
# add "10.13" to darwinSupportedSdkVersions
export MAC_SDK_VERSION=10.13

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export LC_ALL=

_head_to_path_variable=(
    /sbin
    /usr/sbin
    /opt/local/bin
    /usr/local/texlive/2015/bin/x86_64-linux
    /usr/local/opt/gnu-getopt/bin
    /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/opt/texinfo/bin
    $HOME/bin
    $HOME/.rvm/bin
    $HOME/.emacs-pkg
    $HOME/.platform_script
    $HOME/bin/binfile
    $HOME/bin/common-scripts
    $HOME/bin/common-scripts/envs
    $HOME/bin/private-scripts
    $HOME/bin/common-scripts/android-decompile
    $HOME/build/android-studio/bin
    $ANDROID_NDK_HOME
    $ANDROID_SDK_HOME/tools
    $ANDROID_SDK_HOME/platform-tools
    /Applications/Emacs.app/Contents/MacOS/bin
    /Applications/Racket\ v6.9/bin
    $JAVA_HOME/bin
    $JRE_HOME/bin
)

for name in ${_head_to_path_variable[@]}; do
    head-to-path $name
done

_append_to_path_variable=(
    /usr/local/Cellar/git/2.10.0/bin
    /usr/local/texlive/2016/bin/universal-darwin
    /usr/local/Cellar/node/8.1.4/bin/
    $HOME/git-repo/depot_tools
)
for name in ${_append_to_path_variable[@]}; do
    append-to-path $name
done

if [ "$TERM" != "eterm-color" ]; then
    source-if-exist "${HOME}/.iterm2_shell_integration.bash"
fi

source-if-exist "${HOME}/.bashrc_gitignore"

unset _append_to_path_variable
unset _head_to_path_variable
