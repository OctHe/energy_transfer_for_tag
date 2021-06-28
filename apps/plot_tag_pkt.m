clear;
close all;

%% Params
samp_rate = 1e6;

tx = 1;
fft_size = 16;
sym_sync = 4;
sym_pd = 195;

DC_INDEX = fft_size / 2 + 1;
DATA_INDEX = DC_INDEX + 1;

read_raw_start = 1e6;     % read_start < read_size
read_raw_size = 4e6;

read_pkt_num = 4;

pkt_size = (sym_sync + tx + sym_pd) * fft_size;

read_pkt_size = read_pkt_num * pkt_size;

if tx == 1
    ce_word_inv = 1;

elseif tx == 2
    ce_word_inv = [0.5, 0.5; 0.5, -0.5];

elseif tx == 4

    
else
    error("TX error");
end

%% File data
% fid = fopen('debug_tag_reflection.bin', 'r');
% raw = fread(fid, 2 * read_raw_size, 'float32');
% fclose(fid);
% raw = reshape(raw, 2, []).';
% data = raw(read_raw_start +1: end, 1) + 1j * raw(read_raw_start +1: end, 2);

fid = fopen('debug_tag_pkt.bin', 'r');
raw = fread(fid, 2 * read_pkt_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
read_pkt = raw(:, 1) + 1j * raw(:, 2);
read_pkt = reshape(read_pkt, pkt_size, read_pkt_num);

%% Figure;

% figure; hold on;
% plot(((read_raw_start +1): read_raw_size) / samp_rate, real(data));
% plot(((read_raw_start +1): read_raw_size) / samp_rate, imag(data));
% title('Raw data');

for pkt_index = 1: read_pkt_num
    
    each_pkt = read_pkt(:, pkt_index);
    
    sync_word_rx = each_pkt(1: sym_sync * fft_size);
    
    ce_word_rx = each_pkt(sym_sync * fft_size +1: (sym_sync + tx) * fft_size);
    ce_word_rx_f = 1 / fft_size * ...
        fftshift(fft(reshape(ce_word_rx, fft_size, tx), fft_size, 1), 1);
    
    ce_word_data = ce_word_rx_f(DATA_INDEX, :);
    
    h = ce_word_data * ce_word_inv;
    h = h / h(1) * abs(h(1));
    
    power_max = sum(abs(h), 2)^2;
    
    rx_pd = each_pkt((sym_sync + tx) * fft_size +1: end);
    rx_pd_f = 1 / fft_size * ...
        fftshift(fft(reshape(rx_pd, fft_size, sym_pd), fft_size, 1), 1);
    
    rx_pd_data = rx_pd_f(DATA_INDEX, :);
    
    power = (rx_pd' * rx_pd) / (sym_pd * fft_size);
    power_f = (rx_pd_data * rx_pd_data') / sym_pd;
    
    disp(['Packe index: ' num2str(pkt_index)]);
    disp(['CSI abs: [' num2str(abs(h)) ']']);
    disp(['RX power: ' num2str(power)]);
    disp(['RX power: ' num2str(power_f)]);
    disp(['Max power: ' num2str(power_max)]);
    
    figure; hold on;
    plot(real(each_pkt));
    plot(imag(each_pkt));
    
end




