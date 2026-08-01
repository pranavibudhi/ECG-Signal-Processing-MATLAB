function [RRintervals, heartRate, beatTimes] = calculate_heart_rate(peakLocations, Fs)

% ==========================================================
% CALCULATE_HEART_RATE
%
% Calculates RR intervals and heart rate from detected R-peaks.
%
% Inputs:
%   peakLocations - Sample indices of detected R-peaks
%   Fs            - Sampling frequency (Hz)
%
% Outputs:
%   RRintervals   - Time between consecutive heartbeats (seconds)
%   heartRate     - Instantaneous heart rate (BPM)
%   beatTimes     - Time of each heart rate measurement (seconds)
%
% ==========================================================

%% Calculate RR Intervals

RRintervals = diff(peakLocations) / Fs;

%% Calculate Instantaneous Heart Rate

heartRate = 60 ./ RRintervals;

%% Time Associated with Each Heartbeat

beatTimes = peakLocations(2:end) / Fs;

end