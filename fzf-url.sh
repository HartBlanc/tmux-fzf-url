#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-06 12:12
#===============================================================================
get_fzf_options() {
    local fzf_options
    local fzf_default_options='-d 35% -m -0 --no-preview --no-border'
    fzf_options="$(tmux show -gqv '@fzf-url-fzf-options')"
    [ -n "$fzf_options" ] && echo "$fzf_options" || echo "$fzf_default_options"
}

fzf_filter() {
  eval "fzf-tmux $(get_fzf_options)"
}

limit='screen'
[[ $# -ge 2 ]] && limit=$2

if [[ $limit == 'screen' ]]; then
    content="$(tmux capture-pane -J -p)"
else
    content="$(tmux capture-pane -J -p -S -"$limit")"
fi

mapfile -t paths < <(echo "$content" | python $(dirname $0)/fzf-url.py) 

items=$(printf '%s\n' "${paths[@]}" |
    grep -v '^$' |
    sort -u |
    nl -w3 -s '  '
)
[ -z "$items" ] && tmux display 'tmux-fzf-url: no Paths found' && exit

mapfile -t chosen < <(fzf_filter <<< "$items" | awk '{$1=""; print $0}')

if [ ${#chosen[@]} -ne 0 ]; then
    shopt -s extglob                           # turn on extended glob
    chosen=( "${chosen[@]/#+([[:blank:]])/}" ) # remove leading space/tab from each element
    vi "${chosen[@]}"
fi


