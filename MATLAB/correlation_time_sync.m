%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Correlation-based time synchronization algorithm
% sig_rx
% Nc
% thr: threshold (1e-5)
% D: deviation (1e-5)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [corr_res, start_ind] = correlation_time_sync(sig_rx, Ntag, Nc, Nf, thr, D)

% Params
energy_detected = false;
plateau_detected = false;

tag_ind = 0;

Nsamp = length(sig_rx);

corr_res = zeros(1, Nsamp - 2*Nc);
start_ind = zeros(Ntag, 1);

% Correlation
for samp_ind = 1: Nsamp - 2*Nc
    corr_res(samp_ind) = sig_rx(samp_ind: samp_ind + Nc -1) ...
        * sig_rx(samp_ind + Nc: samp_ind + 2*Nc -1)';
end

% Tag detection
for samp_ind = 1: length(corr_res) -1
    if corr_res(samp_ind) <= thr && corr_res(samp_ind +1) > thr
        energy_detected = true;
    end
    
    if abs(corr_res(samp_ind) - corr_res(samp_ind +1)) < D
        plateau_detected = true;
    end
    
    if energy_detected && plateau_detected
        tag_ind = tag_ind + 1;
        start_ind(tag_ind) = samp_ind + Nc;
        
        energy_detected = false;
        plateau_detected = false;
        
        samp_ind = samp_ind + Nf;   % Ignore the following Nf samples
    end
    
end