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
parser.add_argument('--evtmax', type=float)
parser.add_argument('--card', type=str)
parser.add_argument('--template', type=str)

parser.add_argument('--add_layer_flag', type=str, default='flase')
parser.add_argument('--thickness', type=int, default=0)
parser.add_argument('--material', type=str, default='')
args = parser.parse_args()


# create job_option
job_option_file =  'job_option_sim_{}.txt'.format(args.i)
rtraw_file = '{}.rtraw'.format(args.i)

replace_dict = {
    'EvtDecay.userDecayTableName': args.card ,
    'ApplicationMgr.EvtMax': int(args.evtmax),
    'RootCnvSvc.digiRootOutputFile': rtraw_file, 
    'BesRndmGenSvc.RndmSeed': args.i, 
    'MessageSvc.OutputLevel': args.log_level,
    'AddLayerSvc.AddLayerFlag': args.add_layer_flag ,
    'AddLayerSvc.Thickness': args.thickness ,
    'AddLayerSvc.Material': args.material ,

}

with open(args.template, 'r') as f:
    content = f.readlines()
content = replaceJobOptionValue(content, replace_dict)
with open(job_option_file, 'w') as f:
    f.writelines(''.join(content))

# run job_option
os.system('chmod 755 {}'.format(job_option_file))
os.system('boss.exe {}'.format(job_option_file))