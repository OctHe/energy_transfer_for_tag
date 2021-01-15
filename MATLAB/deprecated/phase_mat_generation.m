%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Phase matrix generation
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Weight = phase_mat_generation(Ntxs, Rp)

Weight = ones(Ntxs, Rp^(Ntxs -1));
ConvertVector = zeros(Ntxs, 1);

for MatrixIndex = 1: Rp^(Ntxs -1)
    
    % Decimal converts to N Hex
    Num = MatrixIndex - 1;
    for ConvertIndex = Ntxs: -1: 2
        ConvertVector(ConvertIndex) = mod(Num, Rp);
        Num = floor(Num / Rp);
    end
    
    W = exp(2j * pi * ConvertVector / Rp);
    Weight(:, MatrixIndex) = W / sqrt(W' * W);
end
Weight(:, MatrixIndex) = W / sqrt(W' * W);