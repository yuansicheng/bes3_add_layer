#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author    :   yuansc
# @Contact   :   yuansicheng@ihep.ac.cn
# @Date      :   2022-11-20

import os, sys, logging

import pandas as pd
import numpy as np
import uproot
from glob import glob

import math

from distfit import distfit

import matplotlib
import matplotlib.pyplot as plt

this_path = os.path.dirname(__file__)

def root2Df(root_files, kal=False):
    df = readRootFiles(root_files)
    df['theta'] = df.apply(pxpypz2Theta, axis=1, args=[kal])
    
    if kal:
        p = df['kal_p']
    else:
        p = df['mdc_p']
    p_loc, p_scale = fitNorm(p)
    theta_loc, theta_scale = fitNorm(df['theta'])

    return pd.Series([p_loc, p_scale, theta_loc, theta_scale, df.shape[0]])

def fitNorm(data):
    mean, std = data.mean(), data.std()
    data = data.loc[
        (data > mean-2*std) &
        (data < mean+2*std)
    ]
    dist = distfit(todf=True, distr='norm', bins=50)
    dist.fit_transform(data)
    # dist.plot(figsize=(6,3))
    return dist.summary['loc'].values[0], dist.summary['scale'].values[0]

def pxpypz2Theta(df, kal=False):
    if kal:
        px, py, pz = df['kal_px'], df['kal_py'], df['kal_pz']
    else:
        px, py, pz = df['mdc_px'], df['mdc_py'], df['mdc_pz']
    return math.acos(pz / np.linalg.norm(np.array([px,py,pz])))

def pthetaphi2Pxpypz(p, theta, phi):
    px = p * math.sin(theta) * math.cos(phi)
    py = p * math.sin(theta) * math.sin(phi)
    pz = p * math.cos(theta)
    return px, py, pz



def readRootFiles(root_files):
    df_list = []
    for root_file in root_files:
        df_list.append(readOneFile(root_file))
    df = pd.concat(df_list)

    return df

def readOneFile(root_file):
    print(root_file)
    rf = uproot.open(root_file)
    tree = rf['RecInfo']

    df = pd.DataFrame()

    # 最大动量为p的index
    p_index = [np.argmax(p) if len(p) else None for p in tree['mdc_p'].array()]
    print(tree['mdc_p'].array())

    for key in [k for k in tree.keys() if 'p' in k]:
        tmp = tree[key].array()
        df[key] = [tmp[i][p_index[i]] for i in range(len(p_index)) if not p_index[i] is None]

    

    # 去掉异常值
    mdc_p_mean = np.array(df.mdc_p).mean()
    mdc_p_std = np.array(df.mdc_p).std()
    df = df.loc[
        (df.mdc_p > mdc_p_mean-3*mdc_p_std) & 
        (df.mdc_p < mdc_p_mean+3*mdc_p_std)
    ]

    return df

# # test
# root_files = glob(os.path.join(this_path, '../../data/gen/single_p+_fixed_enery_and_direction/lh_50.0/*.root'))
# print(root_files)
# df = root2Df(root_files)
# print(df)