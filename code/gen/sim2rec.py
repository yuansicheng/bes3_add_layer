#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2022-02-15 

import os, sys, argparse, logging

this_path = os.path.dirname(__file__)
if this_path not in sys.path:
    sys.path.append(this_path)

from utils import replaceJobOptionValue

# set arg
parser = argparse.ArgumentParser()
parser.add_argument('--log_level', type=int, default=5)
parser.add_argument('--i', type=int)
parser.add_argument('--template', type=str)

parser.add_argument('--add_layer_flag', type=str, default='flase')
parser.add_argument('--thickness', type=float, default=0)
parser.add_argument('--material', type=str, default='')
args = parser.parse_args()

# create job_option
job_option_file =  'job_option_sim2rec_{}.txt'.format(args.i)
rtraw_file = '{}.rtraw'.format(args.i)
rec_file = '{}.rec'.format(args.i)

replace_dict = {
    'MessageSvc.OutputLevel': args.log_level, 
    'AddLayerSvc.AddLayerFlag': args.add_layer_flag ,
    'AddLayerSvc.Thickness': args.thickness ,
    'AddLayerSvc.Material': args.material ,
}


with open(args.template, 'r') as f:
    content = f.readlines()
replaceJobOptionValue(content, replace_dict)
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