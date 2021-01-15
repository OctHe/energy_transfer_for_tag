%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation of BeamNet, an energy transfer system for multi-tags network
% using distributed beamforming
% 1. power sources are not synchronized and have frequency offset
% 2. Each tag are awaked according to the received power (ground truth)
% 3. Each tag are shift the frequency and has a frequency offset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;


%% System params
loc_init = -0.1;
D = 4;

Ntx = 4;
Ntag = 2;

fc = 915e6;
Nc = 20;                % The number of carriers
Ptx = 1e2;              % Transmit power of each power source(20 dBm)

Stx = 2e6;              % sample rate of power sources (2 MHz)
Stag = 1e5;             % Sample rate of tags (100 KHz)
T = 1e-3;               % 1ms

sym_tag = 10;
sym_rx = 6;             % Effective symbols in 1 frame at RX

Nsamp = Stx * T;        % The number of samples
Nf = sym_tag * Nc;      % 10 symbols in 1 tag frame

Dtx = randi(Nc, Ntx, 1) -1;     % Delay of each TX
Dtag = randi(Nsamp / Ntag - Nf, Ntag, 1) -1;    % Delay of each tag

Dtx = zeros(Ntx, 1);

%% Channel model
loc_tx = device_deployment(loc_init, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

%% Ground truth
% Channel at RX
Htru = zeros(Ntag, Ntx);
for tag_ind = 1: Ntag
    Htru(tag_ind, :) = Hb(tag_ind) * Hf(tag_ind, :);
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    Htru(tag_ind, :) = Htru(tag_ind, :) / ...
        Htru(tag_ind, 1) * abs(Htru(tag_ind, 1));
end

% Maximal power for each tag
max_power_tag = diag(Hf * Hf') * Ptx;
max_power_rx = diag(Htru * Htru') * Ptx;

% start index
for tag_ind = 1: Ntag
    start_ind_truth(tag_ind) = Dtag(tag_ind) + (tag_ind -1) * Nsamp / Ntag;
end
%% Signal model
% TX signal
pre_tx = carrier_generaion(Ntx, Nc, "multi-freq");
for tx_ind = 1: Ntx
    pre_tx(tx_ind, :) = circshift(pre_tx(tx_ind, :), Dtx(tx_ind));
end
sig_tx = repmat(pre_tx, 1, Nsamp / Nc) * sqrt(Ptx);

% reflected signal
sig_rx = zeros(Ntag, Nsamp / Ntag);
for tag_ind = 1: Ntag
    sig_rx(tag_ind, Dtag(tag_ind) +1: Dtag(tag_ind) + Nf) = ...
        Hb(tag_ind) * Hf(tag_ind, :) * ...
        sig_tx(:, Dtag(tag_ind) +1: Dtag(tag_ind) + Nf);
end
sig_rx = reshape(sig_rx.', [], 1).';

%% Synchronization
[corr_res, start_ind] = correlation_time_sync(sig_rx, Ntag, Nc, Nf, 1e-5, 1e-10);
start_ind

frame_rx = zeros(Ntag, sym_rx * Nc);
for tag_ind = 1: Ntag
    frame_rx(tag_ind, :) = sig_rx(start_ind(tag_ind) +1: start_ind(tag_ind) + sym_rx * Nc);
end

%% Channel estimation
Hest = zeros(Ntag, Ntx);
for tag_ind = 1: Ntag
    Hest(tag_ind, :) = multifreq_channel_estimation(frame_rx(tag_ind, :), Ntx, Nc);
end

angle(Htru)

angle(Hest)

%% Phase alignment


%% Figure
figure;
plot(abs(sig_rx));