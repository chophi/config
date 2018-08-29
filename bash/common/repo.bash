export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'
alias repo-init-android-o='repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-8.0.0_r13'
alias repo-init-android-p='repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-9.0.0_r3'

alias repo-sync='mkdir -p .log && repo sync -j8 2>&1 | tee .log/sync-`bdate`.log'
alias repo-sync-current='mkdir -p .log && repo sync -j8 -c 2>&1 | tee .log/sync-`bdate`.log; echo `bdate` > .log/sync-completed-timestamp'
alias repo-sync-current-local='mkdir -p .log && repo sync -j8 -c -l 2>&1 | tee .log/sync-`bdate`.log'
alias repo-make='mkdir -p .log && make -j8 2>&1 | tee .log/make-`bdate`.log'

function repo-top {
    curpath=$PWD
    while [ ! -d '.repo' ]; do
        cd ..
    done
    repo_top=$PWD
    cd $curpath
    echo $repo_top
}

function gotod {
    if [ -z "$1" ]; then
        echo 'please provide a regexp to grep'
        return 0
    fi

    local dir_list=(`repo list | grep "$1" | cut -d ':' -f 1`)
    if [ ${#dir_list[@]} -eq 0 ]; then
        echo "no project grepped, exit"
        return 0
    elif [ ${#dir_list[@]} -eq 1 ]; then
        cd `repo-top`
        cd ${dir_list[0]}
        return 0
    fi

    echo '=========== Dir List ==================='
    for d in `seq 0 $(echo ${#dir_list[@]}-1 | bc)`; do
        echo "$d : ${dir_list[$d]}"
    done
    echo -n 'please select a dir to goto: '
    local x
    read x
    cd `repo-top`
    cd ${dir_list[$x]}
}

alias gotop='cd `repo-top`'
