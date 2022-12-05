#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author    :   yuansc
# @Contact   :   yuansicheng@ihep.ac.cn
# @Date      :   2022-11-20

import os, sys, logging

this_path = os.path.dirname(__file__)
this_path = this_path if this_path else '.'
if this_path not in sys.path:
    sys.path.append(this_path)

os.chdir(this_path)

path = os.path.join(this_path, '../../data/gen/single_p+')
log_level = 3
card = 'decay_card/single_p+/p_0.8_theta_0.1_phi_0.5.dec'

do_sim = True
do_rec = True
do_root = True

n = 1e3
events_per_file = 1e3

add_layer_flag = 'true'
particle_type = 4


# add lh
material = 'LH'
# for thickness in range(0,21,5):
for thickness in [10]:
    current_path = path_lh = os.path.join(path, 'add_lh', str(thickness))
    cmd = []
    cmd.append('python gen2root.py')
    if do_sim:
        cmd.append('--do_sim')
    if do_rec:
        cmd.append('--do_rec')
    if do_root:
        cmd.append('--do_root')
    cmd.append('--log_level {}'.format(log_level))
    cmd.append('--path {}'.format(path_lh))
    cmd.append('--card {}'.format(card))
    cmd.append('--n {}'.format(n))
    cmd.append('--events_per_file {}'.format(events_per_file))
    cmd.append('--add_layer_flag {}'.format(add_layer_flag))
    cmd.append('--particle_type {}'.format(particle_type))
    cmd.append('--thickness {}'.format(thickness))
    cmd.append('--material {}'.format(material))

    cmd = ' '.join(cmd)
    os.system(cmd)