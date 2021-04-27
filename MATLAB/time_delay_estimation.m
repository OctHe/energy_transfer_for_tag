%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Time delay estiamtion. The delay are caused by inaccurate inter-tx
% synchronization and detection of tags.
% Time delay estimation needs 4 subcarriers for 1 signal
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D = time_delay_estimation(preamble_rx_f, Nc, Ntx, preamble_type)

% Params
if mod(Nc, 2) == 0
    cent_ind = Nc / 2 + 1;
else
    cent_ind = (Nc +1) /2;
end

if preamble_type == "expj_3"
    Nsc = 3;    % The number of subcarriers at each TX
    D = zeros(Nsc -1, Ntx);
    
    for tx_ind = 1: Ntx
        
        % subcarrier index allocation
        if mod(tx_ind, 2) == 1
            tx_flag = (tx_ind +1) / 2;
            sub_ind = (cent_ind - tx_flag *3) : (cent_ind - tx_flag *3 +2);
            
        else
            tx_flag = tx_ind / 2;
            sub_ind = (cent_ind + tx_flag *3 -2) : (cent_ind + tx_flag *3);
            
        end

        sym_phase = angle(preamble_rx_f(sub_ind));
        
        D(:, tx_ind) = ...
            (sym_phase(2: end) - sym_phase(1: end-1)) / (2*pi) * Nc;
        
    end

else
    error("preamble type error");
end

D = mean(D, 1);
D = mod(D, Nc);