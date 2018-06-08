ulimit -S -n 1024
function mountAndroid {
    hdiutil attach ~/.BigFile/android.dmg.sparseimage -mountpoint ~/work;
}

function umountAndroid() {
    hdiutil detach ~/work;
}
