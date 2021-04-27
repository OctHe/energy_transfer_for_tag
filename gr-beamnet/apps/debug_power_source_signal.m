clear;
close all;

%% Params
sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0];

tx = 2;
fft_size = 16;
hd_len = 1;
pd_len = 197;

pkt_size = (hd_len + tx * hd_len + pd_len) * fft_size;

read_size = (fft_size * hd_len + pkt_size) * 10;

%% Sync word
sync_word = fft(fftshift(sync_word));

en_sync = sum(abs(sync_word).^2) / fft_size

%% File data
fid = fopen('debug_master_signal.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
master_data = raw(:, 1) + 1j * raw(:, 2);

en_pkt = sum(abs(master_data).^2) / pkt_size

fid = fopen('debug_slave_signal.bin', 'r');
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