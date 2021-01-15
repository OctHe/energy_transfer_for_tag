%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Unit test of the codebook-based channel estimation with MMSE estimator
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntx = 4;
Ntag = 1;

Rp = 3;    % The resolution of phase space for each power source

%% Channel model
Hf = rand(Ntag, Ntx) .* exp(2j * pi * rand(Ntag, Ntx));
Hb = rand(1, Ntag) .* exp(2j * pi * rand(1, Ntag));

% The ground truth channel at the receiver
truth_channel = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    truth_channel(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    truth_channel(Ntag_index, :) = truth_channel(Ntag_index, :) / ...
        truth_channel(Ntag_index, 1) * abs(truth_channel(Ntag_index, 1));
end

%% Transmission model
weight_mat = generator_phase_mat(Ntx, Rp);
pre_tx = kron(ones(1, Ntag), weight_mat);
pre_tag = kron(eye(Ntag), ones(1, Rp^(Ntx-1)));

Z = Hf * pre_tx;
Y = Hb * (pre_tag .* Z);
Y = reshape(Y, [], Ntag).';

%% Channel estimation with MMSE
Nloop = 1e7;

rx_rssi = abs(Y).^2;
est_channel = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    [est_channel(Ntag_index, :), ~] = ...
        codebook_ce_mmse(rx_rssi(Ntag_index, :), weight_mat, Ntx, Nloop);
    
end

%% Evaluation
for Ntag_index = 1: Ntag 
    truth_channel_buf = truth_channel(Ntag_index, :);
    est_channel_buf = est_channel(Ntag_index, :);
    
    ce_corr(Ntag_index) = abs(est_channel_buf * truth_channel_buf').^2 / ...
    abs(est_channel_buf * est_channel_buf') / ...
    abs(truth_channel_buf * truth_channel_buf');
    
    ce_mse(Ntag_index) = norm(est_channel_buf - truth_channel_buf).^2;
    
    figure; hold on;
    plot(abs(truth_channel_buf * weight_mat).');
    plot(abs(est_channel_buf * weight_mat).');
    
end

ce_corr
ce_mse
