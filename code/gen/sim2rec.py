#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2022-02-15 

import os, sys, argparse, logging

# set arg
parser = argparse.ArgumentParser()
parser.add_argument('-i', type=int)
parser.add_argument('-t', '--template', type=str)
args = parser.parse_args()

# create job_option
job_option_file =  'job_option_sim2rec_{}.txt'.format(args.i)
rtraw_file = '{}.rtraw'.format(args.i)
rec_file = '{}.rec'.format(args.i)

with open(args.template, 'r') as f:
    content = f.readlines()
for i, line in enumerate(content):
    if line.startswith('EventCnvSvc.digiRootInputFile'):
        input_files = '{\"' + rtraw_file + '\"}'
        content[i] = 'EventCnvSvc.digiRootInputFile = {}; \n'.format(input_files)
    if line.startswith('EventCnvSvc.digiRootOutputFile'):
        content[i] = 'EventCnvSvc.digiRootOutputFile = \"{}\"; \n'.format(rec_file)
with open(job_option_file, 'w') as f:
    f.writelines(''.join(content))

# run job_option
os.system('chmod 755 {}'.format(job_option_file))
os.system('boss.exe {}'.format(job_option_file))