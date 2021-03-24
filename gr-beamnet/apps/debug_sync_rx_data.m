clear;
close all;

%% Params
% sync_word = [0, 0, 0, 0, 0, 1, 0, -1, 0, -1, 0, 1, 0, 0, 0, 0];
sync_word = [0, 0, 0, 0, 1, -1, -1, 1, 0, 1, -1, -1, 1, 0, 0, 0];

fft_size = length(sync_word);
pkt_size = 1 + 4 + 4;

read_start = 2.3e4;     % read_start < read_size
read_size = 3.1e4;
read_pkt = 4;

%% Sync word
sync_word = fft(fftshift(sync_word));

%% File data
fid = fopen('debug_sync.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
data = raw(:, 1) + 1j * raw(:, 2);

fid = fopen('debug_sync_nrg.bin', 'r');
ed_res = fread(fid, read_size, 'float32');
fclose(fid);
ed_res = ed_res(read_start +1: end);

fid = fopen('debug_sync_symbol.bin', 'r');
ss_res_online = fread(fid, read_size, 'float32');
fclose(fid);
ss_res_online = ss_res_online(read_start +1: end);

fid = fopen('debug_sync_trigger.bin', 'r');
sync_trigger = fread(fid, read_size, 'char');
fclose(fid);
sync_trigger = sync_trigger(read_start +1: end);

% fid = fopen('debug_pkt.bin', 'r');
% raw = fread(fid, 2 * (fft_size * pkt_size * read_pkt), 'float32');
% fclose(fid);
% raw = reshape(raw, 2, []).';

%% Offline processing

% Correlation result
ss_res_offline = zeros(read_size, 1);
for index = 1: read_size-fft_size
    ss_res_offline(index) = sync_word * conj(data(index: index+(fft_size-1)));
end
ss_res_offline = ss_res_offline(read_start +1: end);

%% Figure
figure; hold on;
plot(real(data));
plot(imag(data));

figure;
plot(ed_res);

figure;
plot(ss_res_online);
% figure;
% plot(abs(ss_res_offline));

figure;
stem(sync_trigger);

% figure; hold on;
% plot(real(pkt));
% plot(imag(pkt));

