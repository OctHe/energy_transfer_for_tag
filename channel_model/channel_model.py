################################################################################
# 
# Channel models for 2-D distributed devices
# 
################################################################################
import numpy as np

def free_space_channel(d_vec, w_len):
   
    N = len(d_vec)
    ch_vec = w_len / (4 * np.pi * d_vec) * np.exp(2j * np.pi * d_vec / w_len)

    return ch_vec


def pass_loss_in_RoI(TXs, w_len, D, R):
    
    # Channel model
    N_mat = int(D / R)
    power_loss_mat = np.zeros([N_mat, N_mat])

    for index_x in range(0, N_mat):
    
        for index_y in range(0, N_mat):
	        
            mat_x = R * (index_x - 1)   # The x-axis of a position
            mat_y = R * (index_y - 1)   # The y-axis of a position
            d_vec = np.sqrt((TXs['loc'][0] - mat_x)**2 + (TXs['loc'][1] - mat_y)**2)

            ch_vec = free_space_channel(d_vec, w_len)
            power_loss_mat[index_y][index_x] = np.abs(np.sum(ch_vec * TXs['weight'] * TXs['power']))**2

    return power_loss_mat

    #  power_loss_db_mat = 10 * np.log10(power_loss_mat)     # dBm
    #  return power_loss_db_mat
