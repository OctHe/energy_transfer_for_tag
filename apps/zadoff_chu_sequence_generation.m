%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Zadoff-Chu sequence
% "Timing and Frequency Synchronization for OFDM Downlink Transmissions 
% Using Zadoff-Chu Sequences", TWC 2015.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all

N = 16;     % Subcarrier: [-N/2, ..., -1, 0, ..., N/2-1];
M = 13;     % Length of Zadoff-Chu sequence
R = 4;      % Root of Zadoff-Chu sequence

DC_IND = N /2 +1;
SC_IND = (-(M-1)/2: (M-1)/2);
X = zeros(N, 1);
for k = SC_IND
    if k ~= 0
        X(k + DC_IND) = exp(1j*pi / M * R * k * (k +1));
    end
end

x = ifft(fftshift(X));

figure; hold on;
plot(real(x));
plot(imag(x));

figure;
plot(abs(xcorr(x)./length(x)));