%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Power-limted tag grouping
% H: the estimated channel (according to the received power)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function group_mat = tag_group_power(H, Pthre, Ptx, Nloop)

Ntx = size(H, 2);
Ntag = size(H, 1);

% correlation matrix
ch_abs = sqrt(diag(abs(H * H')));
ch_cos = abs(H * H') ./ (ch_abs * ch_abs');
dist_mat = 1 - ch_cos;
for Ntag_index = 1: Ntag
    dist_mat(Ntag_index, Ntag_index) = 0;
end
dist_vec = squareform(dist_mat);

% Tag group
group_mat = ones(1, Ntag);

% the power of tags which are in this group
bf_weight = iterative_phase_alignment(H, Ntx, Nloop);
bf_power = 10 * log10(abs(H * bf_weight * Ptx).^2);

% indicate whether the tags need to be grouped
group_indicator = (Pthre >= min(bf_power));

while sum(group_indicator)
    
    % Find the target group
    for group_index = 1: size(group_mat, 1)
        if group_indicator(group_index) == 1
            group_old = group_mat(group_index, :);
            break;
        end
    end
    
    % The correlation matrix of the target group
    Hg = zeros(size(H));
    Hg(find(group_old), :) = H(find(group_old), :);
    
    ch_abs = sqrt(diag(abs(Hg * Hg')));
    ch_cos = abs(Hg * Hg') ./ (ch_abs * ch_abs');
    dist_mat = 1 - ch_cos;
    for Ntag_index = 1: Ntag
        nan_index = find(isnan(dist_mat(Ntag_index, :)));
        dist_mat(Ntag_index, nan_index) = zeros(1, length(nan_index));
        dist_mat(Ntag_index, Ntag_index) = 0;
    end
    dist_vec = squareform(dist_mat);
    
    % create a new group
    [center, ~] = find(dist_mat == max(dist_vec));
    
    group_new = zeros(1, Ntag);
    group_old(center(2)) = 0;
    group_new(center(2)) = 1;
    for Ntag_index = find(group_old)
        if dist_mat(center(1), Ntag_index) >= dist_mat(center(2), Ntag_index)
            group_old(Ntag_index) = 0;
            group_new(Ntag_index) = 1;
        end
    end
    
    % the power of tags which are in this group
    H_old = H(find(group_old), :);
    bf_weight_old = iterative_phase_alignment(H_old, Ntx, Nloop);
    bf_power_old = 10 * log10(abs(H_old * bf_weight_old * Ptx).^2);
    
    H_new = H(find(group_new), :);
    bf_weight_new = iterative_phase_alignment(H_new, Ntx, Nloop);
    bf_power_new = 10 * log10(abs(H_new * bf_weight_new * Ptx).^2);
    
    % update the group information
    group_mat(group_index, :) = group_old;
    group_mat = [group_mat; group_new];
    
    group_indicator(group_index) = (Pthre >= min(bf_power_old));
    group_indicator = [group_indicator, (Pthre >= min(bf_power_new))];
    
    % The group cannot be divided when the number is only 1.
    for group_index = 1: size(group_mat, 1)
        if sum(group_mat(group_index, :)) == 1
            group_indicator(group_index) = 0;
        end
    end
end