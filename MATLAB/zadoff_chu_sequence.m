%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% zadoff-chu sequence generator
% R: Rth root zadoff-chu sequence
% N: length
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = zadoff_chu_sequence(R, N)

s = zeros(N, 1);
for m = 1: N-1
    s(m+1) = exp(-1j * pi * R * m * (m+1)/N);
end