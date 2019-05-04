if [ -e $HOME/.py-vir-env/py3 ]; then
    export PYTHONHOME=$HOME/.py-vir-env/py3
    export VIRTUAL_ENV=$HOME/.py-vir-env/py3
    export PATH=$VIRTUAL_ENV/bin:$PATH
elif [ -e $HOME/.py-vir-env/py2 ]; then
    export PYTHONHOME=$HOME/.py-vir-env/py2
    export VIRTUAL_ENV=$HOME/.py-vir-env/py2
    export PATH=$VIRTUAL_ENV/bin:$PATH
fi

clean-variable PATH
clean-variable LD_LIBRARY_PATH
clean-variable INFOPATH
clean-variable MANPATH
clean-variable PKG_CONFIG_PATH
clean-variable LDFLAGS " "
clean-variable CPPFLAGS " "
