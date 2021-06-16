clear;
close all;

%% Params
sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0];

tx = 2;
fft_size = 16;
pkt_interval = 1;
pd_len = 197;

read_pkt = 1;

pkt_size = (1 + tx + pd_len) * fft_size;

read_size = (fft_size * pkt_interval + pkt_size) * read_pkt;

%% Sync word
sync_word = fft(fftshift(sync_word));

en_sync = sum(abs(sync_word).^2) / fft_size

%% File data
fid = fopen('debug_source_signal_tx0.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
master_data = raw(:, 1) + 1j * raw(:, 2);

en_pkt = sum(abs(master_data).^2) / pkt_size

fid = fopen('debug_source_signal_tx1.bin', 'r');
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