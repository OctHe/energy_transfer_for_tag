%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Energy Beamforming for single tag
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; 


%% Parameter
Na = 16;                             % Antenna number
Ns = 2^8;                           % Sample number
fc = 900e6;                         % Carrier frequency
fs = 20 * fc;                       % Sample rate
Ite = 200;                          % The number of iterations
Feedback = 0;

RxPowerMax = 0;                     % The max received power
RxPowerMatrix = zeros(Ite, 1);      % The received power of the trace

WeightNow = zeros(1, Na);           % The updated weight
WeightMax = zeros(1, Na);           % The weight for the max power

t = ((0: Ns-1) / fs).';

%% Channel model
Amplitude = rand(1, Na);
Phi = 2 * pi * rand(1, Na);

%% Transmisstion loop
for index = 1: Ite
    %% Each transmitter
    % Generate the phase
    Delta = 2 * pi / 10 * rand(1, Na); 
    
    % Update the weight with the feedback
    if Feedback
        WeightMax = WeightNow;
    else
        WeightNow = WeightMax;
    end
    WeightNow = WeightNow + Delta;
    
    % Source signal for the distributed Tx
    TxSignal = repmat(exp(2j*pi*fc*t), 1, Na) .* repmat(exp(1j*WeightNow), Ns, 1);
    
    %% Wireless channel
    H = Amplitude .* exp(1j * Phi);
    
    %% Receiver
    RxSignal = sum(TxSignal .* repmat(H, Ns, 1), 2);

    RxPowerNow = sum(abs(RxSignal));
    
    RxPowerMatrix(index) = RxPowerNow;
    
    %% Generate 1-bit feedback
    if RxPowerNow > RxPowerMax
        Feedback = 1;
        RxPowerMax = RxPowerNow;
    else
        Feedback = 0;
    end
    
    
end

 plot(RxPowerMatrix);

