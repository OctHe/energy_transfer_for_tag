clear;
close all;

%% Params
samp_rate = 1e6;
DATA_INDEX = 10;

tx = 2;
fft_size = 16;
pkt_interval = 1;
pd_len = 197;

pkt_size = (1 + tx + pd_len) * fft_size;
pkt_num = 2;

read_raw_start = 2e6;     % read_start < read_size
read_raw_size = 5e6;

read_pkt_size = pkt_num * pkt_size;

if tx == 2
    pre = [1, 1; 1, -1];
elseif tx == 4
    pre = [1, 1, 1, 1;
        1, 1j, -1, -1j;
        1, -1, 1, -1;
        1, -1j, -1, 1j];
end

%% File data
fid = fopen('debug_tag_reflection.bin', 'r');
raw = fread(fid, 2 * read_raw_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
data = raw(read_raw_start +1: end, 1) + 1j * raw(read_raw_start +1: end, 2);

fid = fopen('debug_tag_pkt.bin', 'r');
raw = fread(fid, 2 * read_pkt_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
read_pkt = raw(:, 1) + 1j * raw(:, 2);
read_pkt = reshape(read_pkt, [], pkt_num);

% fid = fopen('debug_tag_pkt_freq.bin', 'r');
% raw = fread(fid, 2 * read_pkt_size, 'float32');
% fclose(fid);
% raw = reshape(raw, 2, []).';
% read_pkt_f = raw(:, 1) + 1j * raw(:, 2);
% read_pkt_f = reshape(read_pkt_f, [], pkt_num);

% H = zeros(pkt_num, tx);


for pkt_index = 1: pkt_num
%     tag_pkt = read_pkt_f(:, pkt_index);
%     
%     ce_sig_rx = tag_pkt(fft_size+1 : fft_size*(tx +1));
%     ce_sig_rx = reshape(ce_sig_rx, fft_size, []);
%     
%     ce_word_rx = ce_sig_rx(DATA_INDEX, :);
% 
%     H(pkt_index, :) = ce_word_rx / pre;
%     H(pkt_index, :) = H(pkt_index, :) / ...
%         H(pkt_index, 1) * abs(H(pkt_index, 1));
%     
%     pd_rx = tag_pkt(fft_size*(hd_len+hd_len*tx)+1: end);
%     pd_rx = reshape(pd_rx, fft_size, []);
    
    
    figure; hold on;
    plot(real(read_pkt(:, pkt_index)));
    plot(imag(read_pkt(:, pkt_index)));
%     
%     figure;
%     plot(abs(ce_sig_rx));
    % figure;
    % plot(angle(ce_sig_rx));
%     
%     figure;
%     plot(abs(pd_rx));
    
    % figure;
    % plot(angle(pd_rx));

end


%% Figure

% for pkt_index = 2: pkt_num
%     figure; hold on;
%     scatter(real(H(:, pkt_index)), imag(H(:, pkt_index)));
%     xlim([-0.15, 0.15]); ylim([-0.15, 0.15]);
% end

% H

figure; hold on;
plot(((read_raw_start +1): read_raw_size) / samp_rate, real(data));
plot(((read_raw_start +1): read_raw_size) / samp_rate, imag(data));
title('Raw data');

