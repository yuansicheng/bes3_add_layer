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

path = '/cefs/higgs/wxfang/yuansc/bes3_add_layer/p+pi-nbar/phsp'
if not os.path.isdir(path):
    os.makedirs(path)
log_level = 6
card = 'decay_card/p+pi-nbar/phsp.dec'

# do_sim = True
do_rec = True
do_sim = False
# do_rec = False
do_root = True

n = 1e6
events_per_file = 1e4

add_layer_flag = 'true'
particle_type = 0

delete_rec = True

run = True

job_option_template_path = 'job_option_template_p+pi-nbar'

#############################################################################
mamaterials = {
    'LH': list(range(0,21,10)), 
    'LD': list(range(0,21,10)), 
    'CsI': list(range(0,5,1))
}

for material, thickness_range in mamaterials.items():
    print(material)

    for thickness in thickness_range:
        target_path = os.path.join(path, 'add_{}'.format(material), str(thickness))
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

        cmd.append('--job_option_template_sim {}'.format(os.path.join(job_option_template_path, 'job_option_sim.txt')))
        cmd.append('--job_option_template_rec {}'.format(os.path.join(job_option_template_path, 'job_option_sim2rec.txt')))
        cmd.append('--job_option_template_root {}'.format(os.path.join(job_option_template_path, 'job_option_rec2root.txt')))

        if delete_rec:
            cmd.append('--delete_rec')

        if run:
            cmd.append('--run')

        cmd = ' '.join(cmd)
        os.system(cmd)