%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Unit test of the codebook-based channel estimation with MMSE estimator
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;
Ntags = 1;

Rp = 3;    % The resolution of phase space for each power source

%% Channel model
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));

% The ground truth channel at the receiver
truth_channel = zeros(Ntags, Ntxs);
for Ntag_index = 1: Ntags
    truth_channel(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    truth_channel(Ntag_index, :) = truth_channel(Ntag_index, :) / ...
        truth_channel(Ntag_index, 1) * abs(truth_channel(Ntag_index, 1));
end

%% Transmission model
weight_mat = generator_phase_mat(Ntxs, Rp);
pre_tx = kron(ones(1, Ntags), weight_mat);
pre_tag = kron(eye(Ntags), ones(1, Rp^(Ntxs-1)));

Z = Hf * pre_tx;
Y = Hb * (pre_tag .* Z);
Y = reshape(Y, [], Ntags).';

%% Channel estimation with MMSE
Nloop = 1e7;

rx_rssi = abs(Y).^2;
estimated_channel = zeros(Ntags, Ntxs);
for Ntag_index = 1: Ntags
    [estimated_channel(Ntag_index, :), ~] = ...
        codebook_ce_mmse(rx_rssi(Ntag_index, :), weight_mat, Ntxs, Nloop);
    
end

%% Evaluation
for Ntag_index = 1: Ntags 
    truth_channel_buf = truth_channel(Ntag_index, :);
    estimated_channel_buf = estimated_channel(Ntag_index, :);
    
    ce_corr(Ntag_index) = abs(estimated_channel_buf * truth_channel_buf').^2 / ...
    abs(estimated_channel_buf * estimated_channel_buf') / ...
    abs(truth_channel_buf * truth_channel_buf');
    
    ce_mse(Ntag_index) = norm(estimated_channel_buf - truth_channel_buf).^2;
    
    figure; hold on;
    plot(abs(truth_channel_buf * weight_mat).');
    plot(abs(estimated_channel_buf * weight_mat).');
    
end

ce_corr
ce_mse
