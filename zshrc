################################################xxx
# zsh configuration file - Pál Pintér -2015
# revisited and updated 2019.05.12
################################################xxx

autoload -U colors && colors
setopt AUTO_CD
setopt CORRECT_ALL
setopt NOFLOWCONTROL

# compinit staff
###################################################
autoload -U compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:::::' completer _expand _complete _ignored _approximate
zmodload -i zsh/complist

# set history
###################################################
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# dirstack
###################################################
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20

setopt AUTOPUSHD 
setopt PUSHDSILENT 
setopt PUSHDTOHOME
setopt PUSHDIGNOREDUPS
setopt PUSHDMINUS

# set default editor
###################################################
if [[ $DISPLAY = ""  ]]; then
  export EDITOR=nano
else
  export EDITOR=code
fi

# key bindings
###################################################
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# plugins
###################################################
source ~/.zsh_plugins.sh
alias update-zsh-plugins="antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh && source ~/.zshrc"

# prompt stuff
###################################################
#autoload -U promptinit && promptinit
#PROMPT="%{$fg[green]%}%m:%{$reset_color%}%{$fg_no_bold[yellow]%}%~ %# %{$reset_color%}"
#RPROMPT="%{$fg[blue]%}[%T]%{$reset_color%}"
# Theme
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  line_sep
  git
  char          # Prompt character
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_COLOR=blue
SPACESHIP_CHAR_SYMBOL="$"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_HOST_SHOW=always
SPACESHIP_USER_SHOW=always
SPACESHIP_USER_COLOR=green
SPACESHIP_GIT_STATUS_AHEAD=
SPACESHIP_GIT_STATUS_BEHIND=
SPACESHIP_DIR_COLOR=yellow
SPACESHIP_DIR_LOCK_COLOR=red

# aliases

# Package commands
function ins() {
  yay -S $@
  rehash
}
function upd() {
  sudo pacman -Syu
  yay -Syu
  rehash
}
function pks() {
  yay $@
  rehash
}

# Global aliases
alias -g L="|less"
alias -g G="|grep -i"
alias -g hol="find . G"
alias -g NUL="> /dev/null 2>&1"

# Directory commands
alias d='cd ~/Dokumentumok && ls'
alias f='cd ~/Fejlesztés && ls'
alias l='cd ~/Letöltések && ls'
alias z='cd ~/Zenék && ls'
alias v='cd ~/Videók && ls'
alias dirs="dirs -v"

# ls aliases
alias ls='ls --color'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias ld='ls -d *(/)'

alias x='exit'
alias .='cd .. && ls'
alias h='cd ~ && ls'
alias md='mkdir -p'
alias rd='rm -R'

alias e="$EDITOR"
alias militia="rdesktop -g 1024x768 -r disk:share=/home/palpinter system1.militia.hu:20190"

# source /usr/share/nvm/init-nvm.sh

