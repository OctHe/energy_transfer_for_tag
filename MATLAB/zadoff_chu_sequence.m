%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% zadoff-chu sequence generator
% R: Rth root zadoff-chu sequence
% N: length
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = zadoff_chu_sequence(R, N, flag)


    
if flag == "default"

    s = zeros(N, 1);
    for m = 0: N-1
        s(m+1) = exp(-1j * pi * R * m * (m+1)/N);
    end
    
elseif flag == "zero"
    s = zeros(N, 1);
    for m = 0: N/2-1
        s((m+1)*2) = exp(-1j * pi * R * m * (m+1)/(N/2));
    end
    
else
        error("Flag error");
end