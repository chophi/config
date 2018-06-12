_append_to_path_variable=(
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

append-to-path "${_append_to_path_variable[@]}"
