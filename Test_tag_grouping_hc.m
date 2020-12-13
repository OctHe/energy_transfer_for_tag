%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of tag grouping based on the hierarchical clustering algorithm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

% Params
Ntxs = 4;
Ntags = 8;

Res = 8;

Ng = 2;     % Number of group

% Channel model
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));

% RSS prober generator
W = generator_phase_mat(Ntxs, Res);
Ptx = kron(ones(1, Ntags), W);
Ptag = kron(eye(Ntags), ones(1, Res^(Ntxs-1)));

% Tranmission
Z = Hf * Ptx;
Y = Hb * (Ptag .* Z);
Y = reshape(Y.', [], Ntags).';

% Received power
PowerY = abs(Y).^2;

% Tag grouping
[Group, CosMatRX] = tag_grouping_hc(PowerY, Ntxs, Res);
Group

% Phase alignment
[~, APIndex] = max(min(PowerY, [], 1));
