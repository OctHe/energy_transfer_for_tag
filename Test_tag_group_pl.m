%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of power-limited cluster algorithm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 


%% Parameter
InitLoc = -0.1;
D = 20;

fc = 900e6;            % Band, 900 MHz

Ntx = 4;
Ntag = 10;

amp_tx = 1e1;          % 20 dBm

Nloop = 1e3;

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
truth_ch = zeros(Ntag, Ntx);
norm_ch = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    truth_ch(Ntag_index, :) = Hb(Ntag_index) * Hf(Ntag_index, :);
    
    norm_ch(Ntag_index, :) = truth_ch(Ntag_index, :) / ...
        truth_ch(Ntag_index, 1) * abs(truth_ch(Ntag_index, 1));

end

%% Tag grouping
% phase alignment
Nloop = 1e3;
Pthre = -15;   % -15 dBm

group_mat = tag_group_power(Hf, Pthre, amp_tx, Nloop);
Ng = size(group_mat, 1)
Nt_g = Ntag / Ng