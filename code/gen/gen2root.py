#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2022-02-15 

import os, sys, argparse, logging

this_path = os.path.abspath(os.path.dirname(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--name', type=str, default='single_p+_fixed_enery_and_direction')
parser.add_argument('--boss_env', type=str, default='../boss/boss_env.sh')

parser.add_argument('--do_sim', type=int, default=1)
parser.add_argument('--do_rec', type=int, default=1)
parser.add_argument('--do_root', type=int, default=1)

parser.add_argument('--job_option_template_sim', type=str, default='job_option_sim.txt')
parser.add_argument('--job_option_template_rec', type=str, default='job_option_sim2rec.txt')
parser.add_argument('--job_option_template_root', type=str, default='job_option_rec2root.txt')

parser.add_argument('--lh', type=float, default=0)
parser.add_argument('--pip_param_file', type=str, default='../boss/workarea/Simulation/BOOST/BesSim/BesSim-00-01-24/dat/BesPip.txt')
parser.add_argument('--n', type=float, default=1e3)
parser.add_argument('--events_per_file', type=float, default=1e3)

args = parser.parse_args()

# ##########################################
# options
name = args.name
decay_card = os.path.join(this_path, 'decay_card/{}.dec'.format(name))
target_path = os.path.join(this_path, '../../data/gen/{}/lh_{}'.format(name, args.lh))

boss_env = os.path.join(this_path, args.boss_env)

do_sim = args.do_sim
do_rec = args.do_rec
do_root = args.do_root

job_option_template_sim = os.path.join(this_path, args.job_option_template_sim)
job_option_template_rec = os.path.join(this_path, args.job_option_template_rec)
job_option_template_root = os.path.join(this_path, args.job_option_template_root)

lh = args.lh
pip_param_file = os.path.join(this_path, args.pip_param_file)

n = args.n
events_per_file = args.events_per_file

# ##########################################


if not os.path.isdir(target_path):
    os.makedirs(target_path)

os.chdir(target_path)


for i in range(int(n/events_per_file)):
    job_file = 'job_{}.sh'.format(i)

    job_content = []
    job_content.append('#!/bin/bash')
    job_content.append('pwd')
    job_content.append('source {}'.format(boss_env))

    if do_sim:
        job_content.append('python {}/sim.py -i {} -e {} -c {} -t {} -lh {}'.format(this_path, i, int(events_per_file), decay_card, job_option_template_sim, lh))
    if do_rec:
        job_content.append('python {}/sim2rec.py -i {} -t {}'.format(this_path, i, job_option_template_rec))
    if do_root:
        job_content.append('python {}/rec2root.py -i {} -t {}'.format(this_path, i, job_option_template_root))

    with open(job_file, 'w') as f:
        f.write('\n'.join(job_content))

    os.system('chmod 755 {}'.format(job_file))
    os.system('hep_sub {}'.format(job_file))

