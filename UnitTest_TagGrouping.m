%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Unit test of tag group
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

% Params
Ntxs = 4;
Ntags = 4;

Res = 8;

Ng = 2;     % Number of group

% Channel model
Hf = rand(Ntags, Ntxs) .* exp(2j * pi * rand(Ntags, Ntxs));
Hb = rand(1, Ntags) .* exp(2j * pi * rand(1, Ntags));

% RSS prober generator
W = PhaseMatrixGenerator(Ntxs, Res);
Ptx = kron(ones(1, Ntags), W);
Ptag = kron(eye(Ntags), ones(1, Res^(Ntxs-1)));

% Tranmission
Z = Hf * Ptx;
Y = Hb * (Ptag .* Z);
Y = reshape(Y.', [], Ntags).';

% Received power
PowerY = abs(Y).^2;
RelatPowerY = zeros(size(PowerY));
for Index = 1: Ntags
    RelatPowerY(Index, :) = PowerY(Index, :) / max(PowerY(Index, :));
end

% Tag grouping
[Group, CosMatRX] = TagGroupingAlgo(RelatPowerY, Ntxs, Res, Ng);
Group

% Phase alignment
[~, APIndex] = max(min(RelatPowerY, [], 1));
