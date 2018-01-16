# Builtins
alias ls="ls -G"
alias mv="mv -i"

# Git
if $(which hub &>/dev/null); then alias git="hub"; fi
alias gap="git add --patch"
alias gbr="git browse"
alias gcm="git commit"
alias gco="git checkout"
alias gdf="git diff"
alias glg="git lg"
alias gpl="git pull --rebase"
alias gpr="git pull-request"
alias gps="git push"
alias gst="git status"

# Miscellaneous
alias bs="brew services"
alias reload="source ~/.zshrc"
alias vmrun="/Applications/VMware\ Fusion.app/Contents/library/vmrun"
alias ssh-key-add="ssh-add -K ~/.ssh/id_rsa"
