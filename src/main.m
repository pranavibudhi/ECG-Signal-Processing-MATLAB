%% ==========================================================
% ECG Signal Processing & Heart Rate Analysis
% Biomedical Engineering Project
%
% Author: Pranavi Budhi
%
% Description:
%   1. Loads ECG data from the MIT-BIH Arrhythmia Database
%   2. Displays the raw ECG signal
%   3. Filters the ECG signal
%   4. Detects R-peaks
%   5. Calculates heart rate
%   6. Computes heart rate variability (HRV)
%   7. Generates figures and saves them to the results folder
%
% ===========================================================

clc;
clear;
close all;

fprintf('=========================================\n');
fprintf(' ECG Signal Processing Project\n');
fprintf('=========================================\n\n');

%% Analysis Settings

Fs = 360;          % Sampling frequency (Hz)
duration = 60;     % Seconds of ECG to analyze

%% Load ECG Data

load('../data/100m.mat');

% Select Lead I
ecg = double(val(1,:));

% Keep only the first 60 seconds
ecg = ecg(1:duration*Fs);

%% Display Recording Information

fprintf('ECG loaded successfully!\n');
fprintf('Sampling Frequency : %d Hz\n', Fs);
fprintf('Recording Duration : %d seconds\n', duration);
fprintf('Samples Analyzed   : %d\n\n', length(ecg));

%% Create Time Vector

time = (0:length(ecg)-1) / Fs;

%% Preprocess ECG Signal
% Remove baseline wander and high-frequency noise

filteredECG = preprocess_signal(ecg, Fs);

%% Detect R-Peaks

[peakValues, peakLocations] = detect_qrs(filteredECG, Fs);

fprintf('Number of Heartbeats Detected : %d\n\n', length(peakLocations));

%% Calculate Heart Rate

[RRintervals, heartRate, beatTimes] = ...
    calculate_heart_rate(peakLocations, Fs);

%% Heart Rate Statistics

averageHeartRate = mean(heartRate);

maximumHeartRate = max(heartRate);

minimumHeartRate = min(heartRate);

fprintf('Average Heart Rate : %.1f BPM\n', averageHeartRate);
fprintf('Maximum Heart Rate : %.1f BPM\n', maximumHeartRate);
fprintf('Minimum Heart Rate : %.1f BPM\n\n', minimumHeartRate);

%% Calculate Heart Rate Variability (HRV)

[meanRR, SDNN] = calculate_hrv(RRintervals);

fprintf('Mean RR Interval  : %.3f seconds\n', meanRR);
fprintf('SDNN              : %.3f seconds\n\n', SDNN);

%% ==========================================================
% Figure 1 - Raw vs Filtered ECG
%% ==========================================================

figure('Name','Raw vs Filtered ECG');

subplot(2,1,1)

plot(time, ecg, ...
    'b', ...
    'LineWidth', 1)

title('Raw ECG Signal')

xlabel('Time (seconds)')

ylabel('Amplitude')

grid on

xlim([0 duration])

ylim([-100 300])

subplot(2,1,2)

plot(time, filteredECG, ...
    'r', ...
    'LineWidth', 1)

title('Filtered ECG Signal')

xlabel('Time (seconds)')

ylabel('Amplitude')

grid on

xlim([0 duration])

ylim([-100 300])

exportgraphics(gcf, ...
    '../results/filtered_ecg.png', ...
    'Resolution',300);

%% ==========================================================
% Figure 2 - Detected R-Peaks
%% ==========================================================

figure('Name','Detected R-Peaks');

plot(time, filteredECG, ...
    'b', ...
    'LineWidth', 1)

hold on

plot(time(peakLocations), ...
     peakValues, ...
     'o', ...
     'MarkerFaceColor','red', ...
     'MarkerEdgeColor','black', ...
     'MarkerSize',6)

title('Filtered ECG with Detected R-Peaks')

xlabel('Time (seconds)')

ylabel('Amplitude')

legend('Filtered ECG', ...
       'Detected R-Peaks', ...
       'Location', 'best')

grid on

xlim([0 duration])

ylim([-100 300])

hold off

exportgraphics(gcf, ...
    '../results/detected_peaks.png', ...
    'Resolution',300);

%% ==========================================================
% Figure 3 - Heart Rate Over Time
%% ==========================================================

figure('Name','Heart Rate');

plot(beatTimes, ...
    heartRate, ...
    '-o', ...
    'LineWidth', 1.5, ...
    'MarkerFaceColor', 'blue', ...
    'MarkerSize', 5)

title('Heart Rate Over Time')

xlabel('Time (seconds)')

ylabel('Heart Rate (BPM)')

grid on

xlim([0 duration])

exportgraphics(gcf, ...
    '../results/heart_rate.png', ...
    'Resolution',300);

%% ==========================================================
% Figure 4 - RR Intervals
%% ==========================================================

figure('Name','RR Intervals');

plot(beatTimes, ...
    RRintervals, ...
    '-o', ...
    'LineWidth',1.5, ...
    'MarkerFaceColor','green', ...
    'MarkerSize',5)

title('RR Intervals Over Time')

xlabel('Time (seconds)')

ylabel('RR Interval (seconds)')

grid on

xlim([0 duration])

exportgraphics(gcf,...
    '../results/hrv_plot.png',...
    'Resolution',300);

%% ==========================================================
% Figure 5 - RR Interval Distribution
%% ==========================================================

figure('Name','RR Interval Distribution');

histogram(RRintervals, 10)

title('Distribution of RR Intervals')

xlabel('RR Interval (seconds)')

ylabel('Frequency')

grid on

exportgraphics(gcf, ...
    '../results/rr_histogram.png', ...
    'Resolution',300);

%% ==========================================================
% Figure 6 - Heart Rate Variability Boxplot
%% ==========================================================

figure('Name','HRV Boxplot');

boxplot(RRintervals)

title('Heart Rate Variability (Boxplot)')

ylabel('RR Interval (seconds)')

grid on

exportgraphics(gcf, ...
    '../results/hrv_boxplot.png', ...
    'Resolution',300);

%% ==========================================================
% ECG Analysis Summary
%% ==========================================================

fprintf('\n');
fprintf('=========================================\n');
fprintf(' ECG ANALYSIS SUMMARY\n');
fprintf('=========================================\n');

fprintf('Recording Length : %d seconds\n', duration);
fprintf('Heartbeats       : %d\n', length(peakLocations));
fprintf('Average HR       : %.1f BPM\n', averageHeartRate);
fprintf('Maximum HR       : %.1f BPM\n', maximumHeartRate);
fprintf('Minimum HR       : %.1f BPM\n', minimumHeartRate);
fprintf('Mean RR Interval : %.3f seconds\n', meanRR);
fprintf('SDNN             : %.3f seconds\n', SDNN);

fprintf('=========================================\n');

%% ==========================================================
% Interpretation
%% ==========================================================

fprintf('\nInterpretation:\n');

if averageHeartRate >= 60 && averageHeartRate <= 100
    fprintf('- Average heart rate is within the normal resting range.\n');
else
    fprintf('- Average heart rate is outside the normal resting range.\n');
end

if SDNN > 0.03
    fprintf('- Heart rate variability appears normal.\n');
else
    fprintf('- Heart rate variability appears reduced.\n');
end

%% ==========================================================
% End of Program
%% ==========================================================

fprintf('\n');
fprintf('Analysis completed successfully!\n');
fprintf('All figures have been saved to the results folder.\n');