%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of phase alignment for multiple tags with fairness. This algorithm 
% is based on the iteration and derived from the 1-bit phase alignment.
% This test shows that the norm_channel is equalized to the truth_channel
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 


%% Parameter
InitLoc = -0.1;
D = 4;

fc = 900e6;            % Band, 900 MHz

Ntx = 4;
Ntag = 4;
Ptx = 1e2;          % 20 dBm

Nloop = 1e3;

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
truth_ch = zeros(Ntag, Ntx);
norm_ch = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    truth_ch(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    
    norm_ch(Ntag_index, :) = truth_ch(Ntag_index, :) / ...
        truth_ch(Ntag_index, 1) * abs(truth_ch(Ntag_index, 1));

end

%% Iterative phase alignment
bf_weight_ite_norm = iterative_phase_alignment(norm_ch, Ntx, Nloop);
bf_power_ite_norm = abs(truth_ch * bf_weight_ite_norm * Ptx).^2;
bf_power_ite_norm = 10 * log10(bf_power_ite_norm);

bf_weight_ite_truth = iterative_phase_alignment(truth_ch, Ntx, Nloop);
bf_power_ite_truth = abs(truth_ch * bf_weight_ite_truth * Ptx).^2;
bf_power_ite_truth = 10 * log10(bf_power_ite_truth);

%% Exhausted phase alignment
signal_tx = generator_phase_mat(Ntx, 8) * Ptx;
power_rx = abs(truth_ch * signal_tx).^2;

[~, bf_index_exh] = max(min(power_rx, [], 1));
bf_power_exh = 10 * log10(power_rx(:, bf_index_exh));

gain_truth = min(bf_power_ite_truth) - min(bf_power_exh)
gain_norm = min(bf_power_ite_norm) - min(bf_power_exh)


