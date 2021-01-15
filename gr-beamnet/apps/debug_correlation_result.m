clear;
close all;

%% params

read_size = 100e6;
start = 2e6;

%% read file
fid = fopen('debug_correlation_result.bin', 'r');
raw = fread(fid, read_size, 'float32');
fclose(fid);

raw = raw(start: end);

figure;
plot(abs(raw));


