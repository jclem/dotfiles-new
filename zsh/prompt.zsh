setopt PROMPT_SUBST


PROMPT='%F{yellow}⋑ \
%F{blue}%c\
${vcs_info_msg_0_}\
%F{blue} ☛ %f '

autoload -Uz vcs_info

precmd() {
  vcs_info
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats ' %F{cyan}{ %F{red}%b%F{cyan} }%f %F{magenta}%m %a'
zstyle ':vcs_info:*' formats ' %F{cyan}{ %F{red}%b%F{cyan} }%f %c%u'
zstyle ':vcs_info:*' stagedstr '%F{green}S%f%b'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}U%f%b'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

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
