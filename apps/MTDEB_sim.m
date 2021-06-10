%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Simulation of MT-DEB, an energy transfer system for multi-tags network
% using distributed beamforming.
% 1. Power sources are synchronized with the Ref and PPS signal
% 2. Tags can detect the power to sync with power sources
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

%% System params
init_loc = -0.1;
D = 4;

Ntx = 8;
Ntag = 4;
Nc = 20;                % The number of carriers
if mod(Nc, 2) == 0
    cent_ind = Nc / 2 + 1;
else
    cent_ind = (Nc +1) /2;
end

Ptx = 1e2;              % Transmit power of each power source(20 dBm)

Stx = 1e6;              % Sample rate at the power source
Stag = Stx / Nc;        % Sample rate at the tag

fc = 915e6;
T = 1e-3;               % 1ms

Nsamp = Stx * T;        % The number of samples

Nloop = 1e3;

OPT_TYPE = "sum";  % max-min | sum

%% Channel model
loc_tx = device_deployment(init_loc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);


%% DOF Signal model
% TX signal
DOF_sig_f = zeros(Ntx, Nc);
for tx_ind = 1: Ntx
    DOF_sig_f(tx_ind, cent_ind + 1) = 1;
end
    
DOF_sig_t = ifft(fftshift(DOF_sig_f, 2), Nc, 2);

sig_tx = DOF_sig_t * sqrt(Ptx);

% Reflected signal
sig_rx = zeros(Ntag, Nc);

for tag_ind = 1: Ntag
    sig_rx(tag_ind, :) = Hb(tag_ind) * Hf(tag_ind, :) * sig_tx;
end

%% Channel estimation
Hest = zeros(Ntag, Ntx);
for tag_ind = 1: Ntag
    Hest(tag_ind, :) = Hb(tag_ind) * Hf(tag_ind, :);
    
    % The phase of the reference antenna does not affect the beamforming
    % performance.
    Hest(tag_ind, :) = Hest(tag_ind, :) / ...
        Hest(tag_ind, 1) * abs(Hest(tag_ind, 1));
end

power_max_rx = sum(abs(Hest), 2).^2 * Ptx;

%% Cold start performance
cs_relative_power = diag(sig_rx * sig_rx') ./ power_max_rx;

%% MT-DEB Phase alignment
MTDEB_weight = iterative_phase_alignment(Hest, Ntx, Nloop, OPT_TYPE);

MTDEB_power_rx = abs(Hest * MTDEB_weight * sqrt(Ptx)).^2;
MTDEB_relative_power_rx = MTDEB_power_rx ./ power_max_rx;

%% Relative power at each tag
power_max_tag = sum(abs(Hf), 2).^2 * Ptx;

MTDEB_power_tag = abs(Hf * MTDEB_weight * sqrt(Ptx)).^2;
MTDEB_relative_power_tag = MTDEB_power_tag ./ power_max_tag;

%% Power-based beamforming (Beamforming for 1 tag)
PBF_phase = -angle(Hest(1, :)).';
PBF_weight = exp(1j * PBF_phase);

PBF_power = abs(Hest * PBF_weight * sqrt(Ptx)).^2;
PBF_relative_power = PBF_power ./ power_max_rx;


%% Zero feedback beamforming

%% Evaluation
if OPT_TYPE == "maxmin"
    gain_MTDEB_PBF_maxmin = min(MTDEB_relative_power_rx) / min(PBF_relative_power);
elseif OPT_TYPE == "sum"
    gain_MTDEB_PBF_sum = sum(MTDEB_relative_power_rx) / sum(PBF_relative_power);
else
    error("OTP_TYPE must be maxmin or sum");
end
    
display(['Relative power of DOF cold start:          ' num2str(cs_relative_power.')]);
display(['MTDEB relative power (Measured at helper): ' num2str(MTDEB_relative_power_rx.')]);
display(['MTDEB relative power (Ground truth):       ' num2str(MTDEB_relative_power_tag.')]);
display(['PBF   relative power :                     ' num2str(PBF_relative_power.')]);
if OPT_TYPE == "maxmin"
    display(['Performance gain w/ max-min optimization: ' num2str(gain_MTDEB_PBF_maxmin.')]);
elseif OPT_TYPE == "sum"
    display(['Performance gain to maxmize the relative power: ' num2str(gain_MTDEB_PBF_sum.')]);
else
    error("OTP_TYPE must be maxmin or sum");
end

