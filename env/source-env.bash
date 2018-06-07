#!/bin/bash
ENVDIR=$HOME/vif/env-scripts

declare -a variable
counter=0
for name in `ls $ENVDIR`; do
    if [ -d "$ENVDIR/$name" ] && [ -f "$ENVDIR/$name/setenv.sh" ]; then
        env_file=$ENVDIR/$name/setenv.sh
        variable[$counter]="$name: . $env_file"
        ((++counter))
    fi
done

run_item_in_menu "${variable[@]}"

unset variable
unset counter
unset env_file

