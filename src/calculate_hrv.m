function [meanRR, SDNN] = calculate_hrv(RRintervals)

% ==========================================================
% CALCULATE_HRV
%
% Calculates basic Heart Rate Variability (HRV) metrics.
%
% Inputs:
%   RRintervals - RR intervals (seconds)
%
% Outputs:
%   meanRR - Mean RR interval (seconds)
%   SDNN   - Standard deviation of RR intervals (seconds)
%
% ==========================================================

%% Mean RR Interval

meanRR = mean(RRintervals);

%% SDNN

SDNN = std(RRintervals);

end