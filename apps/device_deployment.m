%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Device distribution for N devices. This function returns the localization
% of the power sources.
% init_loc: the initial localization in the region of interest (RoI)
% D: the side length of the RoI (DxD)
% N: the number of power sources
% sign: true (distributed deployment); false (centralized deployment)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function source_loc = device_deployment(init_loc, D, N, type)

if type == "rectangle"

    switch N
        case 2
            source_loc = [init_loc, D - init_loc; D / 2, D / 2];
            
        case 4
            source_loc = [
            init_loc, init_loc, D - init_loc, D - init_loc;
            init_loc, D - init_loc, init_loc, D - init_loc];
        
        case 8
        source_loc = [
            init_loc, init_loc, init_loc, D / 2, D / 2, D - init_loc, D - init_loc, D - init_loc;
            init_loc, D / 2, D - init_loc, init_loc, D - init_loc, init_loc, D / 2, D - init_loc];

        case 12
            Interval = (D - 2 * init_loc) / 3;

            source_loc(:, 1: 4) = [
            init_loc, init_loc, init_loc, init_loc;
            init_loc, init_loc + Interval, D - init_loc - Interval, D - init_loc];

            source_loc(:, 5: 8) = [
            init_loc + Interval, D - init_loc - Interval, init_loc + Interval, D - init_loc - Interval;
            init_loc, init_loc, D - init_loc, D - init_loc];

            source_loc(:, 9: 12) = [
            D - init_loc, D - init_loc, D - init_loc, D - init_loc;
            init_loc, init_loc + Interval, D - init_loc - Interval, D - init_loc];

        otherwise
            error('N must be 4, 8, 12');
    end
    
elseif type == "centralized"
    Interval = (D - 2 * init_loc);
    
    source_loc = zeros(2, N);
    source_loc(1, :) = init_loc: (Interval / (N-1)): D - init_loc;

else
    error("type: rectangle; centralized");
end
