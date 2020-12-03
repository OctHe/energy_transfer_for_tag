%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation of beamforming for multiple backscatter
% 1. Each tag transmit the signal one-by-one without frequency offset. The 
% frequency offset of each tag does not affect our design because we use a 
% power-based channel estimation.
% 2. Actually, This design can tranfer to a FDMA system where each tag 
% shift the signal to a orthogonal frequency.
% 4. The received signal detection at the receiver is not well-introduced. 
% This is also impractical and need to be fixed.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;
Ntags = 2;

Rp = 16;    % The resolution of phase space for each power source

%% Channel model
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));

%% RSS probe generation and signal reflection
weight_mat = PhaseMatrixGenerator(Ntxs, Rp);
pre_tx = kron(ones(1, Ntags), weight_mat);
pre_tag = kron(eye(Ntags), ones(1, Rp^(Ntxs-1)));

Z = Hf * pre_tx;
Y = Hb * (pre_tag .* Z);
Y = reshape(Y, [], Ntags).';

%% Channel estimation
abs_rx = abs(Y);    % amplitude at the power source

% Eliminate the impact of the backward channel
estimated_channel = zeros(size(abs_rx));
for tag_index = 1: Ntags
   estimated_channel(tag_index, :) = abs_rx(tag_index, :) / max(abs_rx(tag_index, :));
    
end

%% Phase alignment
[~, bf_index] = max(min(estimated_channel, [], 1));

weight_mat = PhaseMatrixGenerator(Ntxs, Rp);
bf_weight = weight_mat(:, bf_index);


%% Evaluation
% Power transfer w/ beamforming
Z = Hf * bf_weight;
Y = Hb * (eye(Ntags) .* Z);

rx_power_w_bf = abs(Y).^2;
rx_power_w_bf = reshape(rx_power_w_bf, [], Ntags)

% % Power transfer w/o beamforming
% Z = Hf * (1/Np * ones(Np, 1));
% Y = Hb * (eye(Nt) .* Z);
% 
% rx_power_wo_bf = abs(Y).^2;
% rx_power_wo_bf = reshape(rx_power_wo_bf, [], Nt);
% 
% % Beamforming gain
% bf_gain = min(rx_power_w_bf) / min(rx_power_wo_bf)

%% figure

figure;
plot(estimated_channel.');


