# Powerline-like prompt
# By SliceOfCode (@sliceofcode)
# Generates PS1
function __prompt_command_powerline {
    # UTF-8 Powerline constants. Contents in the strings below
    # SHOULD LOOK WEIRD IF NOT USING A POWERLINE SUPPORTED FONT.
    local PBranch="";     local PLine="";              local PLock="";

    # ANSI constants.
    # If your terminal doesn't support ANSI, then instead of nice colors
    # you will see ugly text.

    # Regular                        Bold                      Underline           High Intensity
    local Bla='\e[0;30m';     local BBla='\e[1;30m';    local UBla='\e[4;30m';    local IBla='\e[0;90m';
    local Red='\e[0;31m';     local BRed='\e[1;31m';    local URed='\e[4;31m';    local IRed='\e[0;91m';
    local Gre='\e[0;32m';     local BGre='\e[1;32m';    local UGre='\e[4;32m';    local IGre='\e[0;92m';
    local Yel='\e[0;33m';     local BYel='\e[1;33m';    local UYel='\e[4;33m';    local IYel='\e[0;93m';
    local Blu='\e[0;34m';     local BBlu='\e[1;34m';    local UBlu='\e[4;34m';    local IBlu='\e[0;94m';
    local Pur='\e[0;35m';     local BPur='\e[1;35m';    local UPur='\e[4;35m';    local IPur='\e[0;95m';
    local Cya='\e[0;36m';     local BCya='\e[1;36m';    local UCya='\e[4;36m';    local ICya='\e[0;96m';
    local Whi='\e[0;37m';     local BWhi='\e[1;37m';    local UWhi='\e[4;37m';    local IWhi='\e[0;97m';

    # BoldHigh Intens     Background          High Intensity Backgrounds
    local BIBla='\e[1;90m';   local On_Bla='\e[40m';    local On_IBla='\e[0;100m';
    local BIRed='\e[1;91m';   local On_Red='\e[41m';    local On_IRed='\e[0;101m';
    local BIGre='\e[1;92m';   local On_Gre='\e[42m';    local On_IGre='\e[0;102m';
    local BIYel='\e[1;93m';   local On_Yel='\e[43m';    local On_IYel='\e[0;103m';
    local BIBlu='\e[1;94m';   local On_Blu='\e[44m';    local On_IBlu='\e[0;104m';
    local BIPur='\e[1;95m';   local On_Pur='\e[45m';    local On_IPur='\e[0;105m';
    local BICya='\e[1;96m';   local On_Cya='\e[46m';    local On_ICya='\e[0;106m';
    local BIWhi='\e[1;97m';   local On_Whi='\e[47m';    local On_IWhi='\e[0;107m';

    EXIT="$?" # Exit status of last command.
    PS1="" # Blank the PS1
    local USER=`whoami` # Get the current user.
    local BRANCH=`__my_git_ps1` # Get the branch name.
    local pwd=${PWD/#$HOME/\~} # Replace /home/user with ~.
    local Res='\e[0m'    # Text Reset

    PS1+="\n"
    PS1+="\\[$Bla$On_Gre ╭⊂\\]"
    PS1+=""\\[$(pl_segment_start $Gre $On_Red)\\]""
    if [[ $BRANCH != "" ]]; then # Check if there is a branch in this directory.
        PS1+=""\\[$(pl_segment_hasafter $Bla$On_Red `date +"%m.%d-%H.%M.%S"` $Red $On_Gre)\\]""
        PS1+="\\[$(pl_segment_hasafter $BBla$On_Gre "${PBranch} ${BRANCH}" $Gre $On_Blu)\\]"
    else
        PS1+=""\\[$(pl_segment_hasafter $Bla$On_Red `date +"%m.%d-%H.%M.%S"` $Red $On_Blu)\\]""
    fi

    PS1+="\\[$(pl_segment_hasafter $Bla$On_Blu "${USER}@${HOSTNAME}" $Blu $On_Yel)\\]" # Add user@hostname

    local cur_path=${PWD/$HOME/\~}
    if [ ${#cur_path} -gt 35 ]; then
        cur_path=...${cur_path:${#cur_path}-32:32}
    fi

    PS1+="\\[$(pl_segment $Bla$On_Yel "${cur_path}" $Yel)\\]" # Add current directory
    PS1+="\n"
    PS1+="\\[$Bla$On_Gre ╰⊂\\]"
    PS1+=""\\[$(pl_segment_start $Gre $On_Bla)\\]" "
    PS1+="${Res}"
}

function __prompt_command_test {
    # Regular                        Bold                      Underline           High Intensity
    local Bla='\e[0;30m';     local BBla='\e[1;30m';    local UBla='\e[4;30m';    local IBla='\e[0;90m';
    local Red='\e[0;31m';     local BRed='\e[1;31m';    local URed='\e[4;31m';    local IRed='\e[0;91m';
    local Gre='\e[0;32m';     local BGre='\e[1;32m';    local UGre='\e[4;32m';    local IGre='\e[0;92m';
    local Yel='\e[0;33m';     local BYel='\e[1;33m';    local UYel='\e[4;33m';    local IYel='\e[0;93m';
    local Blu='\e[0;34m';     local BBlu='\e[1;34m';    local UBlu='\e[4;34m';    local IBlu='\e[0;94m';
    local Pur='\e[0;35m';     local BPur='\e[1;35m';    local UPur='\e[4;35m';    local IPur='\e[0;95m';
    local Cya='\e[0;36m';     local BCya='\e[1;36m';    local UCya='\e[4;36m';    local ICya='\e[0;96m';
    local Whi='\e[0;37m';     local BWhi='\e[1;37m';    local UWhi='\e[4;37m';    local IWhi='\e[0;97m';

    # BoldHigh Intens     Background          High Intensity Backgrounds
    local BIBla='\e[1;90m';   local On_Bla='\e[40m';    local On_IBla='\e[0;100m';
    local BIRed='\e[1;91m';   local On_Red='\e[41m';    local On_IRed='\e[0;101m';
    local BIGre='\e[1;92m';   local On_Gre='\e[42m';    local On_IGre='\e[0;102m';
    local BIYel='\e[1;93m';   local On_Yel='\e[43m';    local On_IYel='\e[0;103m';
    local BIBlu='\e[1;94m';   local On_Blu='\e[44m';    local On_IBlu='\e[0;104m';
    local BIPur='\e[1;95m';   local On_Pur='\e[45m';    local On_IPur='\e[0;105m';
    local BICya='\e[1;96m';   local On_Cya='\e[46m';    local On_ICya='\e[0;106m';
    local BIWhi='\e[1;97m';   local On_Whi='\e[47m';    local On_IWhi='\e[0;107m';
    PS1=""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Red "Red" $Red $On_Gre)\\]""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Gre "Green" $Gre $On_Yel)\\]""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Yel "Yellow" $Yel $On_Blu)\\]""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Blu "Blue" $Blu $On_Pur)\\]""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Pur "Purple" $Pur $On_Cya)\\]""
    PS1+=""\\[$(pl_segment_hasafter $Bla$On_Cya "Cyan" $Cya $On_Whi)\\]""
    PS1+=""\\[$(pl_segment $Bla$On_Whi "White" $Whi)\\]""
    PS1+="\n" # Add new line.
    PS1+=$'\xe2\x9e\xa5 '
}
# pl_segment
# Draws a segment
#
# pl_segment $TEXT_BG "TEXT" $ARROW_COL
function pl_segment {
    # UTF-8 Powerline constants. Contents in the strings below
    # SHOULD LOOK WEIRD IF NOT USING A POWERLINE SUPPORTED FONT.
    local PRightArrow=""; local PRightArrowOutline="";
    local PLeftArrow="";  local PLeftArrowOutline="";

    local Res='\e[0m'    # Text Reset

    echo -ne "${1} ${2} ${Res}${3}${PRightArrow}${Res}"
}

function pl_segment_start {
    # UTF-8 Powerline constants. Contents in the strings below
    # SHOULD LOOK WEIRD IF NOT USING A POWERLINE SUPPORTED FONT.
    local PRightArrow=""; local PRightArrowOutline="";
    local PLeftArrow="";  local PLeftArrowOutline="";

    local Res='\e[0m'    # Text Reset
    echo -ne "${1}${2}${PRightArrow}${Res}"
}
# pl_segment_hasafter
# Draws a segment, before a new segment.
#
# pl_segment_hasafter $TEXT_BG "TEXT" $ARROW_COL $NEXTSEGMENT_BG
function pl_segment_hasafter {
    # UTF-8 Powerline constants. Contents in the strings below
    # SHOULD LOOK WEIRD IF NOT USING A POWERLINE SUPPORTED FONT.

    local PRightArrow=""; local PRightArrowOutline="";
    local PLeftArrow="";  local PLeftArrowOutline="";

    local Res='\e[0m'    # Text Reset

    echo -ne "${1} ${2} ${Res}${3}${4}${PRightArrow}${Res}"
}

export SOURCED_GIT_PROMPT=no
function __test_source_git_prompt {
    local possible_git_prompt_file=(
        "/opt/local/share/git/git-prompt.sh"
        "/etc/bash_completion.d/git-prompt"
        "/usr/local/etc/bash_completion.d/git-prompt.sh"
    )
    for file in ${possible_git_prompt_file[@]}; do
        if [ -f "$file" ]; then
            source $file
            export SOURCED_GIT_PROMPT=yes
            return 0;
        fi
    done

    export SOURCED_GIT_PROMPT=not_found
}

function __my_git_ps1 {
    if [ "$SOURCED_GIT_PROMPT" == "no" ]; then
        __test_source_git_prompt
    fi
    if [ "$SOURCED_GIT_PROMPT" != "not_found" ]; then
        local branch=`__git_ps1`
        if [ "$branch" != "" ]; then
            branch=${branch:2:-1}
        fi
        echo "$branch"
    else
        echo "`git symbolic-ref --short HEAD 2>/dev/null`"
    fi
}

function __prompt_command_simple() {
    # Terminal colours (after installing GNU coreutils)
    local NM="\[\033[0;38m\]" #means no background and white lines
    local HI="\[\033[0;32m\]" #change this for letter colors
    local HII="\[\033[0;31m\]" #change this for letter colors
    local SI="\[\033[0;33m\]" #this is for the current directory
    local IN="\[\033[0m\]"
    if [ "$SOURCED_GIT_PROMPT" == "no" ]; then
        __test_source_git_prompt
    fi

    # local begin=$'\u256D\u2282'
    # local end=$'\u2283\u2563'
    # local connector=$'\u2283\u2500\u2282'
    # local new_line_begin=$'\u2570\u2282'

    local begin=$'\xe2\x95\xad\xe2\x8a\x82'
    # local begin=$'\xe2\xa6\xa7\xe2\x8a\x82'
    local end=$'\xe2\x8a\x83\xe2\xa8\xad'
    local connector=$'\xe2\x8a\x83\xe2\x94\x80\xe2\x8a\x82'
    local new_line_begin=$'\xe2\x95\xb0\xe2\x8a\x82'
    # local new_line_begin=$'\xe2\xa6\xa6\xe2\x8a\x82'

    local cur_path=${PWD/$HOME/\~}
    if [ ${#cur_path} -gt 35 ]; then
        cur_path=...${cur_path:${#cur_path}-32:32}
    fi
    local git_branch=`__my_git_ps1`
    if [ -z "$git_branch" ]; then
        PS1="\n${begin}(${NM}${HI}\h${IN})${connector}[${SI}${cur_path}${IN}]${end}\n${new_line_begin} "
    else
        PS1="\n${begin}(${NM}${HI}\h${IN})${connector}[${SI}${cur_path}${IN}]${connector}{${NM}${HII}${git_branch}${IN}}${end}\n${new_line_begin} "
    fi
    PS2=${new_line_begin}
}

alias set-ps1-powerline='export PROMPT_COMMAND=__prompt_command_powerline'
alias set-ps1-simple='export PROMPT_COMMAND=__prompt_command_simple'
alias set-ps1-test='export PROMPT_COMMAND=__prompt_command_test'

# Generate PS1 using PROMPT_COMMAND
if [ "$TERM" == "xterm-256color" ] || [ "$TERM" == "rxvt-unicode" ]; then
    alias set_prompt_command='export PROMPT_COMMAND=__prompt_command_simple'
    alias __prompt_command='__prompt_command_simple'
else # [ "$TERM" == "eterm-color" ]
    alias set_prompt_command='export PROMPT_COMMAND=__prompt_command_powerline'
    alias __prompt_command='__prompt_command_powerline'
fi

set_prompt_command
alias unset_prompt_command='export PROMPT_COMMAND= && export PS1="\u@\h:\w: "'

