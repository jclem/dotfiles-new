fpath=($ZSH_CONFIG_DIR/completions $fpath)
autoload -U $ZSH_CONFIG_DIR/completions/*(:t)

fpath=($ZSH_CONFIG_DIR/functions $fpath)
autoload -U $ZSH_CONFIG_DIR/functions/*(:t)

if [[ -d $HOME/.config/zsh-functions && -n "$(ls -A $HOME/.config/zsh-functions)" ]]; then
  fpath=($HOME/.config/zsh-functions $fpath)
  autoload -U $HOME/.config/zsh-functions/*(:t)
fi
