#!/usr/bin/zsh

setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt AUTO_MENU            # Show completion menu on a successive tab press.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB        # Needed for file modification glob modifiers with compinit.
unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.

# TODO: integrate `carapace-bin` as a source of completers.
# We rely only on ZSH completers (provided by packages that we install on system).
# Carapace has it's own completers library, and is blazingly fast. Additionally, it can
# transparently fall-back to ZSH completer for contexts where it doesn't have it's own.
#
# All this sounds great, but last time we'd tried integrating it, some completions
# stopped working. Trtying to fix completions' configuration quickly spiraled into
# unreadable chaos; and it didn't solve the problem.
#
# Example scenario that stopped working:
#
# ```sh
# $ mkdir -p /tmp/example/foo_own /tmp/example/bar_own
# $ cd /tmp/example
# $ ls own<TAB>
# ... some kind of error message and no matches found
# ```

setup_completions() {
    # Most of this is copied from Prezto, but cleaned up from so it doesn't depend on
    # it.
    local ZSH_COMP_DUMP_FILE="${HOME}/.cache/zsh/zcompdump"
    autoload -Uz compinit

    # `-d` is used to:
    #   - tell `compinit` to use "compiled" definitions file
    #   - tell `compinit` to use specific path for that file
    compinit -d "${ZSH_COMP_DUMP_FILE}"

    local COMPLETION_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}
    zstyle ':completion:*:default' list-colors ${(s.:.)COMPLETION_COLORS}

    zstyle ':completion:*:default' list-prompt '%S%M matches%s'

    # Use caching to make completion for commands such as dpkg and apt usable.
    # Note that this cache is rarely or almost never invalidated. It is possible to create
    # custom cache policy for this cache and let shell check that, but for most use cases it
    # is overkill. Instead, just delete cache file when you really need to invalidate the
    # cache.
    local ZSH_COMP_CACHE_DIR="${HOME}/.cache/zsh/zcompcache"
    zstyle ':completion::complete:*' use-cache on
    zstyle ':completion::complete:*' cache-path "${ZSH_COMP_CACHE_DIR}"

    # Case-insensitive (all), partial-word, and then substring completion.
    zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    setopt CASE_GLOB
    # or, case sensitive
    # zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:upper:]}={[:lower:]}'  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    # unsetopt CASE_GLOB

    # Group matches and describe.
    zstyle ':completion:*:*:*:*:*' menu select
    zstyle ':completion:*:matches' group 'yes'
    zstyle ':completion:*:options' description 'yes'
    zstyle ':completion:*:options' auto-description '%d'
    zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
    zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
    zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
    zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
    zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*' verbose yes

    # Fuzzy match mistyped completions.
    zstyle ':completion:*' completer _complete _match _approximate
    zstyle ':completion:*:match:*' original only
    zstyle ':completion:*:approximate:*' max-errors 1 numeric

    # Increase the number of errors based on the length of the typed word. But make
    # sure to cap (at 7) the max-errors to avoid hanging.
    zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

    # Don't complete unavailable commands.
    zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

    # Array completion element sorting.
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

    # Directories
    zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
    zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
    zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
    zstyle ':completion:*' squeeze-slashes true

    # History
    zstyle ':completion:*:history-words' stop yes
    zstyle ':completion:*:history-words' remove-all-dups yes
    zstyle ':completion:*:history-words' list false
    zstyle ':completion:*:history-words' menu yes

    # Environment Variables
    # This is very old hack, not needed on modern ZSH versions
    # zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

    # Allow .. to be completed
    zstyle ':completion:*' special-dirs true
    # This allows cd ../<TAB> to work smoothly
    zstyle ':completion:*:cd:*' ignore-parents parent pwd

    # Following does a bit of cleanup magic for completing host names and user names. Prezto
    # specific things had been replaced by `zstyle ':completion:*:hosts' etc-host-ignores`
    # instruction.
    #
    # 1. The Hostname Scraper
    #    The first zstyle -e block is the most complex. It dynamically populates the list of
    #    hosts by "scraping" several files on your system.
    #
    #    - SSH Known Hosts: It reads /etc/ssh/ssh_known_hosts and ~/.ssh/known_hosts. The
    #      nested parameter expansions (the ${=${=...}} mess) are there to strip out port
    #      numbers, brackets, and comments so you get clean hostnames or IP addresses.
    #    - The Hosts File: It reads /etc/hosts and even tries to pull from NIS (ypcat
    #      hosts).
    #    - Custom Ignores: The line _etc_host_ignores allows you to define specific patterns
    #      in your .zshrc that you don't want to see from your /etc/hosts file (like local
    #      loopbacks you never use).
    #    - SSH Config: It looks at ~/.ssh/config for lines starting with Host, but it
    #      intelligently filters out wildcards (* or ?) because you can't "connect" to a
    #      wildcard.
    #
    # 2. The User Filter
    #    The zstyle ':completion:*:*:*:users' ignored-patterns block is a quality-of-life
    #    feature.
    #
    #    When you type ssh  or su  and hit Tab, you usually want to log in as a real person
    #    (like alice or bob), not a system service. This list explicitly hides "service
    #    accounts" that exist on almost every Unix system but are never used for interactive
    #    logins.
    #
    #    By ignoring apache, mysql, daemon, etc., your completion list remains short and
    #    relevant to your actual work.
    #
    # 3. The "Safety Valve"
    #    zstyle '*' single-ignored show
    #
    #    This is a clever bit of UX. Normally, if Zsh filters everything out and there is
    #    only one "ignored" match left, it might show nothing. This setting says: "If I've
    #    typed something that matches an ignored pattern, and it's the only match, show it
    #    anyway."
    #
    #    Example: If you actually did need to log in as the postgres user for database
    #    maintenance, Zsh won't hide it from you if it's the only logical thing you could be
    #    typing.

    # 1. Define hosts to ignore (optional)
    # You can add patterns here that you don't want to see in your completion list.
    zstyle ':completion:*:hosts' etc-host-ignores 'localhost' 'ip6-loopback' 'ip6-allnodes'
    # 2. Extract the ignore list into a variable
    zstyle -a ':completion:*:hosts' etc-host-ignores '_etc_host_ignores'

    zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
    )'

    # Don't complete uninteresting users...
    zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
    hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    mailman mailnull mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

    # ... unless we really want to.
    zstyle '*' single-ignored show





    # Ignore multiple entries.
    zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
    zstyle ':completion:*:rm:*' file-patterns '*:all-files'

    # Kill
    zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
    zstyle ':completion:*:*:kill:*' menu yes select
    zstyle ':completion:*:*:kill:*' force-list always
    zstyle ':completion:*:*:kill:*' insert-ids single

    # Man
    zstyle ':completion:*:manuals' separate-sections true
    zstyle ':completion:*:manuals.(^1*)' insert-sections true

    # SSH/SCP/RSYNC
    zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
    zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
    zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
}

setup_completions
unfunction setup_completions
