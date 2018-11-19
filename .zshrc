setopt no_nullglob
setopt no_nomatch
setopt PROMPT_SUBST

puyo_prefix_color="white"
puyo_dir_prefix=" at "
puyo_git_prefix=" on "

puyo-color () {
	echo -n "%F{yellow}"
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
PARSE-GIT-BRANCH () {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
PARSE-GIT-STATE () {
    if [ -z "$(git status --porcelain)" ]; then
        GIT_STATE=""
    else
        GIT_STATE="$(git status --porcelain | wc -l)"
    fi
    if [ ! -z "$GIT_STATE" ]; then
        echo "$GIT_STATE"
    fi
}
puyo-git () {
    local git_where="$(PARSE-GIT-BRANCH)"
    [ -n "$git_where" ] && echo -n "ʮ ${git_where#(refs/heads/|tags/)} $(PARSE-GIT-STATE)"
}
puyo-dir () {
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
puyo-text () {
	echo -n "$@"
}
puyo-user() {
	echo -n "%n"
}
puyo-left-prompt () {
	puyo-color red-fg
	puyo-text "%% "
	puyo-color cyan-fg
	puyo-user
	puyo-color white-fg
	puyo-text " at "
	puyo-color yellow-fg
	puyo-dir
	puyo-color white-fg
	puyo-text " "
	puyo-git
	puyo-color green-fg
	puyo-text "> "
}
puyo-right-prompt () {
}
CLEAR_COLOR () {
	echo -n "%f%k"
}
PS1='$(puyo-left-prompt)$(CLEAR_COLOR)'
RPS1='$(puyo-right-prompt)$(CLEAR_COLOR)'
