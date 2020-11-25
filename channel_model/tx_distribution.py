################################################################################
# 
# This package is the distribution for N TXs 
# 
################################################################################

import numpy as np

def rectangle_distribution(N, D, interval):
   
    if N == 4:

        TXs_mat = np.array([[-interval, -interval, D + interval, D + interval], 
            [-interval, D + interval, -interval, D + interval]])
    
    elif N == 8:

        TXs_mat = np.array([[-interval, -interval, D + interval, D + interval, -interval, D/2, D/2, D + interval], 
            [-interval, D + interval, -interval, D + interval, D/2, -interval, D + interval, D/2]])

    else:

        N = N // 4

        axis_lower_vec = [-interval + x * (D + 2*interval) / N for x in range(N)]
        axis_upper_vec = [-interval + x * (D + 2*interval) / N for x in range(1, N+1)]

        TXs_mat = np.array([[-interval] * N + axis_lower_vec + axis_upper_vec + [D + interval] * N, 
            axis_upper_vec + [-interval] * N + [D + interval] * N + axis_lower_vec])

    return TXs_mat


def circle_distribution(N, D, radius):
    # N: the number of TXs
    # D: The length of RoI
    # radius: radius > sqrt(2) * D to avoid dividing zero

    TXs_mat = np.zeros([2, N])
    for index_n in range(0, N):
        TXs_mat[0][index_n] = radius * np.cos(index_n / N * 2 * np.pi) + D / 2
        TXs_mat[1][index_n] = radius * np.sin(index_n / N * 2 * np.pi) + D / 2

    return TXs_mat

def MIMO_distribution(N, D, intervel):

    TXs_mat = np.zeros([2, N])
    TXs_mat[0][:] = -intervel * np.ones([1, N])
    TXs_mat[1][:] = np.arange(-intervel, D + intervel, (D + 2*intervel)/N)

    return TXs_mat

