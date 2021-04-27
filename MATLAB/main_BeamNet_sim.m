%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation of BeamNet, an energy transfer system for multi-tags network
% using distributed beamforming
% 1. Power sources are not synchronized
% 2. Power sources and tags are not synchronized
% 3. Each tag are shift the frequency and has a frequency offset
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% System params
FLAG_TX_DELAY = false;
FLAG_TAG_DELAY = false;
FLAG_SYNC = false;

init_loc = -0.1;
D = 4;

Ntx = 4;
Ntag = 4;
Nc = 20;                % The number of carriers

Ptx = 1e2;              % Transmit power of each power source(20 dBm)

Stx = 1e6;              % Sample rate
Stag = Stx / Nc;

fc = 915e6;
T = 1e-3;               % 1ms

sym_tag = 10;           % The number of symbols in a tag
sym_rx = 8;             % Effective symbols in 1 frame at RX

Nsamp = Stx * T;        % The number of samples
Nf = sym_tag * Nc;      % 10 symbols in 1 tag frame

if FLAG_TX_DELAY
    Dtx = randi(Nc, 1, Ntx) -1;     % Delay of each TX
else
    Dtx = zeros(1, Ntx);
end

if FLAG_TAG_DELAY
    Dtag = randi(Nsamp / Ntag - Nf, Ntag, 1) -1;    % Delay of each tag
else
    Dtag = zeros(Ntag, 1);
end

%% Channel model
loc_tx = device_deployment(init_loc, D, Ntx, "rectangle");
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

% Frame start index
start_ind_truth = zeros(Ntag, 1);
for tag_ind = 1: Ntag
    start_ind_truth(tag_ind) = Dtag(tag_ind) + (tag_ind -1) * Nsamp / Ntag;
end

if FLAG_TX_DELAY
    Dtx
end

if FLAG_TAG_DELAY
   	Dtag_truth = mod(Dtag, Nc)
end

%% Signal model
% TX signal
pre_tx = carrier_generaion(Ntx, Nc, "expj_3");
for tx_ind = 1: Ntx
    pre_tx(tx_ind, :) = circshift(pre_tx(tx_ind, :), -Dtx(tx_ind));
end
sig_tx = repmat(pre_tx, 1, Nsamp / Nc) * sqrt(Ptx);

% Reflected signal
sig_rx = zeros(Ntag, Nsamp / Ntag);
for tag_ind = 1: Ntag
    sig_rx(tag_ind, Dtag(tag_ind) +1: Dtag(tag_ind) + Nf) = ...
        Hb(tag_ind) * Hf(tag_ind, :) * ...
        sig_tx(:, Dtag(tag_ind) +1: Dtag(tag_ind) + Nf);
end
sig_rx = reshape(sig_rx.', [], 1).';

%% Tag reflection detection
Hest = zeros(Ntag, Ntx);

if FLAG_SYNC
    [corr_res, start_ind] = correlation_time_sync(sig_rx, Ntag, Nc, Nf, 1e-5, 1e-10);
else
    start_ind = start_ind_truth;
end

%% Signal processing for each tag
for tag_ind = 1: Ntag
    frame_rx_t = sig_rx(start_ind(tag_ind) +1: start_ind(tag_ind) + sym_rx * Nc);
    frame_rx_t = reshape(frame_rx_t, Nc, sym_rx);
    
    frame_rx_f = fftshift(fft(frame_rx_t, Nc, 1), 1);
    symbol_rx_f = mean(frame_rx_f, 2);
    
    % Time delay estimation
    D = time_delay_estimation(symbol_rx_f, Nc, Ntx, "expj_3");
    
    % Channel estimation
    Hest(tag_ind, :) = multifreq_channel_estimation(symbol_rx_f, Nc, Ntx, "expj_3");
    
    % Channel process
    Hest(tag_ind, :) = Hest(tag_ind, :) / ...
        Hest(tag_ind, 1) * abs(Hest(tag_ind, 1));
    
    Hest(tag_ind, :) = Hest(tag_ind, :) / ...
        sqrt(Hest(tag_ind, :) * Hest(tag_ind, :)');
    
end

%% Phase alignment
Nloop = 1e3;
bf_weight_ite = iterative_phase_alignment(Hest, Ntx, Nloop);

%% Baseline

%% Evaluation
bf_power_ite = abs(Htru * bf_weight_ite * sqrt(Ptx)).^2;
bf_power_ite = 10 * log10(bf_power_ite);

power_ite = abs(Htru * ones(Ntx, 1) * sqrt(Ptx)).^2;
power_ite = 10 * log10(power_ite);

bf_gain = min(bf_power_ite) - min(power_ite)

%% Figure
figure;
plot(abs(sig_rx));