#!/usr/bin/python
# -*- coding: utf-8 -*-

# @Author	:	yuansc
# @Contact	:	yuansicheng@ihep.ac.cn
# @Date		:	2023-01-23 

import os, sys, argparse, logging

import pandas as pd 
import numpy as np
from glob import glob
import matplotlib.pyplot as plt

from scipy.interpolate import griddata

import scienceplots
plt.style.use(['science', 'nature', 'no-latex', 'notebook'])

def plot3D(df, title='', xlabel='', ylabel='', figsize=(10, 6)):
    assert df.shape[1] == 3
    xi=np.linspace(min(df.iloc[:, 0]),max(df.iloc[:, 0]))
    yi=np.linspace(min(df.iloc[:, 1]),max(df.iloc[:, 1]))
    xi,yi=np.meshgrid(xi,yi)
    zi=griddata(df.iloc[:, 0:2], df.iloc[:, 2],(xi,yi))

    fig=plt.figure(figsize=figsize)
    ax=fig.gca(projection='3d')
    surf=ax.plot_surface(xi, yi, zi,cmap='tab20b',linewidth=0,antialiased=False, alpha=0.8)
    fig.colorbar(surf)
    ax.set_title(title)

    if xlabel:
        ax.set_xlabel(xlabel)
    if ylabel:
        ax.set_ylabel(ylabel)

    plt.show()
    plt.close()


# # test
# df = pd.DataFrame(np.random.rand(100,3))
# fig = plot3D(df)