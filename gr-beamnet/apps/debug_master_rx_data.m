clear;
close all;

%% params
fft_size = 20;
sync_len = 1 * fft_size;

carrier_index = [14:15 17: 18];

offset = 4e6;

read_size = 2e2 * fft_size;

%% read file
fid = fopen('debug_raw_data_from_master.bin', 'r');
raw = fread(fid, 2*offset + 2*read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';

cplx_raw = raw(offset +1: end, 1) + 1j * raw(offset +1: end, 2);
% 
% figure;
% plot(abs(cplx_raw));

% for index = 1: read_size - 2*sync_len
%     R(index) = cplx_raw(index: index + sync_len -1)' ...
%         * cplx_raw(index + sync_len: index + 2*sync_len -1);
%     P(index) = cplx_raw(index + sync_len: index + 2*sync_len -1)' ...
%         * cplx_raw(index + sync_len: index + 2*sync_len -1);
% end
% M = R ./ P;

%% channel estimation
cplx_raw = reshape(cplx_raw, fft_size, []);
ch = fftshift(fft(cplx_raw, fft_size, 1), 1);
ch = ch(carrier_index, :);
% 
% figure;
% plot(abs(R));

figure;
stem(abs(ch));

figure;
plot(angle(ch));
