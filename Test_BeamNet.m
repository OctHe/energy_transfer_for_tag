%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation of beamforming for multiple backscatter
% 1. Each tag transmit the signal one-by-one without frequency offset. The 
% frequency offset of each tag does not affect our design because we use a 
% power-based channel estimation.
% 2. Actually, This design can tranfer to a FDMA system where each tag 
% shift the signal to a orthogonal frequency.
% 3. The goal of this design is to fair the received power at the receiver
% instead of fairing the power at each tag. This is not practice in the 
% real world and need to be fixed.
% 4. The received signal detection at the receiver is not well-introduced. 
% This is also impractical and need to be fixed.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 2;
Ntags = 2;

Rp = 64;

%% Channel model
% We use a monostatic design to avoid the backward channel effect
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntxs) .* exp(2j * pi * rand(1, Ntags));

%% RSS probe generation and signal reflection
pre_tx = kron(ones(1, Ntags), PhaseMatrixGenerator(Ntxs, Rp));
pre_tag = kron(eye(Ntags), ones(1, Rp^(Ntxs-1)));

Z = Hf * pre_tx;
Y = Hb * (pre_tag .* Z);
Y = reshape(Y, [], Ntags);

%% Received power at the receiver
rx_power = abs(Y).^2;

%% Tag grouping and phase alignment



weight_mat = PhaseMatrixGenerator(Ntxs, Rp);
[~, bf_index] = max(min(rx_power, [], 1));
bf_weight = weight_mat(:, bf_index);

%% Evaluation
% Power transfer w/ beamforming
Z = Hf * bf_weight;
Y = Hb * (eye(Ntags) .* Z);

rx_power_w_bf = abs(Y).^2;
rx_power_w_bf = reshape(rx_power_w_bf, [], Ntags);

% Power transfer w/o beamforming
Z = Hf * (1/Ntxs * ones(Ntxs, 1));
Y = Hb * (eye(Ntags) .* Z);

rx_power_wo_bf = abs(Y).^2;
rx_power_wo_bf = reshape(rx_power_wo_bf, [], Ntags);

% Beamforming gain
bf_gain = min(rx_power_w_bf) / min(rx_power_wo_bf)

%% figure

figure;
plot(rx_power);
