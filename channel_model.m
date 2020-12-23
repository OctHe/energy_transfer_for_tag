%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of different deployment of the power source
% loc_txs: 2xNtxs matrix. Ntxs is the number transmitters.
% loc_rxs: 2xNrxs matrix. Nrxs is the number receivers.
% f: Frequency. If f is a scalar, all tx-to-rx channel use the same
% frequency. Otherwise, length(f) must be the same as Ntx, and each tx
% uses different frequencies.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ch = channel_model(loc_txs, loc_rxs, f)

c = 3e8;            % Light speed
Ntx = size(loc_txs, 2);
Nrx = size(loc_rxs, 2);

dist_mat = zeros(Nrx, Ntx);
for rxs_index = 1: Nrx
    dist_mat(rxs_index, :) = sqrt((loc_txs(1, :) - loc_rxs(1, rxs_index)).^2 ...
        + (loc_txs(2, :) - loc_rxs(2, rxs_index)).^2);
end

% free space path loss model
if length(f) == 1
    ch = c ./ (4 * pi * f .* dist_mat) ...
        .* exp(2j * pi * (f / c .* dist_mat));
else
    ch = zeros(Nrx, Ntx);
    for Ntx_index = 1: Ntx
        ch(:, Ntx_index) = c ./ (4 * pi * f(Ntx_index) .* dist_mat(:, Ntx_index)) ...
        .* exp(2j * pi * (f(Ntx_index) / c .* dist_mat(:, Ntx_index)));
    end
end