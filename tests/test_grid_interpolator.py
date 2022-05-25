# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:52:39 2022

@author: florianma
"""
from scipy.interpolate import RegularGridInterpolator
from gridinterpolator import PyRegularGridInterpolator
import numpy as np
import timeit

# first_axis = np.array([6., 10., 15.])
# second_axis = np.array([4., 6., 9.])
# values_flat = np.array([1.0, 1.1, 1.2,
#                         2.0, 2.1, 2.2,
#                         3.0, 3.1, 3.2]).reshape(1, -1)
# my_grid = [first_axis, second_axis]
# my_interpolator = gridinterpolator.PyRegularGridInterpolator(
#     my_grid, values_flat)
# # pts = np.array([[2.1, 6.2, 8.3], [3.3, 5.2, 7.1]])
# target = np.array([5.0, 7.0])

# res = my_interpolator(target)
# print(res)


def f(x, y, z):
    return 2 * x**3 + 3 * y**2 - z


x = np.linspace(1, 4, 11)
y = np.linspace(4, 7, 22)
z = np.linspace(7, 9, 33)
xg, yg, zg = np.meshgrid(x, y, z, indexing='ij', sparse=True)
data = f(xg, yg, zg)
pts = np.array([[2.1, 6.2, 8.3], [3.3, 5.2, 7.1]])

# scipy:
my_interpolating_function = RegularGridInterpolator((x, y, z), data)
result = my_interpolating_function(pts)
print(result)


my_interpolator = PyRegularGridInterpolator([x, y, z], data.reshape(1, -1))
for target in pts:
    res = my_interpolator(target)
    print(res)


# dims = my_interpolator.get_ndims()
# print(dims)
# current_target = my_interpolator.get_current_target()
# print(current_target)
# res = my_interpolator.get_values_at_target()
# print(res)
# target = pts[0]
# r = my_interpolator.set_new_target(target)  # breaks
# print(r)
