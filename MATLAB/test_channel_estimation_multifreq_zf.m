%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of channel estimation in the multi-freq design with zero-forcing.
% The phase caused by multi-freq signal is ignored.
% Symbol length: 10 uS (bandwidth 100 KHz); Sample rate: 20 MHz
% Ntxs: 2~4; Ntags: 1~4
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
InitLoc = -0.1;
D = 4;

Ntx = 8;
Ntag = 4;

fc = 915e6;            % Band, 900 MHz

fi_tx = 100e3;                  % freq interval between txs, 100 KHz
fc_tx = fi_tx * (0: (Ntx-1)).';   
fi_tag = fi_tx * Ntx;          % freq interval between tags
fc_tag = fi_tag * (0: (Ntag-1)).';

% symbol length and sample rate
sym_len = 1 / fi_tx;
bw = 16e6;               % Total bandwidth (sample rate) 16 MHz
samp_len = 1 / bw;       % The maximal sample rate: 20 MHz
Ns = sym_len * bw;       % Number of samples

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
norm_ch = zeros(Ntag, Ntx);
truth_ch = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    truth_ch(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    norm_ch(Ntag_index, :) = truth_ch(Ntag_index, :) / ...
        truth_ch(Ntag_index, 1) * abs(truth_ch(Ntag_index, 1));
end

%% Transmission model
multifreq_tx = exp(2j * pi * fc_tx * (0: (Ns-1)) * samp_len);
% Each tag shifts the freq
freq_shift_tag = exp(2j * pi * fc_tag * (0: (Ns-1)) * samp_len);

Z = Hf * multifreq_tx;
Y = Hb * (freq_shift_tag .* Z);

%% Channel estimation
rx_freq = fft(Y);  
rx_freq = rx_freq(1: Ntx*Ntag);
est_channel = rx_freq / Ns;
est_channel = reshape(est_channel, Ntx, Ntag).';
for Ntag_index = 1: Ntag
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    est_channel(Ntag_index, :) = est_channel(Ntag_index, :) / ...
        est_channel(Ntag_index, 1) * abs(est_channel(Ntag_index, 1));
end

%% Figure;
figure;
plot(abs(Y));
