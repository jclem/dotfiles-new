fpath=($ZSH_CONFIG_DIR/completions $fpath)
autoload -U $ZSH_CONFIG_DIR/completions/*(:t)

fpath=($ZSH_CONFIG_DIR/functions $fpath)
autoload -U $ZSH_CONFIG_DIR/functions/*(:t)
