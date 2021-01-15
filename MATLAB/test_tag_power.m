%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of tag power and rx power
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 


%% Parameter
InitLoc = -0.1;
D = 35;

fc = 900e6;         % Band, 900 MHz

Ntx = 2;
Ntag = 2;
Amp_tx = 1e1;          % 20 dBm

Nloop = 1e3;

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [0.5; 1.1] * D;

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
truth_channel = zeros(Ntag, Ntx);
norm_channel = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    truth_channel(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    
    norm_channel(Ntag_index, :) = truth_channel(Ntag_index, :) / ...
        truth_channel(Ntag_index, 1) * abs(truth_channel(Ntag_index, 1));
    
end

%% Tag power and RX power
% bf_weight_norm = iterative_phase_alignment(norm_channel, Ntx, Nloop);
% bf_power_rx_norm = abs(truth_channel * bf_weight_norm * Ptx).^2;
% bf_power_rx_norm = 10 * log10(bf_power_rx_norm.')

% bf_power_tag_norm = abs(Hf * bf_weight_norm * Ptx).^2;
% bf_power_tag_norm = 10 * log10(bf_power_tag_norm.')

bf_weight_truth = iterative_phase_alignment(Hf, Ntx, Nloop);
% bf_power_rx_truth = abs(truth_channel * bf_weight_truth * Ptx).^2;
% bf_power_rx_truth = 10 * log10(bf_power_rx_truth.')

bf_power_tag_truth = abs(Hf * bf_weight_truth * Amp_tx).^2;
bf_power_tag_truth = 10 * log10(bf_power_tag_truth.')


%% Figure;
% figure; hold on;
% scatter(loc_tx(1, :), loc_tx(2, :));
% scatter(loc_tag(1, :), loc_tag(2, :));
% scatter(loc_rx(1, :), loc_rx(2, :));