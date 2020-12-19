%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of channel correlation in different deployment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% Params
InitLoc = -1;
D = 12;
fc = 9e8;            % Band, 900 MHz

Ntxs = 12;
Nrxs = 20;

%% channel model
% distributed
loc_txs_distributed = device_deployment(InitLoc, D, Ntxs, "rectangle");
loc_rxs = [D / 2 * ones(1, Nrxs); (1/Nrxs: 1/Nrxs: 1) * D];
loc_target = [D / 4; D / 8];

ch_target = channel_model(loc_txs_distributed, loc_target, fc);
ch_rxs = channel_model(loc_txs_distributed, loc_rxs, fc);

corr_distributed = zeros(Nrxs, 1);
for rxs_index = 1: Nrxs
    corr_distributed(rxs_index) = abs(ch_rxs(rxs_index, :) * ch_target') / ...
        norm(ch_rxs(rxs_index, :)) / norm(ch_target);
end

% centrialized
loc_txs_centralized = device_deployment(InitLoc, D, Ntxs, "centralized");

ch_target = channel_model(loc_txs_centralized, loc_target, fc);
ch_rxs = channel_model(loc_txs_centralized, loc_rxs, fc);

corr_centralized = zeros(Nrxs, 1);
for rxs_index = 1: Nrxs
    corr_centralized(rxs_index) = abs(ch_rxs(rxs_index, :) * ch_target') / ...
        norm(ch_rxs(rxs_index, :)) / norm(ch_target);
end

%% Figure
figure; hold on;
plot(sort(corr_distributed))
plot(sort(corr_centralized))

