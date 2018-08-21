ulimit -S -n 1024

function create-sparse-image {
    if [ $# -ne 2 ]; then
        echo "Usage <name> <size> : create a sparse image named ~/.BigFile/<name> with <size>g if it's not already exist."
        return 1
    fi

    local file=$1
    local size=$2
    if [ -e ~/.BigFile/$file ] || [ -e ~/.BigFile/${file}.sparseimage ]; then
        echo "Already exist."
        return 0
    fi
    hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size ${size}g ~/.BigFile/$file
}

function resize-sparse-image {
    if [ $# -ne 2 ]; then
        echo "Usage <name> <size> : resize the sparse image named ~/.BigFile/<name> to <size>g"
        return 1
    fi

    local file=$1
    local size=$2
    if [ -e ~/.BigFile/$file ]; then
        file=~/.BigFile/$file
    elif [ -e ~/.BigFile/${file}.sparseimage ]; then
        file=~/.BigFile/$file.sparseimage
    else
        echo "No file named $1 or $1.sparseimage in ~/.BigFile"
        return 1
    fi
    hdiutil resize -size ${size}g ${file}
}

function mount-sparse-image {
    if [ $# -ne 2 ]; then
        echo "Usage <name> <mountpoint> : mount ~/.BigFile/<name> to <mountpoint>"
        return 1
    fi

    local file=$1
    local mountpoint=$2
    if [ -e ~/.BigFile/$file ]; then
        file=~/.BigFile/$file
    elif [ -e ~/.BigFile/${file}.sparseimage ]; then
        file=~/.BigFile/$file.sparseimage
    else
        echo "No file named $1 or $1.sparseimage in ~/.BigFile"
        return 1
    fi

    hdiutil attach ${file} -mountpoint ${mountpoint};
}

function unmount-sparse-image {
    if [ $# -ne 1 ]; then
        echo "Usage <mountpoint> : unmount <mountpoint>"
        return 1
    fi

    local mountpoint=$1
    if ! [ -e $mountpoint ]; then
        echo "mount point $mountpoint doesn't exist"
        return 1
    fi

    hdiutil detach ${mountpoint};
}

function _set-android-build-env-pre {
    export PATH=/bin:$PATH
    alias ls='ls -G'
}

function set-android-build-env {
    cd ~/work/aosp/pie
    source build/envsetup.sh
    lunch aosp_arm-eng
}

# After set the android sparse image:
# create-sparse-image android.img 160
# Add this to private/bash/darwin/post.bash:
# if ! [ -e ~/work/aosp/pie ]; then
#     mount-sparse-image android.img ~/work/aosp
# fi
# _set-android-build-env-env
