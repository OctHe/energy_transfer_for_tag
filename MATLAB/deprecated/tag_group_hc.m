%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Tag grouping algorithm according to the RSSI sequence and channel
% direction is based on the hierarchical clustering algorithm.
% Power: the received power
% Ntxs: the number power sources.
% Rp: Resolution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [GroupMat, CosMatRX] = tag_group_hc(power, Ntxs, R)

% Params
Ntag = size(power, 1);
W = generator_phase_mat(Ntxs, R);

% Correlation
ChIndexMat = zeros(Ntag, 1);
for Index = 1: Ntag
    [~, ChIndexMat(Index)] = max(power(Index, :));
    ChMat(Index, :) = W(:, ChIndexMat(Index))';
end
CosMatRX = abs(ChMat * ChMat');

% Tag group
ReCos = ones(Ntag, Ntag) - CosMatRX;
for Index = 1: Ntag
    ReCos(Index, Index) = 0;
end
G = linkage(squareform(ReCos));
G = cluster(G, 'maxclust', Ntxs);

GroupMat = zeros(Ntxs, Ntag);
for Index = 1: Ntag
    GroupMat(G(Index), Index) = 1;
end