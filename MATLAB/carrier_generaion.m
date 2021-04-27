%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Carrier generator (including multi-freq signal and single-freq signal
%   Ntx: The number of TXs
%   Nc: The number of carriers
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preamble_t = carrier_generaion(Ntx, Nc, preamble_type)

if mod(Nc, 2) == 0
    cent_ind = Nc / 2 + 1;
else
    cent_ind = (Nc +1) /2;
end

if preamble_type == "cos"
    
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_ind = 1: Ntx
        preamble_tx_f(tx_ind, cent_ind + tx_ind) = 1;
        preamble_tx_f(tx_ind, cent_ind - tx_ind) = 1;
    end
    
elseif preamble_type == "cos_2"
    
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_ind = 1: Ntx
        preamble_tx_f(tx_ind, cent_ind - tx_ind *2) = 1;
        preamble_tx_f(tx_ind, cent_ind - (tx_ind *2 -1)) = 1;
        
        preamble_tx_f(tx_ind, cent_ind + tx_ind *2) = 1;
        preamble_tx_f(tx_ind, cent_ind + (tx_ind *2 -1)) = 1;
        
    end
    
elseif preamble_type == "expj_3"
    
    Nsc = 3;
    
    if Nc <= Ntx * Nsc +1
        error("Nc must larger than (Ntx *3 +1)");
    end
    
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_ind = 1: Ntx
        % subcarrier index allocation
        if mod(tx_ind, 2) == 1
            tx_flag = (tx_ind +1) / 2;
            sub_ind = (cent_ind - tx_flag *3) : (cent_ind - tx_flag *3 +2);
        else
            tx_flag = tx_ind / 2;
            sub_ind = (cent_ind + tx_flag *3 -2) : (cent_ind + tx_flag *3);
        end
        
        preamble_tx_f(tx_ind, sub_ind) = 1;
        
    end
    
elseif preamble_type == "single-freq"
    
    preamble_tx_f = zeros(Ntx, Nc);
    for tx_ind = 1: Ntx
        preamble_tx_f(tx_ind, cent_ind + 1) = 1;
    end
    
else
    error("preamble type error!");
end

preamble_t = ifft(fftshift(preamble_tx_f, 2), Nc, 2);


