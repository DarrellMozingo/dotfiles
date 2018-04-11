#!/bin/bash

laptop_screen="eDP-1-1"

left_screen="DP-1-2"
left_state_file="/sys/class/drm/card1-DP-2/status"
left_prev_state="initial"

right_screen="HDMI-1-1"
right_state_file="/sys/class/drm/card1-HDMI-A-1/status"
right_prev_state="initial"

function handle_mode_change {
  left_curr_state=$(cat $left_state_file)
  right_curr_state=$(cat $right_state_file)

  if [ $left_prev_state = $left_curr_state ] && [ $right_prev_state = $right_curr_state ]; then
    return
  fi

  left_prev_state=$left_curr_state
  right_prev_state=$right_curr_state

  echo "Left screen ($left_screen): $left_curr_state; Right screen ($right_screen): $right_curr_state"

  if [ $left_curr_state = connected ] && [ $right_curr_state = connected ]; then
    /usr/bin/xrandr --output $laptop_screen --auto --primary --below $right_screen --output $left_screen --auto --left-of $right_screen --output $right_screen --auto
  elif [ $left_curr_state = connected ] && [ $right_curr_state = disconnected ]; then
    /usr/bin/xrandr --output $laptop_screen --auto --primary --below $left_screen --output $left_screen --auto --output $right_screen --off
  elif [ $left_curr_state = disconnected ] && [ $right_curr_state = connected ]; then
    /usr/bin/xrandr --output $laptop_screen --auto --primary --below $right_screen --output $left_screen --off --output $right_screen --auto
  else
    /usr/bin/xrandr --auto
  fi
}

while true; do
  handle_mode_change
  sleep 3
done
