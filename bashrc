#!/usr/bin/env bash

#**************************************************************************************************#
#                                            Bash Prompt                                           #
#**************************************************************************************************#

get_git() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

get_date() {
    date '+%m/%d %T'
}

get_dir() {
    echo $(basename $(dirname $PWD))/$(basename $PWD)
}

# PS Format: (Red date) (Green host) (Golden branch) (Blue path) (Gray Prompt)
PS1='
\[$(tput bold)$(tput setaf 197)\]$(get_date)\[$(tput sgr0)\]\
\[$(tput bold)$(tput setaf 46)\] \h\[$(tput sgr0)\]\
\[$(tput bold)$(tput setaf 172)\]$(get_git)\[$(tput sgr0)\]\
\[$(tput bold)$(tput setaf  39)\] $(get_dir)\[$(tput sgr0)\]\
\[$(tput bold)$(tput setaf 244)\] \$ \[$(tput sgr0)\]\
\[$(tput bold)\]'

#**************************************************************************************************#
#                                           Misc Stuffs                                            #
#**************************************************************************************************#
function finder {
    find . -name "$1"
}
function find_and_replace {
    find ./ -type f -exec sed -i -e "s/$1/$2/g" {} \;
}
alias ..="cd .."
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export EDITOR="vim"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear && echo -en "\e[3J"'
alias grep='grep --color'
alias tree='tree --dirsfirst -C'
alias dmesg='dmesg --color=auto --reltime --human --nopager --decode'


#**************************************************************************************************#
#                                           Git Stuffs                                             #
#**************************************************************************************************#
alias gfetch="git fetch --all --tags -f"
alias gbranch="git branch 2>/dev/null | grep '^*' | colrm 1 2"
alias gcp="git cherry-pick"
alias grebase="git pull --rebase origin"
alias gpull='git fetch && git pull'
alias gstatus='git status -uno'
alias gclean='git clean -xdf -e "cscope*"'
function gcheckout {
    curr_branch=$(gbranch)
    git checkout $@ && git branch -D ${curr_branch}
}
function gsquash {
    git rebase --interactive HEAD~$1
}
function gpush {
    var=`gbranch`
    opts=$@
    force_flag=""
    force_print=""

    if [[ ${opts} == *"-f"* ]]; then
        force_flag="-f"
        force_print="$(tput setaf 197)force$(tput sgr0)"
    fi

    if [[ ${var} == "master" || ${var} == "main" ]]; then
        if [[ ${opts} != *"-y"* ]]; then
            printf "Are you sure you want to push to ${var} (y/n)? "
            read answer
            if [ "$answer" == "${answer#[Yy]}" ]; then
                echo "$(tput setaf 197)Avoided Pushing to ${var}$(tput sgr0)"
                return
            fi
        fi
    fi

    echo -e "${force_print} pushing to $(tput setaf 39)${var}$(tput sgr0)"
    git push origin ${force_flag} ${var}
}
function gworktree {
    branch=$1
    path=$2
    git worktree add -b ${branch} ${path}
}
#**************************************************************************************************#
#                                              SSH Stuffs                                          #
#**************************************************************************************************#
function sshp {
    if [[ $# -eq 2 ]]; then
        sshpass -p "$2" ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'PasswordAuthentication yes' $1
    else
        echo "Improper param $#"
    fi
}

function scpp {
    if [[ $# -eq 3 ]]; then
        sshpass -p $3 scp -r -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -o 'PasswordAuthentication yes' $1 $2
    else
         echo "Improper param $#"
    fi
}


#**************************************************************************************************#
#                                           Cscope Stuffs                                          #
#**************************************************************************************************#
function bldcs {
    local force=$1
    curr=`pwd`
    if [[ $force == "-f" || ! -f $curr/cscope.files ]]; then
        find $curr -type d \( -name build -o -name thirdparty -o -name test -o -name buildconfig -o -name dpdk \) -prune -false \
            -o -iname "*.c" -o -iname "*.cpp" -o -iname "*.h" -o -iname "*.hh" -o -iname "*.hpp" \
            -o -iname "*.py" -o -iname "*.cc" -o -iname "*.c++" -o -iname "*.proto" -o -iname "*.sh"  \
            -o -iname "*.conf" -o -iname "*.txt" | xargs -I{} readlink -f {} > cscope.files
    fi
    cscope -q -b -i $curr/cscope.files >/dev/null 2>&1
    ctags -L $curr/cscope.files >/dev/null 2>&1
    export CSCOPE_DB=$curr/cscope.out
    export CSTAGPATH=$curr/
}
alias cs='cscope'
export PROMPT_DIRTRIM=1

#**************************************************************************************************#
#                                           Tmux Stuffs                                            #
#**************************************************************************************************#
function tmux-new {
    tmux new -s $1
}

function tmux-attach {
    tmux attach -t $1
}

function tmux-kill {
    tmux kill-session -t $1
}

#**************************************************************************************************#
#                                            LeetCode Stuffs                                       #
#**************************************************************************************************#

alias lt='leetcode'

function lt-show-hard {
    lt list -q hD
}

function lt-show-med {
    lt list -q mD
}

function lt-show {
    lt list -q ED
}

function lt-code {
    lt show $1 -gx -l cpp
}

function lt-test {
    lt test $1 -t $2
}

function lt-submit {
    lt submit $1
}

# To ensure split panes retain same dir
if [[ -f /etc/profile.d/vte-2.91.sh ]]; then
    . /etc/profile.d/vte-2.91.sh
fi
