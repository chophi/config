export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'
function repo-init-android-o {
    repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.0.0_r13
}
function repo-init-android-p {
    repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-9.0.0_r3
}
function repo-init-emu-master {
    repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b emu-master-qemu
}
function repo-init-studio-master {
    repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b studio-master-dev
}

if [ -e $HOME/work/aosp ]; then
    AOSP_ROOT=$HOME/work/aosp
elif [ -e $HOME/work/mnt/aosp ]; then
    AOSP_ROOT=$HOME/work/mnt/aosp
fi
export AOSP_ROOT

function _set-android-build-env-pre {
    if [ -e ${AOSP_ROOT}/kernel/goldfish/.build/sdcard.bash ]; then
        source ${AOSP_ROOT}/kernel/goldfish/.build/sdcard.bash
    fi
    if ! [ "`uname`" == "Linux" ]; then
        export PATH=/bin:/usr/bin:$PATH
        alias ls='ls -G'
    fi
}

function __my-emulator {
    local possible_kernel=${AOSP_ROOT}/kernel/goldfish/out/arch/x86/boot/bzImage
    local possible_sdcard=${AOSP_ROOT}/data/SdCard4Emulator.img
    local fixed_flags="-writable-system -show-kernel"
    local timestamp=`bdate`
    local kmsg_log_dir=~/logs/goldfish/kmsg
    mkdir -p $kmsg_log_dir
    local conditional_args=""
    if [ -e $possible_kernel ]; then
        conditional_args+=" -kernel ${possible_kernel}"
    fi
    if [ -e $possible_sdcard ]; then
        conditional_args+=" -sdcard ${possible_sdcard}"
    fi
    if [ $# -ge 1 ]; then
        conditional_args+=" $@"
    fi
    ln -sf $kmsg_log_dir/kmsg-$timestamp.log $kmsg_log_dir/kmsg-goldfish-current.log
    local command="emulator $fixed_flags $conditional_args"
    echo [Run: $command]
    echo [Log: $kmsg_log_dir/kmsg-$timestamp.log]
    $command 2>&1 | tee $kmsg_log_dir/kmsg-$timestamp.log
}

function set-android-build-env {
    _set-android-build-env-pre
    cd ${AOSP_ROOT}/pie
    source build/envsetup.sh
    lunch aosp_x86-eng
    alias my-emulator='__my-emulator'
}

function goto-goldfish-dirs {
    # goldfish kernel root
    local gkr="${AOSP_ROOT}/pie/kernel_goldfish"
    local menu=(
        "kernel-root: cd $gkr"
        "kernel-out: cd $gkr/out"
        "kernel-bzImage-dir: cd $gkr/out/arch/x86/boot"
    )
    run_item_in_menu "${menu[@]}"
}

