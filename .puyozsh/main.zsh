setopt no_nullglob
setopt no_nomatch
setopt PROMPT_SUBST
puyo-color () {
        case "$1" in
                black-bg)
                        echo -n "%K{black}"
                        ;;
                black-fg)
                        echo -n "%F{black}"
                        ;;
                red-bg)
                        echo -n "%K{red}"
                        ;;
                red-fg)
                        echo -n "%F{red}"
                        ;;
                green-bg)
                        echo -n "%K{green}"
                        ;;
                green-fg)
                        echo -n "%F{green}"
                        ;;
                yellow-bg)
                        echo -n "%K{yellow}"
                        ;;
                yellow-fg)
                        echo -n "%F{yellow}"
                        ;;
                blue-bg)
                        echo -n "%K{blue}"
                        ;;
                blue-fg)
                        echo -n "%F{blue}"
                        ;;
                magenta-bg)
                        echo -n "%K{magenta}"
                        ;;
                magenta-fg)
                        echo -n "%F{magenta}"
                        ;;
                cyan-bg)
                        echo -n "%K{cyan}"
                        ;;
                cyan-fg)
                        echo -n "%F{cyan}"
                        ;;
                white-bg)
                        echo -n "%K{white}"
                        ;;
                white-fg)
                        echo -n "%F{white}"
                        ;;
                reset-bg)
                        echo -n "%k"
                        ;;
                reset-fg)
                        echo -n "%f"
                        ;;
        esac
}
puyo-parse-git-branch () {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
puyo-parse-git-state () {
    if [ -z "$(git status --porcelain)" ]; then
        GIT_STATE=""
    else
        GIT_STATE="$(git status --porcelain | wc -l)"
    fi
    if [ ! -z "$GIT_STATE" ]; then
        echo " $GIT_STATE"
    fi
}
puyo-module-user () {
        puyo-color $(echo "$PUYO_COLOR_USER"-fg)
        echo -n "%n"
}
puyo-module-pwd () {
    puyo-color $(echo "$PUYO_COLOR_PWD"-fg)
    case $PWD in
        $HOME*)
            DIR_PREPEND="~/"
            TRUNICATE_NUM=5
            ;;
        *)
            DIR_PREPEND=""
            TRUNICATE_NUM=3
            ;;
    esac
    if [ $(echo "$PWD" | cut -f${TRUNICATE_NUM}- -d'/' | wc -c) -gt 20 ]; then
        DIR_ENDING="$(echo "$PWD" | rev | cut -f1-2 -d'/' | rev)"
        echo -n "$DIR_PREPEND.../$DIR_ENDING"
    else
        echo -n "%~"
    fi
}
puyo-module-git () {
    puyo-color $(echo "$PUYO_COLOR_GIT"-fg)
    local git_where="$(puyo-parse-git-branch)"
    [ -n "$git_where" ] && echo -n "ʮ ${git_where#(refs/heads/|tags/)}$(puyo-parse-git-state)"
}
puyo-module-jobs () {
        puyo-color $(echo "$PUYO_COLOR_JOBS"-fg)
        echo -n "%j"
}
puyo-prompt () {
exitstat="$?"
for i in ${(s. .)CONFIG_ORDER}; do
        eval "puyo-module-$i"
        puyo-color reset-fg
        echo -n "$PROMPT_SPACER"
done
echo -n "$PROMPT_TAIL"
echo -n "%f%k"
}
puyo-right-prompt () {
exitstat="$?"
for i in ${(s. .)RCONFIG_ORDER}; do
        eval "puyo-module-$i"
        puyo-color reset-fg
        echo -n "$PROMPT_SPACER"
done
echo -n "%f%k"
}

setopt histignorealldups sharehistory menu_complete

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=5
zstyle ":completion:*:descriptions" format "%B%d%b"
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
PS1=$'$(puyo-prompt)'
RPS1=$'$(puyo-right-prompt)'
