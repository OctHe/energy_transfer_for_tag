%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Carrier generator (including multi-freq signal and single-freq signal
%   Ntx: The number of TXs
%   Nc: The number of carriers
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preamble_t = carrier_generaion(Ntx, Nc, preamble_type)

center_index = Nc / 2 + 1;

if preamble_type == "multi-freq"
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_index = 1: Ntx
        preamble_tx_f(tx_index, center_index + tx_index) = 1;
        preamble_tx_f(tx_index, center_index - tx_index) = 1;
    end
    preamble_t = ifft(fftshift(preamble_tx_f, 2), Nc, 2);
    
elseif preamble_type == "single-freq"
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_index = 1: Ntx
        preamble_tx_f(tx_index, center_index + 1) = 1;
    end
    preamble_t = ifft(fftshift(preamble_tx_f, 2), Nc, 2);
    
else
    error("preamble type error!");
end

% Normalization
for tx_index = 1: Ntx
    Ppre = (preamble_t(tx_index, :) * preamble_t(tx_index, :)') / Nc;
    preamble_t(tx_index, :) = preamble_t(tx_index, :) / sqrt(Ppre);
end

