for name in `ls *.AVI`; do
    if ! [ -f ${name/AVI/mp4} ]; then
        ffmpeg -i "$name" -vcodec libx264 "${name/AVI/mp4}";
    fi
done
