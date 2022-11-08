from time import time
import numpy as np
cimport numpy as cnp
cimport cython

cdef int kernel(double zr, double zi, double cr, double ci, double lim, int cutoff):
    ''' Computes the number of iterations `n` such that 
        |z_n| > `lim`, where `z_n = z_{n-1}**2 + c`.
    '''
    cdef int count = 0
    while ((zr*zr + zi*zi) < (lim*lim)) and count < cutoff:
        zr, zi = zr * zr - zi * zi + cr, 2 * zr * zi + ci
        count += 1
    return count

@cython.boundscheck(False)
@cython.wraparound(False)
def compute_mandel( double cr,  double ci,  double N,  double bound=1.5, double lim=1000., int cutoff=1000000):
    '''
    Se ha de generar un objeto mandel basado en cnp array de dos dimensiones del tipo entero
    '''
    cdef cnp.ndarray[cnp.int_t, ndim=2] mandel
    mandel = np.empty((N, N), dtype=int)
    cdef cnp.ndarray[cnp.double_t, ndim=1] grid_x
    grid_x = np.linspace(-bound, bound, N)
    cdef int i,j
    cdef double x, y

    
    
    t0 = time()
    for i, x in enumerate(grid_x):
        for j, y in enumerate(grid_x):
            mandel[i,j] = kernel(x, y, cr, ci, lim, cutoff)
    return mandel, time() - t0

