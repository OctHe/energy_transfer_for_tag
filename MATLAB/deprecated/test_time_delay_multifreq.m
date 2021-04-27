%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of time-delay impact for multi-freq signal
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

Nc = 10;
Ntx = 4;

Dvec = 0: (Nc-1);

for D_ind = 1: 10
    
    pre_tx_t = carrier_generaion(Ntx, Nc, "expj_3");
    for tx_ind = 1: Ntx
        pre_tx_t(tx_ind, :) = circshift(pre_tx_t(tx_ind, :), D_ind);
    end
    
    pre_rx_t = sum(pre_tx_t, 1);
    pre_rx_f = fftshift(fft(pre_rx_t));
    
    [D, p] = time_delay_estimation(pre_rx_f, Nc, Ntx);
    D
end
