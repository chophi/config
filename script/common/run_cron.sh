#!/bin/bash
CONFIG_ROOT_DIR=~/git-repo/config
MY_HOST_SYSTEM=`uname -a | cut -d " " -f 1 | tr A-Z a-z`
PATH=$PATH:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/bin:/bin:/sbin:/usr/sbin:${CONFIG_ROOT_DIR}/bin/common:${CONFIG_ROOT_DIR}/bin/common/decompile-apk:${CONFIG_ROOT_DIR}/bin/${MY_HOST_SYSTEM}:${CONFIG_ROOT_DIR}/private/bin/common:${CONFIG_ROOT_DIR}/private/bin/${MY_HOST_SYSTEM}:${CONFIG_ROOT_DIR}/script/common:${CONFIG_ROOT_DIR}/script/${MY_HOST_SYSTEM}:${CONFIG_ROOT_DIR}/private/script/common:${CONFIG_ROOT_DIR}/private/script/${MY_HOST_SYSTEM}

NAME=$1
COMMAND=$2
shift
shift
OTHER_ARGS="$@"
FOLDER=$HOME/logs/cron
TIME=`/bin/date +"%Y.%m.%d-%H.%M.%S"`
LOG_FILE=$FOLDER/$NAME-$TIME
mkdir -p $FOLDER
# remove the old log, and only remain 10 log file
EXIST_LOG_FILES=(`ls $FOLDER/$NAME-[0-2]*`)
# the /usr/bin/seq and /usr/local/opt/coreutils/libexec/gnubin/seq
# behave different, the first can use `seq 10 1` to product a decrease sequence.
if [ 10 -le ${#EXIST_LOG_FILES[@]} ]; then
    for n in `seq 10 ${#EXIST_LOG_FILES[@]}`; do
        rm ${EXIST_LOG_FILES[${#EXIST_LOG_FILES[@]}-$n]}
    done
fi

RUNNING_FILE=$FOLDER/${NAME}-`basename $COMMAND`-is-running
MAIN_LOG_FILE=$FOLDER/cron.log
if [ -f $RUNNING_FILE ]; then
    ppid=`cat $RUNNING_FILE | cut -d " " -f 1`
    log_file=`cat $RUNNING_FILE | cut -d " " -f 2`
    exist_processes=`pgrep -f run_cron\.sh.*$NAME.*$COMMAND.* -P $ppid`
    exist_processes=${exist_processes/$$/}
    if [ -n "$exist_processes" ]; then
        echo [$NAME]: [$exist_processes] running and log-ed to $log_file >> $MAIN_LOG_FILE
        exit 0
    else
        echo "[$NAME]: terminated command with $ppid, remove the running status file." >> $MAIN_LOG_FILE
        rm $RUNNING_FILE
    fi
fi

precondition_files=(
    $HOME/.cron_precondition_check.py
    $HOME/git-repo/config/private/config/common/cron_precondition_check.py
    $HOME/git-repo/config/private/config/${MY_HOST_SYSTEM}/cron_precondition_check.py
)

for script in "${precondition_files[@]}"; do
    if [ -f $script ] && [ "`$script $NAME`" != "yes" ]; then
        echo "[$NAME]: precondition check fail on $script, won't run" >> $MAIN_LOG_FILE
        exit 0
    fi
done

echo "$PPID $LOG_FILE" > $RUNNING_FILE
$COMMAND $OTHER_ARGS >> $LOG_FILE 2>&1
rm $RUNNING_FILE

