#!/bin/bash

sketchybar --add item calendar right \
           --set calendar icon=􀧞  \
                          label.width=160 \
                          label.align=left \
                          update_freq=1 \
                          script="$PLUGIN_DIR/calendar.sh"