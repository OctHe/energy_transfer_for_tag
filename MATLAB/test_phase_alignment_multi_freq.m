%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of phase alignment with multi-freq signal
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
loc_init = -0.1;
D = 5;

Ntx = 4;
Ntag = 1;

% frequency and band
fc = 915e6;             % Band, 915 MHz

Ptx = 1e2;              % 20 dBm

Stx = 2e6;              % Sample rate: 20 MHz;
Stag = 100e3;           % Sample rate: 100 KHz;

T = 1e-3;
Nsamp = Stx * T;        % The number of samples
Nsym = Stag * T;        % The number of symbols

Nc = 20;                % The number of carriers

%% Channel model
loc_tx = device_deployment(loc_init, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
Htru = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    Htru(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    Htru(Ntag_index, :) = Htru(Ntag_index, :) / ...
        Htru(Ntag_index, 1) * abs(Htru(Ntag_index, 1));
end

%% Phase alignment for multi-freq signal
preamble_multi_t = carrier_generaion(Ntx, Nc, "multi-freq");

% Aligned phase
W = iterative_phase_alignment(Hf, Ntx, 1e3);

% TX signal
symbol_tx = preamble_multi_t .* repmat(W, 1, Nc);
sig_tx = repmat(symbol_tx, 1, Nsym) * sqrt(Ptx);

power_tx = 10 * log10(diag(sig_tx * sig_tx') / Nsamp);

sig_tag = Hf * sig_tx;

power_tag = 10 * log10(diag(sig_tag * sig_tag') / Nsamp)

%% Baseline: Tag's power without phase alignment
preamble_multi_t = carrier_generaion(Ntx, Nc, "multi-freq");

% Aligned phase
W = exp(2j * zeros(Ntx,1));

% TX signal
symbol_tx = preamble_multi_t .* repmat(W, 1, Nc);
sig_tx = repmat(symbol_tx, 1, Nsym) * sqrt(Ptx);

power_tx = 10 * log10(diag(sig_tx * sig_tx') / Nsamp);

sig_tag = Hf * sig_tx;

power_tag = 10 * log10(diag(sig_tag * sig_tag') / Nsamp)

%% Baseline: Phase alignment for single carrier signal
preamble_single_t = carrier_generaion(Ntx, Nc, "single-freq");

% Aligned phase
W = iterative_phase_alignment(Hf, Ntx, 1e3);

% TX signal
symbol_tx = preamble_single_t .* repmat(W, 1, Nc);
sig_tx = repmat(symbol_tx, 1, Nsym) * sqrt(Ptx);

power_tx = 10 * log10(diag(sig_tx * sig_tx') / Nsamp);

sig_tag = Hf * sig_tx;

power_tag = 10 * log10(diag(sig_tag * sig_tag') / Nsamp)

%% Baseline: Phase alignment for single carrier signal
preamble_single_t = carrier_generaion(Ntx, Nc, "single-freq");

% Aligned phase
W = exp(2j * zeros(Ntx,1));

% TX signal
symbol_tx = preamble_single_t .* repmat(W, 1, Nc);
sig_tx = repmat(symbol_tx, 1, Nsym) * sqrt(Ptx);

power_tx = 10 * log10(diag(sig_tx * sig_tx') / Nsamp);

sig_tag = Hf * sig_tx;

power_tag = 10 * log10(diag(sig_tag * sig_tag') / Nsamp)

