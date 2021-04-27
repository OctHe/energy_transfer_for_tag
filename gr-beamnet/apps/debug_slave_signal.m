clear;
close all;

%% Params
fft_size = 16;
pkt_len = 1 + 4 + 4;

read_start = 0e4;     % read_start < read_size
read_size = 2e5;

%% File data
fid = fopen('debug_sync_rx.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
master_data_rx = raw(read_start +1: end, 1) + 1j * raw(read_start +1: end, 2);

fid = fopen('debug_sync_trigger.bin', 'r');
sync_trigger = fread(fid, read_size, 'char');
fclose(fid);
sync_trigger = sync_trigger(read_start +1: end) -1;

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

