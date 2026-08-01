function [peakValues, peakLocations] = detect_qrs(filteredECG, Fs)

% ==========================================================
% DETECT_QRS
%
% Detects R-peaks in a filtered ECG signal.
%
% Inputs:
%   filteredECG - Filtered ECG signal
%   Fs          - Sampling frequency (Hz)
%
% Outputs:
%   peakValues     - Amplitude of each R-peak
%   peakLocations  - Sample index of each R-peak
%
% ==========================================================

minimumPeakHeight = 0.60 * max(filteredECG);

minimumPeakDistance = 0.60;

[peakValues, peakLocations] = findpeaks( ...
    filteredECG, ...
    'MinPeakHeight', minimumPeakHeight, ...
    'MinPeakDistance', round(minimumPeakDistance * Fs));

end