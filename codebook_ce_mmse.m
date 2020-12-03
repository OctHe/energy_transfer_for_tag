%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Codebook-based channel estimation with MMSE estimator
% rx_abs: the received amplitude of the preamble sequence (1 x Rp^(Ntxs-1))
% weight_mat: the generated preamble; It can generated in this function,
% but we input it instead to simplify the process.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [est_channel, square_error_vec] = codebook_ce_mmse(rx_abs, weight_mat, Ntxs, Nloop)

% Initialization
est_channel = zeros(1, Ntxs);
square_error_vec = zeros(1, Nloop);

square_error = norm(abs(est_channel * weight_mat) - rx_abs);
    
for loop_index = 1: Nloop

    mmse_temp_ch = (rand(1, 1) .* exp(2j * pi * rand(1, 1))) ...
        * (rand(1, Ntxs) .* exp(2j * pi * rand(1, Ntxs)));
    
    mmse_temp_error = norm(abs(mmse_temp_ch * weight_mat).^2 ...
        - rx_abs);
    
    square_error_vec(loop_index) = mmse_temp_error;

    if mmse_temp_error < square_error

        est_channel = mmse_temp_ch;
        square_error = mmse_temp_error;

    end

end
