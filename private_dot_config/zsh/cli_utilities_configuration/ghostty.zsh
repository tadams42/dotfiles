# Ghostty specific shell setup. Does nothing in other terminals.
#
# Must be sourced from .zshrc: Ghostty's shell integration reads
# GHOSTTY_SHELL_FEATURES lazily, at the first prompt (_ghostty_deferred_init).

[[ "$TERM_PROGRAM" == "ghostty" && -n "$GHOSTTY_SHELL_FEATURES" ]] || return 0

# The packaged launchers (/usr/share/applications/com.mitchellh.ghostty.desktop and
# /usr/share/dbus-1/services/com.mitchellh.ghostty.service) run Ghostty with
# `--shell-integration-features=ssh-env`. That replaces `no-cursor,no-title` from
# config.ghostty, so the integration would switch the cursor to a bar at every prompt
# and overwrite tab titles. Drop both features here, regardless of how Ghostty was
# started.
GHOSTTY_SHELL_FEATURES=${(j:,:)${(@)${(s:,:)GHOSTTY_SHELL_FEATURES}:#(cursor*|title)}}

# WezTerm-like tab titles: "<process icon> <cwd basename>"
# Mirrors PROCESS_ICONS in ~/.config/wezterm/appearance.lua
typeset -gA _ghostty_tab_icons=(
	docker $''
	docker-compose $''
	kubectl $''
	kuberlr $''
	stern $''
	lazydocker $''
	btm $''
	psql $'\U000f1922'
	usql $'\U000f1922'
	ssh $''
	ssh-add $''
	nvim $''
	vim $''
	make $''
	go $''
	python $''
	python3 $''
	zsh $''
	bash $''
	cargo $''
	sudo $''
	git $''
	lua $''
	gh $''
	ruby $''
)

_ghostty_tab_dir() {
	if [[ "$PWD" == "$HOME" ]]; then
		REPLY='~'
	elif [[ "$PWD" == / ]]; then
		REPLY=/
	else
		REPLY=${PWD:t}
	fi
}

_ghostty_tab_title() {
	_ghostty_tab_dir
	builtin print -rn -- $'\e]2;'"$1 $REPLY"$'\a'
}

_ghostty_tab_precmd() {
	_ghostty_tab_title "${_ghostty_tab_icons[zsh]}"
}

_ghostty_tab_preexec() {
	# Command of the last segment of `a && b; c | d` (the one most likely to stay in
	# foreground, like WezTerm shows), skipping VAR=value assignments.
	local word cmd
	local -a seg
	for word in ${(z)1}; do
		if [[ "$word" == ('&&'|'||'|';'|'&'|'|'|'|&') ]]; then
			seg=()
		else
			seg+=("$word")
		fi
	done
	for word in $seg; do
		[[ "$word" == [[:alpha:]_]*=* ]] && continue
		cmd=${word:t}
		break
	done
	[[ -n "$cmd" ]] || return
	_ghostty_tab_title "${_ghostty_tab_icons[$cmd]:-[$cmd]}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ghostty_tab_precmd
add-zsh-hook preexec _ghostty_tab_preexec
