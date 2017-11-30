#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${CURRENT_DIR}/scripts/helpers.sh"

readonly pacifier_toggle_key="$(get_tmux_option "@pacifier-toggle-key" "F12")"
readonly pacifier_message="$(get_tmux_option "@pacifier-message" "OFF")"
readonly pacifier_status_enabled="$(get_tmux_option "@pacifier-status-enabled" "1")"

update_tmux_option() {
  local option=$1
  local option_value=$(get_tmux_option "$option")
  local new_option_value="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo '"$pacifier_message"')#[default]" "$option_value"
  tmux set -g "$option" "$new_option_value"
}

main() {
  if [ "$pacifier_status_enabled" -ne 0 ]; then
    update_tmux_option "status-right"
  fi

  tmux bind-key -T root "$pacifier_toggle_key"  \
    set prefix None \;\
    set key-table off \;\
    set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
    set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
    set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
    if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
    refresh-client -S \;\

  tmux bind-key -T off "$pacifier_toggle_key"  \
    set -u prefix \;\
    set -u key-table \;\
    set -u status-style \;\
    set -u window-status-current-style \;\
    set -u window-status-current-format \;\
    refresh-client -S
}
main

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=sh sw=2 ts=2 et
