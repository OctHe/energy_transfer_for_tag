clear;
close all;

%% Params
% sync_word = [0, 0, 0, 0, 0, 1, 0, -1, 0, -1, 0, 1, 0, 0, 0, 0];
sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0];

fft_size = length(sync_word);
pkt_size = 1 + 4 + 4;

read_start = 2.5e4;     % read_start < read_size
read_size = 2.53e4;

%% Sync word
sync_word = fft(fftshift(sync_word));

%% File data
fid = fopen('debug_sync.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
master_data_rx = raw(read_start +1: end, 1) + 1j * raw(read_start +1: end, 2);

fid = fopen('debug_sync_trigger.bin', 'r');
sync_trigger = fread(fid, read_size, 'char');
fclose(fid);
sync_trigger = sync_trigger(read_start +1: end);

fid = fopen('debug_slave_signal.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
slave_data_tx = raw(read_start +1: end, 1) + 1j * raw(read_start +1: end, 2);

%% Figure
figure; hold on;
plot(real(master_data_rx));
plot(imag(master_data_rx));


figure;
stem(sync_trigger);

figure; hold on;
plot(real(slave_data_tx));
plot(imag(slave_data_tx));

