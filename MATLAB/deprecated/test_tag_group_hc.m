%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of tag grouping based on the hierarchical cluster algorithm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

% Params
Ntx = 4;
Ntag = 8;

Res = 8;

Ng = 2;     % Number of group

% Channel model
Hf = rand(Ntag, Ntx) .* exp(2j * pi * rand(Ntag, Ntx));
Hb = rand(1, Ntag) .* exp(2j * pi * rand(1, Ntag));

% RSS prober generator
W = generator_phase_mat(Ntx, Res);
Ptx = kron(ones(1, Ntag), W);
Ptag = kron(eye(Ntag), ones(1, Res^(Ntx-1)));

% Tranmission
Z = Hf * Ptx;
Y = Hb * (Ptag .* Z);
Y = reshape(Y.', [], Ntag).';

% Received power
PowerY = abs(Y).^2;

% Tag grouping
[Group, CosMatRX] = tag_group_hc(PowerY, Ntx, Res);
Group
Group1 = find(Group(1, :))

% Phase alignment
[~, APIndex] = max(min(PowerY, [], 1));
