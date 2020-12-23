%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of channel estimation in the multi-freq design with zero-forcing.
% The phase caused by multi-freq signal is ignored.
% Symbol length: 10 uS (bandwidth 100 KHz); Sample rate: 16 MHz
% Ntxs: 8; Ntags: 10
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
InitLoc = -0.1;
D = 30;

Ntx = 8;
Ntag = 10;

% frequency and band
fc = 914e6;             % Band, 900 MHz
fi_tx = 100e3;                  % freq interval between txs, 100 KHz

fc_tx = fi_tx * (0: (Ntx-1)).';   
fi_tag = fi_tx * Ntx;          % freq interval between tags
fc_tag = fi_tag * (0: (Ntag-1)).';

% symbol length and sample rate
sym_len = 1 / fi_tx;
bw = 2e6;               % Total bandwidth (sample rate) 16 MHz
samp_len = 1 / bw;       % The maximal sample rate: 20 MHz
Ns = sym_len * bw;       % Number of samples

Nt = bw / fi_tx;        % Number of tones

Nloop = 1e3;

Ptx = 1e2;

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

bf_power_freq = zeros(Nt, Ntag);

for Nt_index = 1: Nt
    Hf = channel_model(loc_tx, loc_tag, fc + fi_tx * Nt_index);
    Hb = channel_model(loc_tag, loc_rx, fc + fi_tx * Nt_index);
    
    % The ground truth channel at the receiver
    norm_ch = zeros(Ntag, Ntx);
    truth_ch = zeros(Ntag, Ntx);
    for Ntag_index = 1: Ntag
        truth_ch(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);

        norm_ch(Ntag_index, :) = truth_ch(Ntag_index, :) / ...
            truth_ch(Ntag_index, 1) * abs(truth_ch(Ntag_index, 1));
    end

    % correlation matrix
    ch_abs = sqrt(diag(abs(Hf * Hf')));
    ch_cos = abs(Hf * Hf') ./ (ch_abs * ch_abs');

    % phase alignment
    bf_weight = iterative_phase_alignment(Hf, Ntx, Nloop);
    bf_power = abs(Hf * bf_weight * Ptx).^2;
    bf_power = 10 * log10(bf_power);
    
    bf_power_freq(Nt_index, :) = bf_power;
    
end

figure;
plot(bf_power_freq);

figure;
plot(min(bf_power_freq, [], 2));