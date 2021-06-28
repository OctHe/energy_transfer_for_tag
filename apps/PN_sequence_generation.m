%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PN sequence which is used to time sync
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

fft_size = 16;

signal_type = "bpsk";

pnSequence2 = comm.PNSequence('Polynomial','x^4+x+1', ...
    'InitialConditions',[0 0 0 1],'SamplesPerFrame',30);
x2 = pnSequence2();

sync_word = x2(1: fft_size);

if signal_type == "bpsk"
    sync_signal = 2 * sync_word -1;
elseif signal_type == "fft"
    sync_signal = fft(sync_word, fft_size) / sqrt(sync_word' * sync_word) / sqrt(fft_size);
end

rx_signal = repmat(sync_signal, 3, 1);

corr_result = conv(rx_signal, flip(sync_signal));

figure;
plot(abs(corr_result));