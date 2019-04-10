function set-go-env-prefer-go1.9 {
    if [ -e "/usr/local/Cellar/go@1.9/bin" ]; then
        export PATH=/usr/local/Cellar/go@1.9/bin:$PATH
    fi
}

function set-go-env-mit-6.824 {
    if [ -e $HOME/git-repo/mit-6.824 ]; then
        export GOPATH=$HOME/git-repo/mit-6.824
        emacsclient -s $EMACS_SOCKET_NAME -e "(cu-set-gopath \"$GOPATH\")"
    fi
}

function set-go-env-go-tour {
    if [ -e $HOME/git-repo/go_tour ]; then
        export GOPATH=$HOME/git-repo/go_tour
        emacsclient -s $EMACS_SOCKET_NAME -e "(cu-set-gopath \"$GOPATH\")"
    fi
}
