setopt MENU_COMPLETE # One completion inserted automatically

bindkey -M menuselect '^[[Z' reverse-menu-complete

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' menu select=2                # menu complete w/2+ results
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # smart-casing
zstyle ':completion:*' list-colors ''               # show colors in list
zstyle ':completion:*' use-cache on                 # caching
zstyle ':completion:*' cache-path ~/.zshcache
zstyle ':completion:*:descriptions' format "$fg[blue]Completing:$reset_color %d"
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
