#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author    :   yuansc
# @Contact   :   yuansicheng@ihep.ac.cn
# @Date      :   2022-11-20

import os, sys, logging
# from tqdm import tqdm

this_path = os.path.dirname(__file__)
this_path = this_path if this_path else '.'
if this_path not in sys.path:
    sys.path.append(this_path)

os.chdir(this_path)

path = os.path.join(this_path, '../../data/gen/single_p+/random')
if not os.path.isdir(path):
    os.makedirs(path)
log_level = 3
card = 'decay_card/single_p+/random.dec'

do_sim = True
do_rec = True
# do_sim = False
# do_rec = False
do_root = True

n = 1e5
events_per_file = 1e4

add_layer_flag = 'true'
particle_type = 4

run = True

#############################################################################
# add lh
material = 'LH'
print(material)
for thickness in range(0,21,10):
    target_path = os.path.join(path, 'add_lh', str(thickness))
    cmd = []
    cmd.append('python gen2root.py')
    if do_sim:
        cmd.append('--do_sim')
    if do_rec:
        cmd.append('--do_rec')
    if do_root:
        cmd.append('--do_root')
    cmd.append('--log_level {}'.format(log_level))
    cmd.append('--path {}'.format(target_path))
    cmd.append('--card {}'.format(card))
    cmd.append('--n {}'.format(n))
    cmd.append('--events_per_file {}'.format(events_per_file))
    cmd.append('--add_layer_flag {}'.format(add_layer_flag))
    cmd.append('--particle_type {}'.format(particle_type))
    cmd.append('--thickness {}'.format(thickness))
    cmd.append('--material {}'.format(material))

    if run:
        cmd.append('--run')

    cmd = ' '.join(cmd)
    os.system(cmd)

#############################################################################
# add LD
material = 'LD'
print(material)
for thickness in range(0,21,10):
    target_path = os.path.join(path, 'add_ld', str(thickness))
    cmd = []
    cmd.append('python gen2root.py')
    if do_sim:
        cmd.append('--do_sim')
    if do_rec:
        cmd.append('--do_rec')
    if do_root:
        cmd.append('--do_root')
    cmd.append('--log_level {}'.format(log_level))
    cmd.append('--path {}'.format(target_path))
    cmd.append('--card {}'.format(card))
    cmd.append('--n {}'.format(n))
    cmd.append('--events_per_file {}'.format(events_per_file))
    cmd.append('--add_layer_flag {}'.format(add_layer_flag))
    cmd.append('--particle_type {}'.format(particle_type))
    cmd.append('--thickness {}'.format(thickness))
    cmd.append('--material {}'.format(material))

    if run:
        cmd.append('--run')

    cmd = ' '.join(cmd)
    os.system(cmd)

#############################################################################
# add CsI
material = 'CsI'
print(material)
for thickness in range(0,11,2):
    target_path = os.path.join(path, 'add_csi', str(thickness))
    cmd = []
    cmd.append('python gen2root.py')
    if do_sim:
        cmd.append('--do_sim')
    if do_rec:
        cmd.append('--do_rec')
    if do_root:
        cmd.append('--do_root')
    cmd.append('--log_level {}'.format(log_level))
    cmd.append('--path {}'.format(target_path))
    cmd.append('--card {}'.format(card))
    cmd.append('--n {}'.format(n))
    cmd.append('--events_per_file {}'.format(events_per_file))
    cmd.append('--add_layer_flag {}'.format(add_layer_flag))
    cmd.append('--particle_type {}'.format(particle_type))
    cmd.append('--thickness {}'.format(thickness))
    cmd.append('--material {}'.format(material))

    if run:
        cmd.append('--run')

    cmd = ' '.join(cmd)
    os.system(cmd)