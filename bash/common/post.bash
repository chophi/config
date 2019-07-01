if [ -e $HOME/.py-vir-env/py2 ]; then
    export PATH=$HOME/.py-vir-env/py2/bin:$PATH
fi

if [ -e $HOME/.py-vir-env/py3 ]; then
    export PATH=$HOME/.py-vir-env/py3/bin:$PATH
fi

clean-variable PATH
clean-variable LD_LIBRARY_PATH
clean-variable INFOPATH
clean-variable MANPATH
clean-variable PKG_CONFIG_PATH
clean-variable LDFLAGS " "
clean-variable CPPFLAGS " "
