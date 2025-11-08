#!/bin/bash

# This runs on every aerospace workspace change event
# It checks if the list of workspaces with windows has changed

if command -v aerospace >/dev/null 2>&1; then
  # Get current workspaces with windows
  ALL_WORKSPACES="$(aerospace list-workspaces --all 2>/dev/null)"
  CURRENT_WORKSPACES=""
  
  for ws in $ALL_WORKSPACES; do
    WINDOW_COUNT="$(aerospace list-windows --workspace "$ws" 2>/dev/null | wc -l | tr -d ' ')"
    if [ "$WINDOW_COUNT" -gt 0 ]; then
      CURRENT_WORKSPACES="$CURRENT_WORKSPACES $ws"
    fi
  done
  
  if [ -z "$CURRENT_WORKSPACES" ]; then
    CURRENT_WORKSPACES="$(aerospace list-workspaces --focused 2>/dev/null)"
  fi
  
  # Compare with cached list
  CACHE_FILE="/tmp/sketchybar_aerospace_workspaces"
  LAST_WORKSPACES=""
  [ -f "$CACHE_FILE" ] && LAST_WORKSPACES="$(cat "$CACHE_FILE")"
  
  # If workspace list changed, rebuild
  if [ "$CURRENT_WORKSPACES" != "$LAST_WORKSPACES" ]; then
    echo "$CURRENT_WORKSPACES" > "$CACHE_FILE"
    
    # Remove old workspace items
    for ws in $LAST_WORKSPACES; do
      sketchybar --remove space.$ws 2>/dev/null
    done
    
    # Rebuild workspace items
    source "$CONFIG_DIR/items/aerospace_workspaces.sh"
  fi
fi