%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of channel estimation in the multi-freq design with zero-forcing
% Symbol length: 10 uS (bandwidth 100 KHz); Sample rate: 20 MHz
% Ntxs: 2~4; Ntags: 1~4
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;
Ntags = 8;

sym_len = 1 / 100e3;        % 100 KHz
samp_len = 1 / 20e6;        % 20 MHz
Ns = sym_len / samp_len;    % Number of samples (Number of carriers)

fi_txs = 100e3;                  % freq interval between txs
fc_txs = fi_txs * (0: (Ntxs-1)).';   
fi_tags = fi_txs * Ntxs;          % freq interval between tags 
fc_tags = fi_tags * (0: (Ntags-1)).';

%% Channel model
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));
% Hf = ones(Ntags, Ntxs);
% Hb = ones(1, Ntags);

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
multifreq_tx = exp(2j * pi * fc_txs * (0: (Ns-1)) * samp_len);
% Each tag shifts the freq
freq_shift_tag = exp(2j * pi * fc_tags * (0: (Ns-1)) * samp_len);

Z = Hf * multifreq_tx;
Y = Hb * (freq_shift_tag .* Z);

%% Channel estimation
rx_freq = fft(Y);  
rx_freq = rx_freq(1: Ntxs*Ntags);
est_channel = rx_freq / Ns;
est_channel = reshape(est_channel, Ntxs, Ntags).';
for Ntag_index = 1: Ntags
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    est_channel(Ntag_index, :) = est_channel(Ntag_index, :) / ...
        est_channel(Ntag_index, 1) * abs(est_channel(Ntag_index, 1));
end



