%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Channel distribution in space domain
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;

Res = 0.01;         % Resolution
InitLoc = 0.01;
D = 12;
Bias = 1;
M = D / Res;        % an M x M matrix
c = 3e8;            % Light speed
f = 9e8;            % Band, 900 MHz

N = [4, 8, 12];

sign = true;    % true: distirbuted antenna; false: MIMO

% CDF figure parameters
cdf_res = 0.01;
cdf_x_axis = repmat((0: cdf_res: 10).', 1, length(N));
cdf_y_axis = zeros(size(cdf_x_axis));

for Index1 = 1: length(N)
    % Distibuted devices
    RelativeLoc = device_distribution(InitLoc, D, N(Index1), sign);
    
    RefMatX = repmat(Res: Res: D, M, 1);
    RefMatY = repmat((Res: Res: D).', 1, M);
    DistMat = zeros(M, M);  % Distance matrix
    ChMat = zeros(M, M);  % Channel matrix

    for Index2 = 1: N(Index1)
        DistMat = sqrt((RefMatX - RelativeLoc(1, Index2)).^2 + (RefMatY - RelativeLoc(2, Index2)).^2);
        ChMat = ChMat + 1 ./ DistMat;
    end
    
    ChMatBias = ChMat((Bias/Res+1): (M - Bias/Res), (Bias/Res+1): (M-Bias/Res));
    ChMatBias = 10 * log10(abs(ChMatBias).^2);     % dB

    figure; hold on;
    mesh(Res: Res: (D-2*Bias), Res: Res: (D-2*Bias), ChMatBias);
    colorbar;
    colormap('hot');
    
    for Index2 = 1: length(cdf_x_axis)
        
        ChannelIndicator = ChMatBias > cdf_x_axis(Index2);
        cdf_y_axis(Index2, Index1) = sum(sum(ChannelIndicator)) / (M * M);
    end
end
figure;
plot(cdf_x_axis, cdf_y_axis);

% figure;
% scatter(RelativeLoc(1, :), RelativeLoc(2, :));
% xlim([0, D]);
% ylim([0, D]);
