%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Iterative phase alignment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bf_weight = iterative_phase_alignment(H, Ntx, Nloop)

% Params
phase_now = zeros(Ntx, 1);           % The updated phase
phase_max = zeros(Ntx, 1);           % The phase for the max power
power_rx_max = 0;

% Iteration
for ite_index = 1: Nloop
    % Generate the phase
    phase_delta = 2 * pi / 20 * rand(Ntx, 1);
    phase_now = phase_now + phase_delta;
    bf_weight = 1 / sqrt(Ntx) * exp(1j * phase_now);
    
    % power comparison
    power_rx_now = max(min(abs(H * bf_weight).^2, [], 1));
    if power_rx_now > power_rx_max
        power_rx_max = power_rx_now;
        phase_max = phase_now;
    else
        phase_now = phase_max;
    end
end
bf_weight = 1 / sqrt(Ntx) * exp(1j * phase_now);