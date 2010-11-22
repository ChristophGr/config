# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
#if [[ $- != *i* ]] ; then
#	# Shell is non-interactive.  Be done now!
#	return
#fi
source /etc/profile

# Put your fun stuff here.

# to fix line-wrap-issue
shopt -s checkwinsize

export LC_TIME="de_DE.UTF-8"

#alias sshhome="ssh profalbert.dyndns.org"
#alias sshg0="ssh ffp0525747@g0.complang.tuwien.ac.at"

alias qg="qgit4 --all"
alias cp2="rsync -rhv --progress"
alias mci="mvn clean install -Dmaven.test.skip=true"
alias n.="nautilus ."
alias lse="ls | egrep"
alias gru="git remote update origin -p"
alias gph="git push origin HEAD"


PATH=/usr/sbin:/sbin:$PATH

export GIT_PS1_SHOWDIRTYSTATE=1

function set_git_branch {
	__git_ps1 | sed s/" ("/"\["/ | sed s/")"/"\]"/
}

MAX_LENGTH=30
function truncate_dirname {
  local EXPR=$(echo "^$HOME" | sed -r 's/\//\\\//g')
  local DIR=$(echo $1 | sed -r s/"$EXPR"/"~"/)
  local LENGTH=$(echo $DIR | wc -m)
  if [ $LENGTH -gt $MAX_LENGTH ]; then
    let START=$LENGTH-$MAX_LENGTH
    local SHORT=$(echo $DIR | cut -c $START-$LENGTH)
    echo ..$SHORT
  else
    echo $DIR
  fi
}

if [ "$EUID" != "0" ]; then
	export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] $(truncate_dirname "\w")\[\033[0;33m\]$(set_git_branch)\[\033[01;34m\] \$\[\033[0m\] '
else
	export PS1='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

function title {
    if [ "$PWD" == "$HOME" ]; then
        echo "~"
    else
        local P=$(echo $PWD | sed -r s/"\/.*\/"//)
        echo $P
    fi
}
if [ -n "$DISPLAY" ]; then
    PROMPT_COMMAND='echo -ne "\033]0; $(title) -> Term\007"'
fi

export EDITOR=/bin/vi

export SERVICEMIX_HOME=/home/profalbert/mytools/servicemix4
export EXIST_HOME=/home/profalbert/mytools/eXist

export PATH="$HOME/mytools/bin:$PATH"


# Usage .. [n]
# Go up n-levels.
function .. (){
  local arg=${1:-1};
  local dir=""
  while [ $arg -gt 0 ]; do
    dir="../$dir"
    arg=$(($arg - 1));
  done
  cd $dir #>&/dev/null
}

# Usage ... Thing/Some
# Go up until you encounter Thing/Some, then go there
function ... (){
  if [ -z "$1" ]; then
    return
  fi
  local maxlvl=16
  local dir=$1
  while [ $maxlvl -gt 0 ]; do
      dir="../$dir"
      maxlvl=$(($maxlvl - 1));
      if [ -d "$dir" ]; then
        cd "$dir" #>&/dev/null
        return
      fi
  done
}

function _pathelem(){
	local IFS=$'\n'
	if [ "$1" != "$3" ]; then # there already is an argument
		return
	fi
	# sed1: remove current folder
	# sed2: add backslashes to escape whitespaces
	# sed3: split the path
  local pardirs=$(pwd | sed -r s/"\/[^\/]+$"// | sed s/" "/'\\\\ '/g | sed s/"\/"/"\n"/g)
	cur=$(echo ${COMP_WORDS[COMP_CWORD]} | sed s/"\\\\"/"\\\\\\\\\\\\"/)
	# 12! backslashes, srsly?
  COMPREPLY=($(compgen -W "$pardirs" -- $cur))
}

complete -F _pathelem ...
