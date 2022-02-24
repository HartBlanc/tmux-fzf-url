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

open_url() {
    vi "$@"
}


limit='screen'
[[ $# -ge 2 ]] && limit=$2

if [[ $limit == 'screen' ]]; then
    content="$(tmux capture-pane -J -p)"
else
    content="$(tmux capture-pane -J -p -S -"$limit")"
fi

mapfile -t paths < <(echo "$content" | grep -oE '(^| )[a-zA-Z_\/-]*(\/[a-zA-Z_\/-]*|\.[a-zA-Z_\/-])($| )' | xargs ) 

items=$(printf '%s\n' "${paths[@]}" |
    grep -v '^$' |
    sort -u |
    nl -w3 -s '  '
)
[ -z "$items" ] && tmux display 'tmux-fzf-url: no URLs found' && exit

mapfile -t chosen < <(fzf_filter <<< "$items" | awk '{print $2}')

for item in "${chosen[@]}"; do
    open_url "$item" &>"/tmp/tmux-$(id -u)-fzf-url.log"
done
