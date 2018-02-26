setopt PROMPT_SUBST

PROMPT='%F{yellow}⋑ \
%F{blue}%c\
$(hostname)\
${vcs_info_msg_0_}\
%F{blue} ☛ %f '

autoload -Uz vcs_info

precmd() {
  vcs_info
}

if [[ -v CHECK_GIT ]]; then
  zstyle ':vcs_info:*' check-for-changes true
else
  zstyle ':vcs_info:*' check-for-changes false
fi

zstyle ':vcs_info:*' actionformats ' %F{cyan}{ %F{red}%b%F{cyan} }%f %F{magenta}%m %a'

if [[ -v CHECK_GIT ]]; then
  zstyle ':vcs_info:*' formats ' %F{cyan}{ %F{red}%b%F{cyan} }%f %c%u'
else
  zstyle ':vcs_info:*' formats ' %F{cyan}{ %F{red}%b%F{cyan} }%f '
fi

zstyle ':vcs_info:*' stagedstr '%F{green}S%f%b'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}U%f%b'

if [[ -v CHECK_GIT ]]; then
  zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
else
  zstyle ':vcs_info:git*+set-message:*' hooks
fi

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':  %c
function +vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | fgrep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[unstaged]+='%F{red}?%f%b'
    fi
}

function hostname() {
  if [ -n "$SSH_CONNECTION" ]; then
    echo ' %F{yellow}[%n@%m]'
  fi
}
