# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:52:39 2022

@author: florianma
"""
import gridinterpolator  # _grid_interpolator
import numpy as np
import timeit

first_axis = np.array([6., 10., 15.])
second_axis = np.array([4., 6., 9.])
values_flat = np.array([1.0, 1.1, 1.2,
                        2.0, 2.1, 2.2,
                        3.0, 3.1, 3.2]).reshape(1, -1)
my_grid = [first_axis, second_axis]
my_interpolator = gridinterpolator.PyRegularGridInterpolator(
    my_grid, values_flat)
