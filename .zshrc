# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/pertz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)


# =============================================================================

function cd() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _files -/
        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Send '\e[0n' to console input.
            \builtin printf '\e[5n'
        fi

        # Report that the completion was successful, so that we don't fall back
        # to another completion function.
        return 0
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================

stty stop undef         # Disable ctrl-s to freeze terminal.

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

 # Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"


## enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
# alias ll='ls -l'
# alias lla='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

#set -o vi
export KEYTIMEOUT=1


# Define the userpart section of the prompt
local userpart='%F{green}%n@%m%f:'

# autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst
# RPROMPT='${vcs_info_msg_0_}'
# PROMPT='${vcs_info_msg_0_}%# '
# zstyle ':vcs_info:git:*' formats '%b'

# Combine all the parts to form the PS1 prompt
PROMPT='${userpart}%F{blue}%~%F{red}${vcs_info_msg_0_}%f$ '
#setopt PROMPT_SUBST ; PS1='[%F{green}%n@%m %F{blue}%c%F{red}$(__git_ps1 " (%s)")%f]\$ '
#ZSH:  precmd () { __git_ps1 "%n" ":%~$ " "|%s" }
#PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
setopt PROMPT_SUBST ; PS1='[%F{green}%n@%m%f:%F{blue}%~%F{red}$(__git_ps1 "(%s)")%f]\$ '

alias weather='curl "wttr.in/Jyväskylä"'
alias todo='nvim ~/.todo.md'
alias ls='eza --color always --group-directories-first --git --git-repos'
alias ll='eza -l --icons --color always --group-directories-first --git --git-repos'
alias lla='eza -alF --icons --color always --group-directories-first --git --git-repos'
alias la='ls -A --color always --group-directories-first --git --git-repos'

#============================================================================#

eval "$(zoxide init zsh)"

export PATH="$PATH:/opt/nvim/"
export MANPAGER='less -s -M +Gg'
export PAGER='less'
export LESS='-R'
# Get color support for 'less'
#export LESS="--RAW-CONTROL-CHARS"
# Use colors for less, man, etc.
#[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 7; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 1)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1

source ~/.git-prompt.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
