function _set-go-env-unset-go1.9 {
    local x=${PATH/\/usr\/local\/Cellar\/go@1.9\/1.9.7\/bin:/}
    export PATH=$x
}

function _set-go-env-prefer-go1.9 {
    if [ -e /usr/local/Cellar/go@1.9/1.9.7/bin ]; then
        export PATH=/usr/local/Cellar/go@1.9/1.9.7/bin:$PATH
    fi
}

function _set-go-env-mit-6.824 {
    _set-go-env-prefer-go1.9
    if [ -e $HOME/git-repo/mit-6.824 ]; then
        export GOPATH=$HOME/git-repo/mit-6.824
        emacsclient -s $EMACS_SOCKET_NAME -e "(cu-set-gopath \"$GOPATH\")"
    fi
}

function _set-go-env-go-tour {
    if [ -e $HOME/git-repo/go_tour ]; then
        export GOPATH=$HOME/git-repo/go_tour
        emacsclient -s $EMACS_SOCKET_NAME -e "(cu-set-gopath \"$GOPATH\")"
    fi
}

function set-go-env {
    echo "Make your choice: "
    local menu=(
        "unset-go1.9: _set-go-env-unset-go1.9"
        "use-go1.9: _set-go-env-prefer-go1.9"
        "mit-6.824: _set-go-env-mit-6.824"
        "go_tour: _set-go-env-go-tour"
    )
    run_item_in_menu "${menu[@]}"
}
