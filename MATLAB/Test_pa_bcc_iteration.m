%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of phase alignment for multiple tags with fairness.
% We need to align the phase according to the backward channel coefficient
% (BCC).
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 

%% Parameter
InitLoc = -0.1;
D = 20;

fc = 915e6;             % Band, 900 MHz

Ntx = 12;
Ntag = 4;
amp_tx = 1e1;           % The amplitude of 20 dBm
Pthre = -12;            % -12 dBm

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

%% Phase alignment to focus energy on tags
% direct alignment
weight_direct = iterative_phase_alignment(norm_ch, Ntx, Nloop);
power_tag_direct = abs(Hf * weight_direct * amp_tx).^2;
power_rx_direct = abs(truth_ch * weight_direct * amp_tx).^2;
power_tag_direct = 10 * log10(power_tag_direct.')
power_rx_direct = 10 * log10(power_rx_direct.');

% ground truth
weight_truth = iterative_phase_alignment(Hf, Ntx, Nloop);
power_tag_truth = abs(Hf * weight_truth * amp_tx).^2;
power_rx_truth = abs(truth_ch * weight_truth * amp_tx).^2;

power_tag_truth = 10 * log10(power_tag_truth.');
power_rx_truth = 10 * log10(power_rx_truth.');

% backward channel coefficient (bcc) alignment 
% max power for each tag at the receiver, which is related to the
% coefficient
power_rx_max = zeros(Ntag, 1);
power_tag_max = zeros(Ntag, 1);
for Ntag_index = 1: Ntag
    power_tag_max(Ntag_index) = (sum(abs(Hf(Ntag_index, :))) * amp_tx).^2;
    power_rx_max(Ntag_index) = (sum(abs(truth_ch(Ntag_index, :))) * amp_tx).^2;
end
bcc = 1 ./ sqrt(power_rx_max);

weight_coeff = iterative_phase_alignment(bcc .* norm_ch, Ntx, Nloop);
power_tag_coeff = abs(Hf * weight_coeff * amp_tx).^2;
power_rx_coeff = abs(truth_ch * weight_coeff * amp_tx).^2;

power_tag_max = 10 * log10(power_tag_max.');
power_rx_max = 10 * log10(power_rx_max.');
power_tag_coeff = 10 * log10(power_tag_coeff.')
power_rx_coeff = 10 * log10(power_rx_coeff.');
