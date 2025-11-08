#!/bin/bash

# Get current workspaces with windows
if command -v aerospace >/dev/null 2>&1; then
  ALL_WORKSPACES="$(aerospace list-workspaces --all 2>/dev/null)"
  WORKSPACES=""
  
  for ws in $ALL_WORKSPACES; do
    WINDOW_COUNT="$(aerospace list-windows --workspace "$ws" 2>/dev/null | wc -l | tr -d ' ')"
    if [ "$WINDOW_COUNT" -gt 0 ]; then
      WORKSPACES="$WORKSPACES $ws"
    fi
  done
  
  if [ -z "$WORKSPACES" ]; then
    WORKSPACES="$(aerospace list-workspaces --focused 2>/dev/null)"
  fi
  
  # Store current workspaces to compare
  CURRENT_FILE="/tmp/sketchybar_workspaces"
  LAST_WORKSPACES=""
  [ -f "$CURRENT_FILE" ] && LAST_WORKSPACES="$(cat "$CURRENT_FILE")"
  
  # If changed, trigger a reload
  if [ "$WORKSPACES" != "$LAST_WORKSPACES" ]; then
    echo "$WORKSPACES" > "$CURRENT_FILE"
    # Remove all old workspace items
    for old_ws in $LAST_WORKSPACES; do
      sketchybar --remove space.$old_ws 2>/dev/null
    done
    # Trigger workspace rebuild
    "$CONFIG_DIR/items/aerospace_workspaces.sh"
  fi
fi