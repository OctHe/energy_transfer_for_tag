%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is the function for offline processing the file "debug_tag_pkt.bin".
% file_name is the input file name. By default, it is *debug_tag_pkt.bin*
% file_options includes the frame structure: fft_size, sym_sync, tx, sym_pd
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ch_mat, power_pd_mat, power_max_mat] = tag_pkt_demux(file_name, file_options)

%% Params
fft_size = file_options.fft_size;
sym_sync = file_options.sym_sync;
tx = file_options.tx;
sym_pd = file_options.sym_pd;

pkt_size = (sym_sync + tx + sym_pd) * fft_size;

dc_index = fft_size / 2 + 1;
data_index = dc_index + 1;

%% Data of the channel estimation word
if tx == 1
    ce_data = 1;
    ce_data_inv = 1;

elseif tx == 2
    ce_data = [1, 1; 1, -1];
    ce_data_inv = [0.5, 0.5; 0.5, -0.5];

elseif tx == 4
    ce_data = [
        1, 1, 1, 1
        1, 1j, -1, -1j
        1, -1, 1, -1
        1, -1j, -1, 1j
        ];
    ce_data_inv = [
        0.25, 0.25, 0.25, 0.25
        0.25, -0.25j, -0.25, 0.25j
        0.25, -0.25, 0.25, -0.25
        0.25, 0.25j, -0.25, -0.25j
        ];
    
else
    error("TX error");
end

%% Pkt demux
fid = fopen(file_name, 'r');
raw = fread(fid, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
read_pkt = raw(:, 1) + 1j * raw(:, 2);

pkt_num = floor(length(read_pkt) / pkt_size);
read_pkt = read_pkt(1: pkt_size * pkt_num);
read_pkt = reshape(read_pkt, pkt_size, pkt_num);

disp(['Packet number: ' num2str(pkt_num)]);

ch_mat = zeros(pkt_num, tx);
power_max_mat = zeros(pkt_num, 1);
power_pd_mat = zeros(pkt_num, 1);

for pkt_index = 1: pkt_num
    
    each_pkt = read_pkt(:, pkt_index);
    
    % Channel estimation from ce_data
    ce_word_rx = each_pkt(sym_sync * fft_size +1: (sym_sync + tx) * fft_size);
    
    ce_word_rx_f = 1 / fft_size * ...
        fftshift(fft(reshape(ce_word_rx, fft_size, tx), fft_size, 1), 1);
    
    ce_data_rx = ce_word_rx_f(data_index, :);
    
    H = ce_data_rx * ce_data_inv;
    H = H / H(1) * abs(H(1));
    
    power_max = sum(abs(H), 2)^2;
    
    % Power of the payload
    rx_pd = each_pkt((sym_sync + tx) * fft_size +1: end);
    
    power = (rx_pd' * rx_pd) / (sym_pd * fft_size);

    % Results
    ch_mat(pkt_index, :) = H;
    power_pd_mat(pkt_index) = power;
    power_max_mat(pkt_index) = power_max;
    
end
