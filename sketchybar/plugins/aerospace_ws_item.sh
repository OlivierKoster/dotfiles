#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE}"

# Check if this workspace has any windows
if command -v aerospace >/dev/null 2>&1; then
  WINDOW_COUNT="$(aerospace list-windows --workspace "$SID" 2>/dev/null | wc -l | tr -d ' ')"
  
  # Hide workspace if empty
  if [ "$WINDOW_COUNT" -eq 0 ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
  else
    sketchybar --set "$NAME" drawing=on
  fi
fi

# Highlight focused workspace
if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=off \
                           icon.color=$ACCENT_COLOR \
                           label.color=$ACCENT_COLOR
else
  sketchybar --set "$NAME" background.drawing=off \
                           icon.color=$WHITE \
                           label.color=$WHITE
fi

# Show app icons
if command -v aerospace >/dev/null 2>&1; then
  APPS="$(aerospace list-windows --workspace "$SID" 2>/dev/null | awk -F'|' '{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u)"
  
  ICONS=""
  if [ -n "$APPS" ]; then
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      ICON="$("$CONFIG_DIR"/plugins/icon_map_fn.sh "$app")"
      ICONS+="$ICON "
    done <<< "$APPS"
  fi
  
  sketchybar --set "$NAME" icon="$SID" \
                           icon.padding_right=8 \
                           label="$ICONS"
fi