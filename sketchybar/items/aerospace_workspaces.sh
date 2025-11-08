#!/bin/bash

# Add the custom event once
sketchybar --add event aerospace_workspace_change

# Get all possible workspaces
if command -v aerospace >/dev/null 2>&1; then
  WORKSPACES="$(aerospace list-workspaces --all 2>/dev/null)"
else
  WORKSPACES="1 2 3 4 5 A B C D E F M"
fi

for sid in $WORKSPACES; do
  sketchybar --add item space.$sid left \
             --set space.$sid label="$sid" \
                                label.font="sketchybar-app-font:Regular:16.0" \
                                background.drawing=off \
                                background.corner_radius=5 \
                                background.height=24 \
                                drawing=off \
                                update_freq=2 \
                                script="$PLUGIN_DIR/aerospace_ws_item.sh $sid" \
             --subscribe space.$sid aerospace_workspace_change
done