%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Multi-frequencies-based channel estimation
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Hest = multifreq_channel_estimation(frame, Ntx, Nc)

% Params
cent_ind = Nc / 2 + 1;
carrier_index = [cent_ind-Ntx: cent_ind-1 cent_ind+1: cent_ind+Ntx];

frame = reshape(frame, Nc, []);

% FFT
H = fftshift(fft(frame, Nc, 1), 1);
H = mean(H, 2);

H = H(cent_ind-Ntx: cent_ind+Ntx);
cent_ind = Ntx +1;

% Time offset calibration
Hest = zeros(1, Ntx);
for tx_index = 1: Ntx
    amp = (abs(H(cent_ind -tx_index)) + abs(H(cent_ind + tx_index))) / 2;
    p = (angle(H(cent_ind -tx_index)) + angle(H(cent_ind + tx_index))) / 2;
    Hest(tx_index) = amp * exp(1j * p);
end

% Normalization
Hest = Hest / Hest(1) * abs(Hest(1));
