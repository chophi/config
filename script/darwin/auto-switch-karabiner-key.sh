#!/bin/bash

external_keyboard_exist=`system_profiler SPUSBDataType | grep "Rapoo Gaming Keyboard"`
external_keyboard_exist2=`system_profiler SPUSBDataType | grep "CHERRY"`

if [ -z "$external_keyboard_exist" ] && [ -z "$external_keyboard_exist2" ]; then
    echo "switch to use configuration for internal keyboard"
    cp $HOME/vif/karabiner-internal.json ~/.karabiner.d/configuration/karabiner.json
else
    echo "switch to use configuration for external keyboard"
    cp $HOME/vif/karabiner-external.json ~/.karabiner.d/configuration/karabiner.json
fi
