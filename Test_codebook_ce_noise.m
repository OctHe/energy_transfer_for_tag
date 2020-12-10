%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Comparison between the power-based and IQ-based channel estimation
% The channel includes the awgn noise.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;

Rp = 3;    % The resolution of phase space for each power source

snr = -6;

Nloop = 1e5;

%% Channel model
Hf = rand(1, Ntxs) .* exp(2j * pi * rand(1, Ntxs));
Hb = rand(1, 1) .* exp(2j * pi * rand(1, 1));

% The ground truth channel at the receiver
% The phase of the reference antenna does not affect the beamforming
% performance.
truth_channel = Hb * Hf;
truth_channel = truth_channel / truth_channel(1) * abs(truth_channel(1));

%% Transmission model
Ns = 35;
weight_mat = generator_phase_mat(Ntxs, Rp);
pre_tx = kron(weight_mat, ones(1, Ns));
pre_tag = ones(1, size(pre_tx, 2));

Z = Hf * pre_tx;
Y = Hb * (pre_tag .* Z);

rx_rssi = abs(Y).^2;
rx_rssi = reshape(rx_rssi, Ns, []);
rx_rssi = mean(rx_rssi, 1);

figure; hold on;
plot(rx_rssi);

Y = awgn(Y, snr, 'measured');

%% Channel estimation with power using MMSE
rx_rssi = abs(Y).^2;
rx_rssi = reshape(rx_rssi, Ns, []);
rx_rssi = mean(rx_rssi, 1);

plot(rx_rssi);

[estimated_channel_power, ~] = codebook_ce_mmse(rx_rssi, weight_mat, Ntxs, Nloop);

%% Channel estimation with IQ using ZF
estimated_channel_IQ = Y / pre_tx;
estimated_channel_IQ = estimated_channel_IQ / ...
    estimated_channel_IQ(1) * abs(estimated_channel_IQ(1));

%% Evaluation
ce_corr(1) = abs(estimated_channel_IQ * truth_channel').^2 / ...
abs(estimated_channel_IQ * estimated_channel_IQ') / ...
abs(truth_channel * truth_channel');

ce_mse(1) = norm(estimated_channel_IQ - truth_channel).^2;


ce_corr(2) = abs(estimated_channel_power * truth_channel').^2 / ...
abs(estimated_channel_power * estimated_channel_power') / ...
abs(truth_channel * truth_channel');

ce_mse(2) = norm(estimated_channel_power - truth_channel).^2;

ce_corr
ce_mse
