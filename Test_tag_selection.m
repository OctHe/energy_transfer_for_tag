%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test of power-limited tag selection
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 


%% Parameter
InitLoc = -0.1;
D = 30;

fc = 900e6;            % Band, 900 MHz

Ntx = 4;
Ntag = 10;

amp_tx = 1e1;          % 20 dBm

Nloop = 1e3;

%% Channel model
loc_tx = device_deployment(InitLoc, D, Ntx, "rectangle");
loc_tag = rand(2, Ntag) * D;
loc_rx = [1.1 * D; 1.1 * D];

Hf = channel_model(loc_tx, loc_tag, fc);
Hb = channel_model(loc_tag, loc_rx, fc);

% The ground truth channel at the receiver
Hf_est = zeros(Ntag, Ntx);
for Ntag_index = 1: Ntag
    Hf_est(Ntag_index, :) = Hf(Ntag_index, :) / ...
        Hf(Ntag_index, 1) * abs(Hf(Ntag_index, 1));

end

%% Tag selection
% Select from the rest tags until the power is lower than the threshold
Pth = -15;      % dBm

core_tag = randi(Ntag);
unsel_tag_list = find([1: Ntag] ~= core_tag);

% initialization
sel_tag = core_tag;
unsel_tag = unsel_tag_list;

H_sel = Hf_est(sel_tag, :);
H_unsel = Hf_est(unsel_tag, :);

bf_weight = iterative_phase_alignment(H_sel, Ntx, Nloop);
bf_power = 10 * log10(abs(H_sel * bf_weight * amp_tx).^2);

% Tag selection
while min(bf_power) > Pth && length(sel_tag) < Ntag
    
    % correlation metric
    corr_mat = zeros(length(sel_tag), length(unsel_tag));
    for sel_index = 1: length(sel_tag)
        for unsel_index = 1: length(unsel_tag)
            corr_mat(sel_index, unsel_index) = ...
                abs(H_sel(sel_index, :) * H_unsel(unsel_index, :)') ...
                / norm(H_sel(sel_index, :)) ...
                / norm(H_unsel(unsel_index, :));
        end
    end
    
    % select an unselected tag and update the channel
    % The tag is selected based on the minimal 
    [~, new_sel_tag_index] = max(min(corr_mat, [], 1), [], 2);
    new_sel_tag = unsel_tag(new_sel_tag_index);
    
    sel_tag = [sel_tag, new_sel_tag];
    unsel_tag = unsel_tag(find(unsel_tag ~= new_sel_tag));
    
    H_sel = Hf_est(sel_tag, :);
    H_unsel = Hf_est(unsel_tag, :);

    % update bf power
    bf_weight = iterative_phase_alignment(H_sel, Ntx, Nloop);
    bf_power = 10 * log10(abs(H_sel * bf_weight * amp_tx).^2);
end

% The last tag is not selected in this case
if min(bf_power) <= Pth
    sel_tag = sel_tag(1: end-1);
end
sel_tag = sort(sel_tag);

% Proposal: Phase alignment for selected tags
H_sel = Hf_est(sel_tag, :);
bf_weight_sel = iterative_phase_alignment(H_sel, Ntx, Nloop);
bf_power_sel = abs(H_sel * bf_weight_sel * amp_tx).^2;

%% Baseline
% Baseline: Phase alignment for randam tags
Nsel = length(sel_tag);
sel_tag_rand_index = sort(randperm(Ntag -1, Nsel -1));
sel_tag_rand = sort([core_tag, unsel_tag_list(sel_tag_rand_index)]);

H_rand = Hf_est(sel_tag_rand, :);
bf_weight_rand = iterative_phase_alignment(H_rand, Ntx, Nloop);
bf_power_rand = abs(H_rand * bf_weight_rand * amp_tx).^2;

% Baseline: Phase alignment for all tags
bf_weight_all = iterative_phase_alignment(Hf_est, Ntx, Nloop);
bf_power_all = abs(Hf * bf_weight_all * amp_tx).^2;

gain_sel_rand = min(bf_power_sel) / min(bf_power_rand)
gain_sel_all = min(bf_power_sel) / min(bf_power_all)

gain_sel_rand = mean(bf_power_sel) / mean(bf_power_rand)
gain_sel_all = mean(bf_power_sel) / mean(bf_power_all)

figure; hold on;
plot(bf_power_sel);
plot(bf_power_rand);
plot(bf_power_all);