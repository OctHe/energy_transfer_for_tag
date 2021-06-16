clear;
close all;

%% Params
samp_rate = 1e6;

tx = 2;
fft_size = 16;
hd_len = 1;
pd_len = 197;

read_raw_start = 2.75e6;     % read_start < read_size
read_raw_size = 2.8e6;


%% File data
fid = fopen('debug_tag_reflection.bin', 'r');
raw = fread(fid, 2 * read_raw_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
data = raw(read_raw_start +1: end, 1) + 1j * raw(read_raw_start +1: end, 2);

fid = fopen('debug_sync_nrg.bin', 'r');
ed_res = fread(fid, read_raw_size, 'float32');
fclose(fid);
ed_res = ed_res(read_raw_start +1: end);

fid = fopen('debug_sync_symbol.bin', 'r');
ss_res = fread(fid, read_raw_size, 'float32');
fclose(fid);
ss_res = ss_res(read_raw_start +1: end);

%% Figure
figure; hold on;
plot(((read_raw_start +1): read_raw_size) / samp_rate, real(data));
plot(((read_raw_start +1): read_raw_size) / samp_rate, imag(data));
title('Raw data');

figure;
plot(((read_raw_start +1): read_raw_size) / samp_rate, ed_res);
title('Packet Energy');

figure;
plot(((read_raw_start +1): read_raw_size) / samp_rate, ss_res);
title('Symbol Peak');