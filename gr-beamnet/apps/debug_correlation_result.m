clear;
close all;

read_size = 20e6;

fid = fopen('debug_correlation_result.bin', 'r');
raw = fread(fid, read_size, 'float32');
fclose(fid);

figure;
plot(raw);
