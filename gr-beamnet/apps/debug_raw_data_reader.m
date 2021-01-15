clear;
close all;

read_size = 50e6;
start = 1e6;

fid = fopen('debug_multisine_signal.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';
raw_cplx = raw(start: end, 1) + 1j * raw(start: end, 2);

figure;
plot(abs(raw_cplx));
