#!/bin/bash

leetcode cache -d
echo -e "chophi\n`pass LEETCODE`\n" | leetcode user -l
leetcode list >/dev/null 2>&1
