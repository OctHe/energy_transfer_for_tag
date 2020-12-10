%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Device distribution for N devices
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RelativeLoc = device_deployment(InitLoc, D, N, sign)

if sign

switch N
    case 8
    RelativeLoc = [
        InitLoc, InitLoc, InitLoc, D / 2, D / 2, D - InitLoc, D - InitLoc, D - InitLoc;
        InitLoc, D / 2, D - InitLoc, InitLoc, D - InitLoc, InitLoc, D / 2, D - InitLoc];
    case 4
        RelativeLoc = [
        InitLoc, InitLoc, D - InitLoc, D - InitLoc;
        InitLoc, D - InitLoc, InitLoc, D - InitLoc];
    case 12
        Interval = (D - 2 * InitLoc) / 3;
        
        RelativeLoc(:, 1: 4) = [
        InitLoc, InitLoc, InitLoc, InitLoc;
        InitLoc, InitLoc + Interval, D - InitLoc - Interval, D - InitLoc];
        
        RelativeLoc(:, 5: 8) = [
        InitLoc + Interval, D - InitLoc - Interval, InitLoc + Interval, D - InitLoc - Interval;
        InitLoc, InitLoc, D - InitLoc, D - InitLoc];
    
        RelativeLoc(:, 9: 12) = [
        D - InitLoc, D - InitLoc, D - InitLoc, D - InitLoc;
        InitLoc, InitLoc + Interval, D - InitLoc - Interval, D - InitLoc];

    otherwise
        error('N must be 4, 8, 12');
end
else
    Interval = (D - 2 * InitLoc);
    
    RelativeLoc = zeros(2, N);
    RelativeLoc(1, :) = InitLoc: (Interval / (N-1)): D - InitLoc;
% % MIMO antennas
% RelativeLoc =[
%     zeros(1, 8); 
%     (0.5: 1: 7.5) / 8 * D];
end
