################################################################################
# 
# This is a transmission model for distributed
# devices
# 
################################################################################
#! /usr/bin/python3

import numpy as np
import matplotlib.pyplot as plt

import tx_distribution as tx_distri
import channel_model
import phase_alignment

def txs_to_target_channel(txs_loc, tar_loc, wave_len):

    H = np.zeros([np.size(tar_loc, 1), np.size(txs_loc, 1)], complex)

    for index in range(np.size(tar_loc, 1)):
        d_vec = np.sqrt((txs_loc[0] - tar_loc[0][index])**2 + (txs_loc[1] - tar_loc[1][index])**2)
        H[index][:] = channel_model.free_space_channel(d_vec, wave_len)

    return H


def main():

    # Wireless parameters
    f = 900e6
    c = 3e8
    wave_len = c / f

    # RoI parameters
    D = 10          # Region of interest
    R = 0.05           # Resolution of RoI
    interval = 2    # Interval between TXs and RoI

    # TXs and target setup
    N_txs = 8      # Number of TXs
    N_tar = 4
    target_loc = np.random.rand(2, N_tar) * D

    # Channel measurement
    txs_loc = tx_distri.rectangle_distribution(N_txs, D, interval)
    distri_txs = {'loc': txs_loc, 'power': 1e2 * np.ones(N_txs), 'weight': np.ones(N_txs)}
    # The maximum power is 1W at ISM band; The maximum power of USRP is 100mW

    H = txs_to_target_channel(distri_txs['loc'], target_loc, wave_len)

    # Phase alignment algorithm
    phase_alignment_algo = phase_alignment.fair_power_max(N_round=3)
    distri_txs['weight'] = phase_alignment_algo.iterative_search(H).T

    # Beamforming model
    received_power_mat = channel_model.pass_loss_in_RoI(distri_txs, wave_len, D, R)
    received_power_db_mat = 10 * np.log10(received_power_mat)
    received_power_vec = np.sort(np.reshape(received_power_db_mat, -1))

    # Received energy for the targets
    received_power_target = np.zeros(N_tar)
    for index_tar in range(N_tar):
        d_vec = np.sqrt((distri_txs['loc'][0] - target_loc[0][index_tar])**2 + (distri_txs['loc'][1] - target_loc[1][index_tar])**2)
        received_power_target[index_tar] = np.abs(np.dot(channel_model.free_space_channel(d_vec, wave_len), distri_txs['weight'] * distri_txs['power']))**2

    print(10 * np.log10(received_power_target))

    # Find the point with the maximum power
    max_received_power = received_power_vec[-1-N_tar: -1]
    max_loc = np.zeros([2, N_tar])
    for index_tar in range(N_tar):
       max_loc[1, index_tar], max_loc[0, index_tar] = np.where(received_power_db_mat == max_received_power[index_tar])
    max_loc = max_loc * R   # Transfer to the truly location

    print(max_received_power)

    # Plot
    fig, ax = plt.subplots()
    im = ax.imshow(received_power_db_mat, origin='lower', extent=(0, D, 0, D))
    ax.figure.colorbar(im, ax=ax)
    plt.scatter(target_loc[0], target_loc[1], marker='o', c='r')

    plt.scatter(max_loc[0], max_loc[1], marker='o', c='b')

    plt.show()

if __name__ == "__main__":
   
    main()
