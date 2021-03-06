function repo-top {
    local curpath=$PWD
    while [ ! -d '.repo' ] && [ "$PWD" != "/" ]; do
        cd ..
    done
    local repo_top=$PWD
    if [ "$PWD" == "/" ]; then
        cd $curpath
        return 1
    fi
    eval $1=$PWD
    cd $curpath
}

function gotop {
    local _tmp_repo_dir
    if ! repo-top _tmp_repo_dir; then
        echo "You are not in a repo project"
        return 1
    fi

    if [ -z "$1" ]; then
        cd $_tmp_repo_dir
        return 0
    fi

    local dir_list=(`cd $_tmp_repo_dir && repo list | grep "$1" | cut -d ':' -f 1`)
    if [ ${#dir_list[@]} -eq 0 ]; then
        echo "no project grepped, exit"
        return 0
    elif [ ${#dir_list[@]} -eq 1 ]; then
        cd $_tmp_repo_dir/${dir_list[0]}
        return 0
    fi

    echo '=========== Dir List ==================='
    for d in `seq 0 $(echo ${#dir_list[@]}-1 | bc)`; do
        echo "$d : ${dir_list[$d]}"
    done
    echo -n 'please select a dir to goto: '
    local x
    read x
    cd $_tmp_repo_dir/${dir_list[$x]}
}

function _compose-repo-command {
    local to_receive_command=$1
    local log_prefix=$2
    local log_on_terminal=$3
    shift 3
    local command="$@"
    local _tmp_repo_dir
    if ! repo-top _tmp_repo_dir; then
        eval $to_receive_command="\"echo You are not in a repo project && /bin/false\""
        return 1
    fi
    if [ "$log_on_terminal" == "yes" ]; then
        eval $to_receive_command="\"cd $_tmp_repo_dir && mkdir -p .log; $command 2>&1 | tee .log/$log_prefix-`bdate`.log\""
    else
        eval $to_receive_command="\"cd $_tmp_repo_dir && mkdir -p .log; $command > .log/$log_prefix-`bdate`.log 2>&1\""
    fi
}

function repo-clean-logs {
    local _tmp_repo_dir
    if ! repo-top _tmp_repo_dir; then
        eval $to_receive_command="\"echo You are not in a repo project && /bin/false\""
        return 1
    fi
    command="rm -rf $_tmp_repo_dir/.log/*"
    echo "run [$command], (y/n)"
    local x
    read x
    if [ $x == "yes" ] || [ $x == "y" ]; then
        $command
    fi
}

function _repo-run {
    local log_on_terminal=$1
    local repo_subcommand=$2
    shift 2
    local extra
    if [ $repo_subcommand == "sync" ]; then
        extra="echo `bdate` > .log/sync-completed-timestamp; repo"
    fi
    local _tmp_command
    if _compose-repo-command _tmp_command $repo_subcommand $log_on_terminal $extra  $repo_subcommand $@; then
        echo $_tmp_command
    fi
    eval $_tmp_command
}

function repo-run {
    _repo-run "yes" $@
}

function repo-run-no-log {
    _repo-run "no" $@
}

function clone-goldfish-kernel {
    git clone https://aosp.tuna.tsinghua.edu.cn/android/kernel/goldfish.git
}

function repo-init-my-repos {
    local username
    echo -n "Input username: "
    read username

    local pubvar
    while [ "$pubvar" != "public" ] && [ "$pubvar" != "private" ]; do
        echo -n "Public or private manifest? (public/private): "
        read pubvar
    done

    local manifest_file="default.xml"
    if [ "$pubvar" == "private" ]; then
        while [ "$manifest_file" != "work" ] && [ "$manifest_file" != "home" ]; do
            echo -n "Work or Home? (work/home): "
            read manifest_file
        done
        manifest_file=$manifest_file.xml
    fi

    local command="repo init --no-repo-verify --repo-url=ssh://git@gitee.com/$username/git-repo.git --repo-branch=default --manifest-url=ssh://git@gitee.com/$username/${pubvar}-manifests.git --manifest-branch=default --config-name -m $manifest_file"

    echo -n -e "command is [$command] \n (y/n)? Input your choice: "
    local ans
    read ans
    if [ "$ans" == "y" ] || [ "$ans" == "yes" ]; then
        $command
    fi
}
