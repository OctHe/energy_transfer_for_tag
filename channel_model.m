%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of different deployment of the power source
% loc_txs: 2xNtxs matrix. Ntxs is the number transmitters.
% loc_rxs: 2xNrxs matrix. Nrxs is the number receivers.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ch = channel_model(loc_txs, loc_rxs, f)

c = 3e8;            % Light speed
Ntxs = size(loc_txs, 2);
Nrxs = size(loc_rxs, 2);

dist_mat = zeros(Nrxs, Ntxs);
for rxs_index = 1: Nrxs
    dist_mat(rxs_index, :) = sqrt((loc_txs(1, :) - loc_rxs(1, rxs_index)).^2 ...
        + (loc_txs(2, :) - loc_rxs(2, rxs_index)).^2);
end

% free space path loss model
ch = c ./ (4 * pi *f .* dist_mat) .* exp(2j * pi * (f / c .* dist_mat));
