# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
export CONFIG_ROOT_DIR=$(dirname $(dirname $(dirname `realpath ${BASH_SOURCE[0]}`)))

source ${CONFIG_ROOT_DIR}/bash/common/pre.bash
source-pre-bashes
source-other-bashes
source-post-bashes

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

append-to-path "$HOME/bin"
append-to-path "$HOME/bin/binfile"
append-to-path "$HOME/bin/common-scripts"
append-to-path "$HOME/bin/common-scripts/envs"
append-to-path "$HOME/bin/private-scripts"
append-to-path "/opt/local/bin"


# import some repo variables
#. ~/envsetup/repo-vars

append-to-variable INFOPATH "/usr/local/texlive/2015/texmf-dist/doc/info"
append-to-variable MANPATH "/usr/local/texlive/2015/texmf-dist/doc/man"

append-to-path "/usr/local/texlive/2015/bin/x86_64-linux"
append-to-path "/sbin"
append-to-path "/usr/sbin"

append-to-path "$HOME/bin/common-scripts/android-decompile"
append-to-path "$HOME/build/android-studio/bin"
append-to-path "$HOME/.rvm/bin"

export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
append-to-variable LD_LIBRARY_PATH "/usr/local/lib"

# set the number of open files to be 1024
ulimit -S -n 1024

# mount the android file image
function mountAndroid {
    hdiutil attach ~/.BigFile/android.dmg.sparseimage -mountpoint ~/work;
}

# unmount the android file image
function umountAndroid() { hdiutil detach ~/work; }


# if [ ! -f "$HOME/work/.mounted" ] ; then
#     mountAndroid
# else
#     echo "$HOME/work/.mounted already existed"
# fi

append-to-path "/opt/local/bin"
export ANDROID_SDK_HOME=~/Library/Android/sdk
export ANDROID_NDK_HOME=~/Library/Android/android-ndk-r10e
append-to-path "$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/tools:$ANDROID_NDK_HOME"
append-to-path "/Applications/Emacs.app/Contents/MacOS/bin"
append-to-path "/Applications/Racket\ v6.9/bin"

if [ "$TERM" != "eterm-color" ]; then
   test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

head-to-path "~/.platform_script"

# prefer gnubin
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

# prefer gnu getopt
head-to-path "/usr/local/opt/gnu-getopt/bin"

# prefer git installed by `brew install git`
append-to-path "/usr/local/Cellar/git/2.10.0/bin"
# append-to-path "/Library/TeX/texbin"
append-to-path "/usr/local/texlive/2016/bin/universal-darwin"
append-to-path "/usr/local/Cellar/node/8.1.4/bin/"

test -e "${HOME}/.bashrc_gitignore" && source "${HOME}/.bashrc_gitignore"
head-to-path "~/.emacs-pkg"

export ANDROID_HOME=~/Library/Android/sdk/
export ANDROID_SDK_HOME=$ANDROID_HOME
export ANDROID_NDK_R14B_HOME=~/Library/Android/android-ndk-r14b/
export ANDROID_NDK_R10E_HOME=~/Library/Android/android-ndk-r10e/
export ANDROID_NDK_HOME=$ANDROID_NDK_R14B_HOME
append-to-path "$ANDROID_HOME/tools"
append-to-path "$ANDROID_HOME/platform-tools"
append-to-path "$ANDROID_NDK_HOME"

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

export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'
alias repo-init-android-o='repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.0.0_r13'

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.*.jdk/Contents/Home
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
export PKG_CONIFG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PATH=/usr/local/opt/texinfo/bin:$PATH
# Need to change build/soong/cc/config/x86_darwin_host.go to
# add "10.13" to darwinSupportedSdkVersions
export MAC_SDK_VERSION=10.13

append-to-path "~/git-repo/depot_tools"
append-to-variable LD_LIBRARY_PATH "$HOME/bin/lib"
append-to-variable MANPATH "~/git-repo/depot_tools/man/"
