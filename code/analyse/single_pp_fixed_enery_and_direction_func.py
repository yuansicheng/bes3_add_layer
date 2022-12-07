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

from scipy.stats import norm
from scipy.optimize import curve_fit

import math

from distfit import distfit

import matplotlib
import matplotlib.pyplot as plt

this_path = os.path.dirname(__file__)

def root2Df(root_files, kal=False):
    df = readRootFiles(root_files, kal=kal)
    df['theta'] = df.apply(pxpypz2Theta, axis=1, args=[kal])
    
    if kal:
        p = df['kal_p']
    else:
        p = df['mdc_p']
    p_loc, p_loc_err, p_scale, p_scale_err = fitNorm(p)
    theta_loc, theta_loc_err, theta_scale, theta_scale_err = fitNorm(df['theta'])

    mc_p = np.array(pthetaphi2Pxpypz(0.3, math.acos(0.1), 0.5))
    df['delta_angle'] = df.apply(getDeltaAngle, axis=1, args=[mc_p, kal])
    df['delta_angle'].loc[df['delta_angle']<0.1].plot.hist(bins=100, figsize=(5,2), histtype='step')
    delta_angle_one_sigma = np.percentile(df['delta_angle'].dropna(), 68.3)
    # print(df['delta_angle'])
    # print('delta_angle_one_sigma: ', delta_angle_one_sigma)


    return pd.Series([p_loc, p_loc_err, p_scale, p_scale_err, theta_loc, theta_loc_err, theta_scale, theta_scale_err, df.shape[0], delta_angle_one_sigma], index = ['p_loc', 'p_loc_err', 'p_scale', 'p_scale_err', 'theta_loc', 'theta_loc_err', 'theta_scale', 'theta_scale_err', 'between_2_sigma', 'delta_angle_one_sigma'])

def fitNorm(data, nbins=100):
    mean, std = data.mean(), data.std()
    data = data.loc[
        (data > mean-2*std) &
        (data < mean+2*std)
    ]
    
    plt.figure(figsize=(4,2))
    n, bins, _ = plt.hist(data ,nbins, density=True, facecolor = 'grey', alpha = 0.5, label='before')
    centers = (0.5*(bins[1:]+bins[:-1]))
    pars, cov = curve_fit(lambda x, mu, sig : norm.pdf(x, loc=mu, scale=sig), centers, n, p0=[mean,std])
    plt.plot(centers, norm.pdf(centers,*pars), 'k--',linewidth = 2, label='fit before',)
    plt.title('$\mu={:.4f}\pm{:.4f}$, $\sigma={:.4f}\pm{:.4f}$'.format(pars[0],np.sqrt(cov[0,0]), pars[1], np.sqrt(cov[1,1 ])))
    plt.show()
    plt.clf()

    return pars[0], cov[0,0]**0.5, pars[1], cov[1,1]**0.5
    

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

def getDeltaAngle(df, mc_p, kal=False):
    if kal:
        px, py, pz = df['kal_px'], df['kal_py'], df['kal_pz']
    else:
        px, py, pz = df['mdc_px'], df['mdc_py'], df['mdc_pz']
    p = np.array([px, py, pz])
    return math.acos(p.dot(mc_p) / (np.linalg.norm(p) * np.linalg.norm(mc_p)))


def readRootFiles(root_files, kal=False):
    df_list = []
    for root_file in root_files:
        df_list.append(readOneFile(root_file, kal=kal))
    df = pd.concat(df_list)

    return df

def readOneFile(root_file, kal=False):
    print(root_file)
    rf = uproot.open(root_file)
    tree = rf['RecInfo']

    df = pd.DataFrame()

    # 最大动量为p的index
    if kal:
        p_index = [np.argmax(p) if len(p) else None for p in tree['kal_p'].array()]
    else:
        p_index = [np.argmax(p) if len(p) else None for p in tree['mdc_p'].array()]

    for key in tree.keys():
        tmp = tree[key].array()
        if 'p' in key:
            df[key] = [tmp[i][p_index[i]] for i in range(len(tmp)) if not p_index[i] is None] 
        else:
            df[key] = [tmp[i] for i in range(len(tmp)) if not p_index[i] is None]

    rf.close()   

    # 去掉异常值
    if kal:
        p = df.kal_p
        p_mean = np.array(df.kal_p).mean()
        p_std = np.array(df.kal_p).std()
    else:
        p = df.mdc_p
        p_mean = np.array(df.mdc_p).mean()
        p_std = np.array(df.mdc_p).std()
    # p.plot.hist(figsize=(5,2), bins=100)
    df = df.loc[
        (p > p_mean-2*p_std) & 
        (p < p_mean+2*p_std)
    ]

    return df

# # test
# root_files = glob(os.path.join(this_path, '../../data/gen/single_p+/p_0.3_theta_0.1_phi_0.5/add_lh/10/0.root'))
# print(root_files)
# df = root2Df(root_files, kal=True)
# print(df)