#!/usr/bin/env python
import os
import subprocess
import sys
import re
import os
import copy
import shutil

def check(libs):
    new = []
    for name in libs:
        if not os.path.exists(name):
            print("Error: {0} doesn't exist".format(name))
            continue
        out = subprocess.check_output("readelf -d {0}".format(name).split(' '))
        out = re.findall(r"\(NEEDED\) *Shared library: \[(.*)\]", out, re.MULTILINE)
        for maybe_new in out:
            if maybe_new in libs:
                continue
            new.append(maybe_new)
    return new


if __name__ == "__main__":
    base = sorted(list(set(copy.copy(sys.argv[1:]))))
    base_name = '_'.join(base)
    new = check(base)
    while new:
        base.extend(copy.copy(new))
        base = list(set(base))
        new = check(new)
    # base = list(filter(lambda x: x not in sys.argv[1:], base))
    print("Final dependency is {0}".format(base))
    root_dir = os.path.expanduser("~/tmp/{p}".format(p=base_name))
    if not os.path.exists(root_dir):
        os.makedirs(root_dir)
    for name in base:
        to_path = os.path.join(root_dir, name)
        if not os.path.exists(os.path.dirname(to_path)):
            os.makedirs(os.path.dirname(to_path))
        shutil.copyfile(name, to_path)
