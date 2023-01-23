#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2023-01-15 

import os, sys, argparse, logging
# import pandas as pd
# import numpy as np

this_path = os.path.abspath(os.path.dirname(__file__))
if this_path not in sys.path:
    sys.path.append(this_path)

# from utils import *

from glob import glob
from tqdm import tqdm



# args
parser = argparse.ArgumentParser()
parser.add_argument('--target_path', type=str, default='../../data/extract')
parser.add_argument('--data_path', type=str, default='../../data/gen')
parser.add_argument('--particle_type', type=str, default='')

args = parser.parse_args()

assert args.particle_type
target_path = os.path.join(this_path, args.target_path, args.particle_type)
if not os.path.isdir(target_path):
    os.makedirs(target_path)
data_path = os.path.join(this_path, args.data_path, args.particle_type)

# loop
for root_path in tqdm(glob(os.path.join(data_path, '*/*/*'))):
    root_path_copy = root_path
    root_path_split = root_path_copy.replace('\\', '/').split('/')
    material, thickness = root_path_split[-2].split('_')[1], int(root_path_split[-1])

    job_file = os.path.join(target_path, 'job_{}_{}.sh'.format(material, thickness))
    csv_file = os.path.join(target_path, '{}_{}.csv'.format(material, thickness))

    job_content = []
    job_content.append('#!/bin/bash')
    job_content.append('source /cefs/higgs/wxfang/yuansc/miniconda3/bin/activate')
    job_content.append('python {}\\'.format(os.path.join(this_path, 'extract_one_folder.py')))
    job_content.append('\t--path {}\\'.format(root_path))
    job_content.append('\t--particle_type {}\\'.format(args.particle_type))
    job_content.append('\t--csv_file {}'.format(csv_file))

    with open(job_file, 'w') as f:
        f.write('\n'.join(job_content))

    os.system('chmod 755 {}'.format(job_file))
    os.system('hep_sub {}'.format(job_file))

    




