clear;
close all;

%% params
start = 1e6;
fft_size = 10;
samp_rate = 1e6;

carrier_index = [2: 5 7: 10];

read_size = start + 100 * fft_size;

%% read file
fid = fopen('debug_TX_sync_f.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';
sig_f = raw(start +1: end, 1) + 1j * raw(start +1: end, 2);

sig_f = reshape(sig_f, fft_size, []);
sig_f = sig_f(carrier_index, :);

freq_offset = (angle(sig_f(:, 2: end)) - angle(sig_f(:, 1: end-1))) / (2 * pi);
freq_offset = freq_offset  * samp_rate / fft_size;

freq_offset_mean = mean(freq_offset, 2)

figure;
plot(angle(sig_f));

figure;
plot(freq_offset.');



