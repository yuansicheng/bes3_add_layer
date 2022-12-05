#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author    :   yuansc
# @Contact   :   yuansicheng@ihep.ac.cn
# @Date      :   2022-11-20

import os, sys, logging

this_path = os.path.dirname(__file__)
if this_path not in sys.path:
    sys.path.append(this_path)

for lh in range(0,21,5):
# for lh in [20]:
    cmd = 'python gen2root.py --lh {}'.format(lh)
    os.system(cmd)