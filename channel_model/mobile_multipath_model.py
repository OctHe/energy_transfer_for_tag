################################################################################
# 
# This is a multipath channel mode for air-to-ground communication
# 
################################################################################
#! /usr/bin/python3

import numpy as np
import matplotlib.pyplot as plt


def two_ray_channel_model(Dd, Dr, Lwave):
    # Dd: Direct distance
    # Dr: Reflect distance

    ch = (Lwave / 4 * np.pi) * (np.exp(2j * np.pi * Dd / Lwave) / Dd \
                               + np.exp(2j * np.pi * Dr / Lwave) / Dr)
    
    return ch

def main():

    B = 20e6    # 20 MHz
    Nfft = 64   # 64 subcarriers
    f = 5e9     # 5 GHz band
    c = 3e8     # Light speed

    Lwave = c / f

    ground_height = 1  # Height of the ground rx
    air_height = 30      # Height of the air tx
    Np = 2e3      # Number of point

    tx_power = 1e3  # 1W

    trace = np.linspace(0, 30, Np)

    Dd = np.sqrt(trace**2 + (air_height - ground_height)**2)
    Dr = np.sqrt(trace**2 + (air_height + ground_height)**2)

    ch = two_ray_channel_model(Dd, Dr, Lwave)

    received_power = 20 * np.log10(np.abs(ch * tx_power))
    
    received_power_difference = np.sort(np.abs(received_power[0: -2] - received_power[1: -1]))

    # Plot

    plt.figure()
    plt.plot(trace, received_power)
    plt.figure()
    plt.plot(received_power_difference)

    plt.show()
    

if __name__ == "__main__":
    main()
