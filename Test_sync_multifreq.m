%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of channel estimation in the multi-freq design with zero-forcing.
% The phase caused by multi-freq signal is ignored.
% Symbol length: 10 uS (bandwidth 100 KHz); Sample rate: 16 MHz
% Ntxs: 2~4; Ntags: 1~4
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
InitLoc = -0.1;
D = 4;

Ntx = 8;
Ntag = 1;

Ptx = 10e2;             % 20 dBm

% frequency and band
fc = 915e6;             % Band, 900 MHz

fi_tx = 100e3;                  % freq interval between txs, 100 KHz
fc_tx = fi_tx * (0: (Ntx-1)).';   
fi_tag = fi_tx * Ntx;          % freq interval between tags
fc_tag = fi_tag * (0: (Ntag-1)).';

% symbol length and sample rate
sym_len = 1 / fi_tx;
bw = 1.6e6;               % Total bandwidth (sample rate) 16 MHz
samp_len = 1 / bw;       % The maximal sample rate: 20 MHz
Ns = sym_len * bw;       % Number of samples

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

%% Transmission model
Nre = 4;    % repeat 5 times
t = 0: (Ns-1);

multifreq_tx = exp(2j * pi * fc_tx * t * samp_len);
% Each tag shifts the freq
freq_shift_tag = exp(2j * pi * fc_tag * t * samp_len);

Z = Hf * multifreq_tx * Ptx;
Y = Hb * (freq_shift_tag .* Z);

Y = repmat(Y, 1, Nre);

%% Time Sync for each tag
Ntag_max = Ns / Ntx;
fc_tags_max = fi_tag * (0: (Ntag_max-1)).';

multifreq_sync = zeros(Ntag, size(multifreq_tx, 2));
corr_res = zeros(Ntag_max, size(multifreq_tx, 2));
for Ntag_index = 1: Ntag_max
    % Freq shift
    multifreq_sync(Ntag_index, :) = ...
        exp(2j * pi * fc_tags_max(Ntag_index) * t * samp_len) ...
        .* sum(multifreq_tx, 1);
end

% Time sync
for Ntag_index = 1: Ntag_max
    for corr_index = Ns+1: Ns*Nre
        corr_res(Ntag_index, corr_index) = multifreq_sync(Ntag_index, :) ...
            * Y(corr_index - Ns +1: corr_index)';
    end
end

%% Figure;
figure;
plot(abs(corr_res.'));

