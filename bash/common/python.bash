function create-python-virtualenv {
    if [ $# -lt 1 ] || ([ "$1" != "2" ] && [ "$1" != "3" ]); then
        echo "Usage: create-python-virtualenv 2|3"
        return 1
    fi

    if [ -e $HOME/.py-vir-env/py$1 ]; then
        echo "Virtual env already exist in $HOME/.py-vir-env/py$1"
        return 0
    fi
    mkdir -p ~/.py-vir-env
    virtualenv --system-site-packages --python=python$1 $HOME/.py-vir-env/py$1
}

function choose-python-virtualenv {
    deactive > /dev/null 2>&1
    local choice
    if [ $# -ge 1 ]; then
        choice=$1
    else
        if [ -e $HOME/.py-vir-env/py3 ]; then
            choice=3
        fi
        if [ -e $HOME/.py-vir-env/py2 ]; then
            ((choice=choice+2))
        fi
    fi
    if [ $choice -gt 3 ]; then
        echo -n "Both py2 and py3 are exist, input your choice(2/3): "
        read choice
        if [ "$choice" != "2" ] && [ "$choice" != "3" ]; then
            echo "Bad choice, do nothing, exit!"
            return 1
        fi
    fi

    if [ -n "$choice" ]; then
        export PYTHONHOME=$HOME/.py-vir-env/py$choice
        export VIRTUAL_ENV=$HOME/.py-vir-env/py$choice
        export PATH=$VIRTUAL_ENV/bin:$PATH
        clean-variable PATH
        if [ $# -le 1 ]; then
            emacsclient -s ~/.emacs.d/server/server -e "(cu-set-python-virtualenv \"$PYTHONHOME\")"
        fi
    fi
}

# mirrors of pip
# 阿里云 https://mirrors.aliyun.com/pypi/simple/
# 中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/
# 豆瓣(douban) http://pypi.douban.com/simple/
# 清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/
# 中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/
function pip-install {
    sudo -H pip install "$@" -i https://mirrors.aliyun.com/pypi/simple/
}


