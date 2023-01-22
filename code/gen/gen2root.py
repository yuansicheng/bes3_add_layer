#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2022-02-15 

import os, sys, argparse, logging

this_path = os.path.abspath(os.path.dirname(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--log_level', type=int, default=5)
parser.add_argument('--card', type=str, default='decay_card/p_0.8_theta_0.1_phi_0.5.dec')
parser.add_argument('--path', type=str)
parser.add_argument('--boss_env', type=str, default='../boss/boss_env.sh')

parser.add_argument('--do_sim', action='store_true')
parser.add_argument('--do_rec', action='store_true')
parser.add_argument('--do_root', action='store_true')

parser.add_argument('--job_option_template_sim', type=str, default='job_option_template/job_option_sim.txt')
parser.add_argument('--job_option_template_rec', type=str, default='job_option_template/job_option_sim2rec.txt')
parser.add_argument('--job_option_template_root', type=str, default='job_option_template/job_option_rec2root.txt')

parser.add_argument('--n', type=float, default=1e3)
parser.add_argument('--events_per_file', type=float, default=1e3)

parser.add_argument('--add_layer_flag', type=str, default='flase')
parser.add_argument('--particle_type', type=int, default=2)
parser.add_argument('--thickness', type=float, default=0)
parser.add_argument('--material', type=str, default='')
parser.add_argument('--save_anti_neutron_final_momentum', type=str, default='false')

parser.add_argument('--run', action='store_true')

parser.add_argument('--delete_rec', action='store_true')

args = parser.parse_args()

# ##########################################
# options
args.card = os.path.join(this_path, args.card)
args.path = os.path.join(this_path, args.path)
args.boss_env = os.path.join(this_path, args.boss_env)

args.job_option_template_sim = os.path.join(this_path, args.job_option_template_sim)
args.job_option_template_rec = os.path.join(this_path, args.job_option_template_rec)
args.job_option_template_root = os.path.join(this_path, args.job_option_template_root)

# ##########################################


if not os.path.isdir(args.path):
    os.makedirs(args.path)

os.chdir(args.path)


for i in range(int(args.n/args.events_per_file)):
    job_file = 'job_{}.sh'.format(i)

    job_content = []
    job_content.append('#!/bin/bash')
    job_content.append('pwd')
    job_content.append('source {}'.format(args.boss_env))

    if args.do_sim:
        job_content.append('python {}/sim.py\\'.format(this_path))
        job_content.append('\t--log_level {}\\'.format(args.log_level))
        job_content.append('\t--i {}\\'.format(i))
        job_content.append('\t--evtmax {}\\'.format(args.events_per_file))
        job_content.append('\t--template {}\\'.format(args.job_option_template_sim))
        job_content.append('\t--card {}\\'.format(args.card))
        job_content.append('\t--add_layer_flag {}\\'.format(args.add_layer_flag))
        job_content.append('\t--save_anti_neutron_final_momentum {}\\'.format(args.save_anti_neutron_final_momentum))
        job_content.append('\t--thickness {}\\'.format(args.thickness))
        job_content.append('\t--material {}'.format(args.material))

    if args.do_rec:
        job_content.append('python {}/sim2rec.py\\'.format(this_path))
        job_content.append('\t--log_level {}\\'.format(args.log_level))
        job_content.append('\t--i {}\\'.format(i))
        job_content.append('\t--template {}\\'.format(args.job_option_template_rec))
        job_content.append('\t--add_layer_flag {}\\'.format(args.add_layer_flag))
        job_content.append('\t--thickness {}\\'.format(args.thickness))
        job_content.append('\t--material {}'.format(args.material))
    if args.do_root:
        job_content.append('python {}/rec2root.py\\'.format(this_path))
        job_content.append('\t--log_level {}\\'.format(args.log_level))
        job_content.append('\t--i {}\\'.format(i))
        job_content.append('\t--template {}\\'.format(args.job_option_template_root))
        job_content.append('\t--add_layer_flag {}\\'.format(args.add_layer_flag))
        if args.delete_rec:
            job_content.append('\t--delete_rec\\')
        
        

    with open(job_file, 'w') as f:
        f.write('\n'.join(job_content))

    os.system('chmod 755 {}'.format(job_file))
    if args.run:
        os.system('hep_sub {}'.format(job_file))

