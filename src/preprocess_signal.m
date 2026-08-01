function filteredECG = preprocess_signal(ecg, Fs)

% ==========================================================
% PREPROCESS_SIGNAL
%
% Removes:
%   1. Baseline Wander
%   2. High-Frequency Noise
%
% Inputs:
%   ecg - Raw ECG signal
%   Fs  - Sampling Frequency
%
% Output:
%   filteredECG - Clean ECG signal
%
% ==========================================================

%% Step 1 - Remove Baseline Wander

highPass = designfilt( ...
    'highpassiir', ...
    'FilterOrder',4, ...
    'HalfPowerFrequency',0.5, ...
    'SampleRate',Fs);

ecgHigh = filtfilt(highPass, ecg);

%% Step 2 - Remove High Frequency Noise

lowPass = designfilt( ...
    'lowpassiir', ...
    'FilterOrder',4, ...
    'HalfPowerFrequency',40, ...
    'SampleRate',Fs);

filteredECG = filtfilt(lowPass, ecgHigh);

end