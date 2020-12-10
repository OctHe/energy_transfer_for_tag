%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of impact of carrier intervel in multi-freq design
% symbol length: 10 uS (bandwidth 100 KHz); sample rate: 20 MHz
% Ntxs: 2~4; Ntags: 1~4
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;
Ntags = 2;

sym_len = 10e-6;
samp_len = 1 / 20e6;        % 20 MHz
Ns = sym_len / samp_len;    % Number of samples (Number of carriers)

fi_txs = 100e3;                  % freq interval between txs
fc_txs = fi_txs * (0: (Ntxs-1)).';   
fi_tags = fi_txs * Ntxs;          % freq interval between tags 
fc_tags = fi_tags * (0: (Ntags-1)).';

%% Channel model
% Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
% Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));
Hf = ones(Ntags, Ntxs);
Hb = ones(1, Ntags);

%% Transmission model
multifreq_tx = exp(2j * pi * fc_txs * (0: (Ns-1)) * samp_len);
% Each tag shifts the freq
freq_shift_tag = exp(2j * pi * fc_tags * (0: (Ns-1)) * samp_len);

Z = Hf * multifreq_tx;
Y = Hb * (freq_shift_tag .* Z);

%% Figure
figure;
plot(abs(Y).^2);
figure;
plot(abs(fft(Y)));
