clear;
close all;

%% Params
samp_rate = 1e6;

read_start = 0e6;     % read_start < read_size
read_size = 10e6;

%% File data
fid = fopen('debug_tag_reflection.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
tag_data = raw(read_start +1: end, 1) + 1j * raw(read_start +1: end, 2);


%% Figures
figure; hold on;
plot(((read_start +1): read_size) / samp_rate, real(tag_data));
plot(((read_start +1): read_size) / samp_rate, imag(tag_data));

