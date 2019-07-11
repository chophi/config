#!/bin/bash

function _in_array {
    local IFS='
'
    local c="$1"
    shift
    local menu_items=($@)
    local index=0
    for x in "${menu_items[@]}"; do
        if [ "$c" == "$x" ]; then
            return $index
        fi
        ((++index))
    done
    return 254
}

function select_from_menu {
    local IFS='
'
    local menu_items=($@)
    if [ ${#menu_items[@]} -eq 0 ]; then
        echo "no menu_items, exiting!!"
        return 254
    fi
    local index=0
    while [ $index -lt ${#menu_items[@]} ]; do
        local menu_content="${menu_items[$index]}"
        if [ -n "`echo $menu_content | grep \":\"`" ]; then
            menu_content=`echo $menu_content | cut -d ':' -f 1`
        fi
        echo -e "$index: $menu_content"
        ((++index))
    done

    local choice
    read choice
    if [ "$choice" -eq "$choice" ] 2>/dev/null; then
        if [ $choice -ge 0 ] && [ $choice -lt ${#menu_items[@]} ]; then
            return $choice
        fi
    else
        _in_array "$choice" "${menu_items[@]}"
        local ret=$?
        if [ $ret -ne 254 ]; then
            return $ret
        else
            echo "Irlegal choice, should be either index or menu item"
            return 254
        fi
    fi

}

function run_item_in_menu {
    local original_ifs=$IFS
    local IFS='
'
    local menu_items=($@)
    local has_colon=2
    local this_item_has_colon=2
    for x in "${menu_items[@]}"; do
        if [ -n "`echo $x | grep \":\"`" ]; then
            this_item_has_colon=1
        else
            this_item_has_colon=0
        fi
        if [ $this_item_has_colon -ne $has_colon ] && [ $has_colon -ne 2 ]; then
            echo "The format of items is not unified, exiting!!"
            return 1
        fi
        has_colon=$this_item_has_colon
    done
    select_from_menu "${menu_items[@]}"
    local index=$?
    IFS=$original_ifs
    if [ $index -ne 254 ]; then
        local command=${menu_items[$index]}
        if [ $has_colon -eq 1 ]; then
            command="`echo $command | cut -d ':' -f 2-`"
        fi
        command=`echo $command`
        echo "run: $command"
        eval $command
    else
        echo "invalid selection, do nothing"
    fi
}

function repeat {
    local times=$1
    local i
    shift 1
    for ((i=1; i<=$times; ++i)) do
        $@
    done
}
