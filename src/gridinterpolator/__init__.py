# -*- coding: utf-8 -*-
"""
Created on Sun May 15 09:39:41 2022

@author: florianma
"""
from ._grid_interpolator import *

try:
    from ._version import version as __version__
except ImportError:
    __version__ = "0.0.0+unknown"
