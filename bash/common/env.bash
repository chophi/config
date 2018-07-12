_head_to_path_variable=(
    ${CONFIG_ROOT_DIR}/bin/common
    ${CONFIG_ROOT_DIR}/bin/common/decompile-apk
    ${CONFIG_ROOT_DIR}/bin/${MY_HOST_SYSTEM}
    ${CONFIG_ROOT_DIR}/private/bin/common
    ${CONFIG_ROOT_DIR}/private/bin/${MY_HOST_SYSTEM}
    ${CONFIG_ROOT_DIR}/script/common
    ${CONFIG_ROOT_DIR}/script/${MY_HOST_SYSTEM}
    ${CONFIG_ROOT_DIR}/private/script/common
    ${CONFIG_ROOT_DIR}/private/script/${MY_HOST_SYSTEM}
)

head-to-path "${_head_to_path_variable[@]}"
unset _head_to_path_variable
