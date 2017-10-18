# Vi mode settings
# Much of this from https://dougblack.io/words/zsh-vi-mode.html

bindkey -v # Enable vi mode

bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey -M viins 'kj' vi-cmd-mode # Type kj to enter normal mode
bindkey -M vicmd v edit-command-line # Type `v` in normal mode for vim editing
