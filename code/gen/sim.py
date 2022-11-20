#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2022-02-15 

import os, sys, argparse, logging

# set arg
parser = argparse.ArgumentParser()
parser.add_argument('-i', type=int)
parser.add_argument('-e', '--evtmax', type=int)
parser.add_argument('-c', '--card', type=str)
parser.add_argument('-t', '--template', type=str)
parser.add_argument('-lh', '--lh', type=float)
args = parser.parse_args()


# create job_option
job_option_file =  'job_option_sim_{}.txt'.format(args.i)
rtraw_file = '{}.rtraw'.format(args.i)

with open(args.template, 'r') as f:
    content = f.readlines()
for i, line in enumerate(content):
    if line.startswith('EvtDecay.userDecayTableName'):
        content[i] = 'EvtDecay.userDecayTableName = \"{}\"; \n'.format(args.card)
    if line.startswith('RootCnvSvc.digiRootOutputFile'):
        content[i] = 'RootCnvSvc.digiRootOutputFile = \"{}\"; \n'.format(rtraw_file)
    if line.startswith('ApplicationMgr.EvtMax'):
        content[i] = 'ApplicationMgr.EvtMax = {}; \n'.format(args.evtmax)
    if line.startswith('BesRndmGenSvc.RndmSeed'):
        content[i] = 'BesRndmGenSvc.RndmSeed = {}; \n'.format(args.i)
    if line.startswith('BesSim.LH'):
        content[i] = 'BesSim.LH = {}; \n'.format(args.lh)
with open(job_option_file, 'w') as f:
    f.writelines(''.join(content))

# run job_option
os.system('chmod 755 {}'.format(job_option_file))
os.system('boss.exe {}'.format(job_option_file))