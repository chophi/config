export TF_BINARY_URL_PY2=https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.12.0rc0-py2-none-any.whl
export TF_BINARY_URL_PY3=https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-0.12.0rc0-py3-none-any.whl
alias install-tf-py2='sudo -H pip install $TF_BINARY_URL_PY2'
alias install-tf-py3='sudo -H pip install $TF_BINARY_URL_PY3'
