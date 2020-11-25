%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Unit test of the codebook-based channel estimation with MMSE estimator
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
Ntxs = 4;
Ntags = 1;

Rp = 4;    % The resolution of phase space for each power source

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

%% Channel estimation with MMSE
rx_power = abs(Y).^2;
ground_truth_channel = zeros(Ntags, Ntxs);
for Ntag_index = 1: Ntags
    ground_truth_channel(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
end

% MMSE channel space matrix
Nloop = 1e5;

estimated_channel = zeros(Ntags, Ntxs);
square_error_mat = zeros(Ntags, Nloop);
for Ntag_index = 1: Ntags
    
    [estimated_channel(Ntag_index, :), square_error_mat(Ntag_index, :)] ...
        = codebook_ce_mmse(rx_power, weight_mat, Ntxs, Nloop);
    
end

square_error_mat = sort(square_error_mat);
square_error = square_error_mat(:, 1);

%% Evaluation
estimated_channel
ground_truth_channel
square_error

%% figure

% figure;
% plot(rx_power.');
% figure;
% plot(abs(ground_truth_channel * weight_mat).^2);
figure;
plot(sort(square_error_mat.'));