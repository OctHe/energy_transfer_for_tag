%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of zadoff-chu sequence generator
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

R = 6;

N = 8;

s = zadoff_chu_sequence(R, N);

S = fft(s);

figure;
plot(abs(s));

figure;
plot(angle(s));

figure;
plot(abs(xcorr(s)) ./ length(s));

figure;
plot(abs(xcorr(S)) ./ length(S));