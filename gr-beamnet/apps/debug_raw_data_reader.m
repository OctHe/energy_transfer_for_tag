clear;
close all;

fft_size = 10;
samp_rate = 1e6;

start = samp_rate;
read_size = start + 50 * samp_rate;

fid = fopen('debug_multisine_signal.bin', 'r');
raw = fread(fid, 2 * read_size, 'float32');
fclose(fid);

raw = reshape(raw, 2, []).';
raw_cplx = raw(start +1: end, 1) + 1j * raw(start +1: end, 2);

% sig_t = reshape(raw_cplx, fft_size, []);
% sig_f = fftshift(fft(sig_t, fft_size, 1), 1);
% 
% corr_res = zeros(size(sig_f, 2), 1);

% for index = 1: length(corr_res)
%     corr_res(index) = abs(sig_f(:, 1)' * sig_f(:, index)) / ...
%         norm(sig_f(:, 1)) / norm(sig_f(:, index));
% end

figure;
plot((1: length(raw_cplx))/samp_rate, abs(raw_cplx));

% figure;
% plot(corr_res);
