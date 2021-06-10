clear;
close all;

%% Params
DATA_INDEX = 10;

tx = 2;
fft_size = 16;
hd_len = 1;
pd_len = 197;

pkt_size = (hd_len + tx * hd_len + pd_len) * fft_size;
pkt_num = 13;

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
fid = fopen('debug_tag_pkt.bin', 'r');
raw = fread(fid, 2 * read_pkt_size, 'float32');
fclose(fid);
raw = reshape(raw, 2, []).';
read_pkt = raw(:, 1) + 1j * raw(:, 2);
read_pkt_reshape = reshape(read_pkt, [], pkt_num);

H = zeros(tx, pkt_num);
for pkt_index = 1: pkt_num
    tag_pkt = read_pkt_reshape(:, pkt_index);
    
    ce_sig_rx = tag_pkt(fft_size*hd_len+1 : fft_size*(hd_len+hd_len*tx));
    
    ce_sig_rx_f = fftshift(fft(reshape(ce_sig_rx, fft_size, []), fft_size, 1), 1);
    ce_word_rx = ce_sig_rx_f(DATA_INDEX, :).';
    
    H(:, pkt_index) = pre \ ce_word_rx;
    H(:, pkt_index) = H(:, pkt_index) / ...
        H(1, pkt_index) * abs(H(1, pkt_index));
    
    figure; hold on;
    plot(real(tag_pkt(1: fft_size*(hd_len+hd_len*tx) + fft_size)));
    plot(imag(tag_pkt(1: fft_size*(hd_len+hd_len*tx) + fft_size)));
    
    figure; hold on;
    plot(real(ce_sig_rx));
    plot(imag(ce_sig_rx));
    
end

figure; hold on;
plot(real(read_pkt));
plot(imag(read_pkt));

figure;
plot(abs(H));
figure;
plot(angle(H));

figure; hold on;
for pkt_index = 1: pkt_num
    scatter(real(H(:, pkt_index)), imag(H(:, pkt_index)));
end
xlim([-0.2, 0.2]); ylim([-0.2, 0.2]);

Ha = abs(H)
Hp = angle(H)