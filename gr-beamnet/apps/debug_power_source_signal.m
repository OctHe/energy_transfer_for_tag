clear;
close all;

%% Params
sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0];
read_size = 400;

fft_size = length(sync_word);

%% Sync word
sync_word = fft(fftshift(sync_word));

%% File data
fid = fopen('debug_master_signal.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';
master_data = raw(:, 1) + 1j * raw(:, 2);

fid = fopen('debug_slave_pkt.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';
slave_data = raw(:, 1) + 1j * raw(:, 2);


%% Figure

figure; hold on;
plot(real(master_data));
plot(imag(master_data));

figure; hold on;
plot(real(slave_data));
plot(imag(slave_data));