%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Tag grouping algorithm according to the RSSI sequence and channel
% direction is based on the hierarchical clustering algorithm.
% Power: the received power
% Ntxs: the number power sources. The number of devices in a group is equal
% to Ntxs
% Rp: The resolution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [GroupMat, CosMatRX] = tag_grouping_hc(power, Ntxs, Rp)

% Params
Ntags = size(power, 1);
W = PhaseMatrixGenerator(Ntxs, Rp);

% Correlation
ChIndexMat = zeros(Ntags, 1);
for Index = 1: Ntags
    [~, ChIndexMat(Index)] = max(power(Index, :));
    ChMat(Index, :) = W(:, ChIndexMat(Index))';
end
CosMatRX = abs(ChMat * ChMat');

% Tag group
ReCos = ones(Ntags, Ntags) - CosMatRX;
for Index = 1: Ntags
    ReCos(Index, Index) = 0;
end
G = linkage(squareform(ReCos));
G = cluster(G, 'maxclust', Ntxs);

GroupMat = zeros(Ntxs, Ntags);
for Index = 1: Ntags
    GroupMat(G(Index), Index) = 1;
end