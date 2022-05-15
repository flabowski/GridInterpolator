# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:42:36 2022

@author: florianma
"""
import numpy as np
cimport numpy as np
cimport cython

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