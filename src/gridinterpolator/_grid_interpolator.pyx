# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:42:36 2022

@author: florianma
see https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html
"""
import numpy as np
cimport numpy as np
cimport cython

import sys as _sys
import struct
import copy as _copy
import unicodedata as _unicodedata
import time as _time
import warnings as _warnings
import numbers as _numbers

from cython.operator cimport dereference as deref

cdef extern from "Python.h":
    Py_INCREF(object o)
    object Py_BuildValue(char *format, ...)
    object PyBuffer_FromMemory(void *ptr, int size)
    #int PyArg_ParseTuple(object struct,void* ptr)
    char*PyString_AsString(object string)
    int PyArg_VaParse(object args, char *format, ...)
    int PyArg_Parse(object args, char *format, ...)
    int PyObject_AsReadBuffer(object obj, void*buffer, int*buffer_len)
    object PyBuffer_FromObject(object base, int offset, int size)
    object PyBuffer_FromReadWriteObject(object base, int offset, int size)
    PyBuffer_New(object o)


cdef extern from "stdio.h":
    cdef void printf(char*, ...)

cdef extern from "stdlib.h":
    cdef void*malloc(unsigned int size)
    cdef void*free(void*p)
    char *strdup(char *str)
    int strcpy(void*str, void*src)
    int memcpy(void*str, void*src, int size)


from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair
ctypedef vector[double] vd
ctypedef pair[vd, vd] pvdvd

cdef extern from "btwxt.h" namespace "Btwxt":

    # enum class MsgLevel { MSG_DEBUG, MSG_INFO, MSG_WARN, MSG_ERR };
    cdef enum MsgLevel:
        MSG_DEBUG,
        MSG_INFO,
        MSG_WARN,
        MSG_ERR

    cdef enum Method:
        CONSTANT,
        LINEAR,
        CUBIC,
        UNDEF
    
# class GridAxis {
#   // A single input dimension of the performance space
# public:
#   GridAxis();

#   GridAxis(std::vector<double> grid_vector, Method extrapolation_method = Method::CONSTANT,
#                     Method interpolation_method = Method::LINEAR,
#                     std::pair<double, double> extrapolation_limits = {-DBL_MAX, DBL_MAX});

#   std::vector<double> grid;
#   std::vector<std::vector<double>> spacing_multipliers;
#   Method extrapolation_method;
#   Method interpolation_method;
#   std::pair<double, double> extrapolation_limits;

#   // bool is_regular;  <-- to add later

#   std::size_t get_length();

    
    cdef cppclass GridAxis:
        GridAxis(vector[double] grid_vector, Method extrapolation_method,
                 Method interpolation_method,
                 pvdvd extrapolation_limits)
        void set_interp_method(Method interpolation_method)
        void set_extrap_method(Method extrapolation_method)
        void set_extrap_limits(pvdvd extrap_limits)
        # double get_spacing_multiplier(const std::size_t &flavor, const std::size_t &index)

    cdef cppclass GriddedData:
        # grid is a vector of vectors 
        GriddedData()
        GriddedData(vector[vector[double]] grid, vector[vector[double]] values)
        size_t add_value_table(vector[double]& value_vector)
        size_t get_ndims()
        size_t get_num_tables()

    cdef cppclass RegularGridInterpolator:
        RegularGridInterpolator()
        RegularGridInterpolator(vector[vector[double]]& grid, vector[vector[double]]& values)
        void set_new_target(vector[double]& target)

    
cdef class PyGriddedData:
    """Wraps the GriddedData class.
    """
    cdef GriddedData *thisptr  # hold a C++ instance which we're wrapping
    def __cinit__(self):
        """ Creates an instance of the GriddedData class.
        InitOptions from the GriddedData class are substituted
        with separate properties.
        """
        # log_action("Creating a GriddedData instance")
        self.thisptr = new GriddedData()

    def __dealloc__(self):
        # log_action("Deleting the GriddedData instance")
        del self.thisptr


cdef class PyRegularGridInterpolator:
    """Wraps the RegularGridInterpolator class.
    """
    cdef RegularGridInterpolator *thisptr  # hold a C++ instance which we're wrapping
    def __cinit__(self, list grid, np.ndarray[np.float64_t, ndim=2] values):
        """ Creates an instance of the RegularGridInterpolator class.
        InitOptions from the RegularGridInterpolator class are substituted
        with separate properties.
        """
        # log_action("Creating a RegularGridInterpolator instance")
        cdef Py_ssize_t i, j, k
        
        cdef int n_dim = len(grid)
        cdef int n_tables = len(values)
        cdef vector[vector[double]] c_grid
        cdef vector[vector[double]] c_values
    
        for i in range(n_dim):
            c_grid.push_back(grid[i])
        for i in range(n_tables):
            c_values.push_back(values[i])

        self.thisptr = new RegularGridInterpolator(c_grid, c_values)

    def __dealloc__(self):
        # log_action("Deleting the RegularGridInterpolator instance")
        del self.thisptr


np.import_array()
# DTYPE = np.float64
# ctypedef np.float64_t DTYPE_t

@cython.boundscheck(False) # turn off bounds-checking for entire function
@cython.wraparound(False)  # turn off negative index wrapping for entire function
def gram(np.ndarray[np.float64_t, ndim=2] X, np.ndarray[np.float64_t, ndim=2] XTX):
    cdef double [:] narr_view
    
    cdef int m = X.shape[0]
    cdef int n = X.shape[1]
    # cdef int i, j, k
    cdef Py_ssize_t i, j, k
    cdef float value
    # cdef np.ndarray[np.float64_t, ndim=2] XTX = np.zeros([n, n], dtype=np.float64)
    # for k in range(m):
    # for i in range(n):
    for j in range(n):
        narr_view = X[:, j]
        # for k in range(m):
        for i in range(n):
            XTX[i, j] = np.dot(X[:, j], X[:, i])
            # value = 0.0
            # if j<k:
                
            # else:
            #     XTX[i, j] = XTX[j, i]
            # XTX[i, j] = value
    return XTX

# def say_hello_to(name):
#     print("Hello %s!" % name)