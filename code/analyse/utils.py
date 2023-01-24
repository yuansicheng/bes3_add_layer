#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2023-01-15 

import os, sys, argparse, logging
from tqdm import tqdm
import pandas as pd
import numpy as np
np.seterr(divide='ignore',invalid='ignore')
import uproot
import math

from scipy.stats import norm
from scipy.optimize import curve_fit

import matplotlib
import matplotlib.pyplot as plt

def readRootFiles(root_files, particle):
    branches = getBranches(particle)
    df_list = []
    for root_file in tqdm(root_files):
        try:
            df_list.append(readOneFile(root_file, keys=branches))
        except Exception as e:
            print(root_file, e)
    df = pd.concat(df_list)

    return df

def getBranches(particle):
    if 'p' in particle:
        return ['momentum', 'theta', 'phi', 'kal_p', 'kal_px', 'kal_py', 'kal_pz']
    else:
        return ['run_no', 'event', 'momentum', 'px', 'py', 'pz', 'theta', 'phi',  'final_rxy', 'final_rz']

def readOneFile(root_file, keys='all'):
    rf = uproot.open(root_file)
    tree = rf['RecInfo']

    if keys == 'all':
        keys = tree.keys()
    else:
        keys = [k for k in keys if k in tree.keys()]

    df = pd.DataFrame()
    p_index = [np.argmax(p) if len(p) else None for p in tree['kal_p'].array()]
    for key in keys:
        tmp = tree[key].array()
        try:
            df[key] = [tmp[i][p_index[i]] if not p_index[i] is None else np.nan for i in range(len(tmp)) ] 
        except:
            df[key] = list(tmp)

    # merge csv
    root_path = os.path.dirname(root_file)
    file_name = os.path.basename(root_file)
    csv_file = 'anti_neutron_{}.csv'.format(file_name.split('.')[0])

    if csv_file in os.listdir(root_path):
        final_info = pd.read_csv(os.path.join(root_path, csv_file))

        df = df.merge(final_info, on=['run_no', 'event'], how='left')

    df['cos_theta'] = np.cos(df.theta)

    return df

def readOneFilePpinbar(root_file):
    rf = uproot.open(root_file)

    tree = rf['mctruth']
    df_all = pd.DataFrame()
    for key in ['pxmcnbar', 'pymcnbar', 'pzmcnbar']:
        df_all[key] = list(tree[key].array())

    tree = rf['FIT']
    df = pd.DataFrame()
    for key in ['pxmcnbar', 'pymcnbar', 'pzmcnbar', 'vtxnbar_px', 'vtxnbar_py', 'vtxnbar_pz', 'wtrecoilmass']:
        df[key] = list(tree[key].array())

    return df, df_all

def readRootFilesPpinbar(root_files):
    df_list = []
    df_all_list = []
    for root_file in tqdm(root_files):
        try:
            df, df_all = readOneFilePpinbar(root_file)
            df_list.append(df)
            df_all_list.append(df_all)
        except Exception as e:
            print(root_file, e)
    df = pd.concat(df_list)
    df_all = pd.concat(df_all_list)

    return df, df_all 

def ppinbarDf2Res(df, all_num, **kwargs):
    index = getIndex('p')

    print(df.shape[0])

    if not df.shape[0]:
        return pd.Series([np.nan]*len(index), index=index)

    df = df.copy()
    # df['theta'] = df.apply(pxpypz2Theta2, axis=1, args=('pxmcnbar', 'pymcnbar', 'pzmcnbar'))
    df['vtxnbar_theta'] = df.apply(pxpypz2Theta2, axis=1, args=('vtxnbar_px', 'vtxnbar_py', 'vtxnbar_pz'))
    df['vtxnbar_p'] = (df.vtxnbar_px**2 + df.vtxnbar_py**2 + df.vtxnbar_pz**2) ** 0.5
    df['dp'] = df.vtxnbar_p - df.momentum
    df['dtheta'] = df.vtxnbar_theta - df.theta

    # df = df[(df.dp.abs()<0.05) & (df.dtheta.abs()<0.1)]
    efficiency = df.shape[0] / all_num if all_num else 0

    # print(df)

    try:
        if df.shape[0]<10: raise ValueError
        p_loc, p_loc_err, p_scale, p_scale_err = fitNorm(df['dp'])
        theta_loc, theta_loc_err, theta_scale, theta_scale_err = fitNorm(df['dtheta'])
        df['delta_angle'] = df.apply(getDeltaAngle2, axis=1)
        delta_angle_one_sigma = np.percentile(df['delta_angle'].dropna(), 68.3)
    except Exception as e:
        print(e)
        p_loc, p_loc_err, p_scale, p_scale_err, theta_loc, theta_loc_err, theta_scale, theta_scale_err, delta_angle_one_sigma = tuple([np.nan]*9)

    


    return pd.Series([p_loc, p_loc_err, p_scale, p_scale_err, theta_loc, theta_loc_err, theta_scale, theta_scale_err, efficiency, df.shape[0], all_num, delta_angle_one_sigma], index=index)


def getDeltaAngle2(df):
    mc_p = np.array([df['pxmcnbar'], df['pymcnbar'],df['pzmcnbar']])
    px, py, pz = df['vtxnbar_px'], df['vtxnbar_py'], df['vtxnbar_pz']
    p = np.array([px, py, pz])
    return math.acos(p.dot(mc_p) / (np.linalg.norm(p) * np.linalg.norm(mc_p)))


def getDeltaAngle(df):
    mc_p = np.array(pthetaphi2Pxpypz(df['momentum'], df['theta'],df['phi']))
    px, py, pz = df['kal_px'], df['kal_py'], df['kal_pz']
    p = np.array([px, py, pz])
    return math.acos(p.dot(mc_p) / (np.linalg.norm(p) * np.linalg.norm(mc_p)))

def pthetaphi2Pxpypz(p, theta, phi):
    px = p * math.sin(theta) * math.cos(phi)
    py = p * math.sin(theta) * math.sin(phi)
    pz = p * math.cos(theta)
    return px, py, pz


def pxpypz2Theta2(df, k1, k2, k3):
    px, py, pz = df[k1], df[k2], df[k3]
    return math.acos(pz / np.linalg.norm(np.array([px,py,pz])))

def fitNorm(data, nbins=100):
    mean, std = data.mean(), data.std()
    data = data.loc[
        (data > mean-2*std) &
        (data < mean+2*std)
    ]
    
    # plt.figure(figsize=(4,2))
    n, bins, _ = plt.hist(data ,nbins, density=True, facecolor = 'grey', alpha = 0.5, label='before')
    centers = (0.5*(bins[1:]+bins[:-1]))
    pars, cov = curve_fit(lambda x, mu, sig : norm.pdf(x, loc=mu, scale=sig), centers, n, p0=[mean,std])
    plt.plot(centers, norm.pdf(centers,*pars), 'k--',linewidth = 2, label='fit before',)
    plt.title('$\mu={:.4f}\pm{:.4f}$, $\sigma={:.4f}\pm{:.4f}$'.format(pars[0],np.sqrt(cov[0,0]), pars[1], np.sqrt(cov[1,1 ])))
    # plt.show()
    plt.close()

    return pars[0], cov[0,0]**0.5, pars[1], cov[1,1]**0.5



def ppiDf2Res(df, **kwargs):
    index = getIndex('ppi')
    raw_shape = df.shape[0]
    df = df.loc[df.kal_p > 1e-6]

    if not df.shape[0]:
        return pd.Series([np.nan]*len(index), index=index)

    df = df.copy()
    df['kal_theta'] = df.apply(pxpypz2Theta2, axis=1, args=('kal_px', 'kal_py', 'kal_pz'))
    df['dp'] = df.kal_p - df.momentum
    df['dtheta'] = df.kal_theta - df.theta

    df = df[(df.dp.abs()<0.05) & (df.dtheta.abs()<0.1)]
    efficiency = df.shape[0] / raw_shape if raw_shape else 0


    try:
        p_loc, p_loc_err, p_scale, p_scale_err = fitNorm(df['dp'])
        theta_loc, theta_loc_err, theta_scale, theta_scale_err = fitNorm(df['dtheta'])
        df['delta_angle'] = df.apply(getDeltaAngle, axis=1)
        delta_angle_one_sigma = np.percentile(df['delta_angle'].dropna(), 68.3)
    except:
        p_loc, p_loc_err, p_scale, p_scale_err, theta_loc, theta_loc_err, theta_scale, theta_scale_err, delta_angle_one_sigma = tuple([np.nan]*9)

    return pd.Series([p_loc, p_loc_err, p_scale, p_scale_err, theta_loc, theta_loc_err, theta_scale, theta_scale_err, efficiency, df.shape[0], raw_shape, delta_angle_one_sigma], index=index)


def n0Df2Res(df, thickness=0):
    index = getIndex('n0')
    raw_shape = df.shape[0]

    annihilate = df[df.final_p.isna()]
    if thickness > 0:
        annihilate = annihilate[(annihilate.final_rxy>3.37+1e-6) & (annihilate.final_rxy-1e-6<3.37+thickness/10) & (annihilate.final_rz<13.4)].shape[0]
    else:
        annihilate = 0


    scatter = df.dropna(subset=['final_p'])
    delta_p = ((scatter.final_px/1000 - scatter.px)**2 + (scatter.final_py/1000 - scatter.py)**2 + (scatter.final_pz/1000 - scatter.pz)**2) ** 0.5

    scatter = (delta_p > 0.01).sum()

    annihilate_ratio = annihilate / raw_shape if raw_shape else 0
    scatter_ratio = scatter / raw_shape if raw_shape else 0

    return pd.Series([ annihilate_ratio, annihilate, scatter_ratio, scatter, raw_shape], index=index)

def getIndex(particle):
    if 'p' in particle:
        return ['p_loc', 'p_loc_err', 'p_scale', 'p_scale_err', 'theta_loc', 'theta_loc_err', 'theta_scale', 'theta_scale_err', 'efficiency', 'valid', 'all', 'delta_angle_one_sigma']
    else:
        return ['annihilate_ratio', 'annihilate_num','scatter_ratio', 'scatter_num', 'all',]

