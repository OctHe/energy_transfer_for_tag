%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Multi-frequencies-based channel estimation
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Hest = multifreq_channel_estimation(sym, Nc, Ntx, preamble_type)

% Params
if mod(Nc, 2) == 0
    cent_ind = Nc / 2 + 1;
else
    cent_ind = (Nc +1) /2;
end

if preamble_type == "expj_3"
    
    Nsc = 3;
    
    % Time offset calibration
    D = time_delay_estimation(sym, Nc, Ntx, preamble_type);

    Hest = zeros(Nsc, Ntx);
    for tx_ind = 1: Ntx

        % subcarrier index allocation
        if mod(tx_ind, 2) == 1
            tx_flag = (tx_ind +1) / 2;
            sub_ind = (cent_ind - tx_flag *3) : (cent_ind - tx_flag *3 +2);
            
        else
            tx_flag = tx_ind / 2;
            sub_ind = (cent_ind + tx_flag *3 -2) : (cent_ind + tx_flag *3);
            
        end
        
        delay_phase = (2*pi) * (cent_ind - sub_ind.') / Nc * D(tx_ind);
        Hest(:, tx_ind) = sym(sub_ind) .* exp(1j * delay_phase);
        
    end
    
end

Hest = mean(Hest, 1);

% Normalization
% Hest = Hest / Hest(1) * abs(Hest(1));