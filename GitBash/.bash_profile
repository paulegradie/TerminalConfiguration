#!/usr/bin/env bash

# notes
# to sys var points to shims and bin, then needs to have shims in path to call python


# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/c/Users/paule/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
# export BASH_IT_THEME='bobby'
export BASH_IT_THEME='pubily'
export PROMPT_DIRTRIM=1

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh


echo "BashRC sourced"

## Custom additions below
source ~/TerminalConfiguration/GitBash/.aliases
source ~/TerminalConfiguration/GitBash/.functions

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'TAB:complete'

# set things
set backspace=indent,eol,start

# Export things
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# connect to github
cd ~/.ssh/

# ssh-agent auto-launch (0 = agent running with key; 1 = w/o key; 2 = not run.)
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
echo "Starting the ssh-agent..."
eval $(ssh-agent -s)

if ls ~/.ssh/*id_rsa 1> /dev/null 2>&1; then
  IDS=$(ls ~/.ssh/*id_rsa || "noids")
  for id in $IDS;
     do
      echo "Current ssh key id: ${id}"
      if [ $agent_run_state = 2 ]; then

        ssh-add ${id}
      elif [ $agent_run_state = 1 ]; then
        ssh-add ${id}
      fi
    done;
fi

cd ~

if [[ "$OSTYPE" == "darwin"* ]]; then     # Mac OSX
  set up pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PATH="/c/Users/paule/.pyenv/libexec:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    echo "Trying pyenv init"
    eval "$(pyenv init -)"
  fi
elif [[ "$OSTYPE" == "msys" ]]; then  # Windows aliases
  # export PATH="/c/cygwin64/home/paule/build-gcc/gcc:$PATH"
  export SHELL="/c/Program Files/Git/usr/bin/bash.exe"
  echo "Current SHELL is : ${SHELL}"
fi

# export PIPENV_VENV_IN_PROJECT='true'
export PYTHONDONTWRITEBYTECODE=1

# set up yarn for node
export YARNPATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

export PS1="\w\d\@\t\T\u "
echo ""

# Run to set virtual env to project dir
echo "Trying to set poetry virtualenv.in-project to true..."
poetry config virtualenvs.in-project true
echo ""
echo "Bash Profile successfully sourced"

if [[ $host == "DESKTOP-TMVOCH8" ]]; then  # work computer
  cd ~/Documents/code
fi

if [[ $host == "RegEx" ]]; then  # work computer
  cd D:/code
fi
