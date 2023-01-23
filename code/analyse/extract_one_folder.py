#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2023-01-15 

import os, sys, argparse, logging
import pandas as pd
import numpy as np

this_path = os.path.abspath(os.path.dirname(__file__))
if this_path not in sys.path:
    sys.path.append(this_path)

from utils import *

from glob import glob
from tqdm import tqdm
from itertools import product

# args
parser = argparse.ArgumentParser()
parser.add_argument('--path', type=str, default='')
parser.add_argument('--particle_type', type=str, default='')
parser.add_argument('--csv_file', type=str, default='')

args = parser.parse_args()

df2Res = n0Df2Res if 'n0' in args.particle_type else ppiDf2Res
if 'nbar' in args.particle_type: df2Res = ppinbarDf2Res

bin = 0.1
# bin, bin_low_p = 0.06, 0.02
p_high = 1.2
cos_theta_range = np.arange(0, 0.9+1e-6, bin).round(3)
if 'pi-' in args.particle_type:
    p_low = 0.1
elif 'p+' in args.particle_type:
    p_low = 0.3
elif 'n0' in args.particle_type:
    p_low = 0.1
# p_mid = p_low + 0.3
# p_range = np.concatenate([
    # np.arange(p_low, p_mid-1e-6, bin_low_p), 
    # np.arange(p_mid, p_high+1e-6, bin), 
    # ])

p_range = np.arange(p_low, p_high+(1e-6), bin).round(3)


res_df = pd.DataFrame(columns=['particle', 'material', 'thickness', 'p', 'cos_theta'] + getIndex(args.particle_type))


root_path_copy = args.path
root_path_split = root_path_copy.replace('\\', '/').split('/')
particle, material, thickness = root_path_split[-4], root_path_split[-2].split('_')[1], int(root_path_split[-1])


# print(glob(os.path.join(root_path, '*.root')))
# continue


if 'nbar' in args.particle_type:
    df, df_all = readRootFilesPpinbar(glob(os.path.join(args.path, '*.root')))
    df['momentum'] = (df.pxmcnbar**2 + df.pymcnbar**2 + df.pzmcnbar**2) ** 0.5
    df['theta'] = df.apply(pxpypz2Theta2, axis=1, args=('pxmcnbar', 'pymcnbar', 'pzmcnbar'))
    df['cos_theta'] = np.cos(df.theta)
    df_all['momentum'] = (df_all.pxmcnbar**2 + df_all.pymcnbar**2 + df_all.pzmcnbar**2) ** 0.5
    df_all['theta'] = df_all.apply(pxpypz2Theta2, axis=1, args=('pxmcnbar', 'pymcnbar', 'pzmcnbar'))
    df_all['cos_theta'] = np.cos(df_all.theta)
else:
    df = readRootFiles(glob(os.path.join(args.path, '*.root')), particle=args.particle_type)

for i,j in tqdm(product(range(len(p_range)-1), range(len(cos_theta_range)-1))):
    p1, p2 = p_range[i], p_range[i+1]
    cos_theta1, cos_theta2 = cos_theta_range[j], cos_theta_range[j+1]

    
    if 'nbar' in args.particle_type:
        tmp = df.loc[
            (df.momentum >= p1) &
            (df.momentum < p2) &
            (df.cos_theta >= cos_theta1) &
            (df.cos_theta < cos_theta2)
        ]
        all_num = df_all.loc[
            (df_all.momentum >= p1) &
            (df_all.momentum < p2) &
            (df_all.cos_theta >= cos_theta1) &
            (df_all.cos_theta < cos_theta2)
        ].shape[0]
        res = df2Res(tmp, all_num)
    else:
        tmp = df.loc[
            (df.momentum >= p1) &
            (df.momentum < p2) &
            (df.cos_theta >= cos_theta1) &
            (df.cos_theta < cos_theta2)
        ]
        res = df2Res(tmp, thickness=thickness)
    res = [particle, material, thickness, (p1+p2)/2, (cos_theta1+cos_theta2)/2] + list(res)
    res_df.loc[res_df.shape[0]] = res

res_df.to_csv(args.csv_file)