clc;
clear;
close all;

% Signal Fault Detection in Communication System
% Real-life MATLAB Signal Processing Project

disp("Signal Fault Detection Project Started...");

%% Signal Parameters
fs = 1000;              % Sampling frequency
t = 0:1/fs:1;           % Time vector
fc = 50;                % Carrier frequency

%% Original Communication Signal
originalSignal = sin(2*pi*fc*t);

%% Add Noise
noise = 0.3 * randn(size(t));
noisySignal = originalSignal + noise;

%% Create Faulty Signal
faultySignal = noisySignal;

% Fault 1: Sudden amplitude drop
faultySignal(400:600) = faultySignal(400:600) * 0.25;

% Fault 2: Signal spike
faultySignal(750:760) = faultySignal(750:760) + 3;

%% Fault Detection
thresholdLow = 0.4;
thresholdHigh = 2.2;

faultIndex = abs(faultySignal) < thresholdLow | abs(faultySignal) > thresholdHigh;

%% Calculate Fault Percentage
faultPercentage = (sum(faultIndex) / length(faultySignal)) * 100;

fprintf("Detected Fault Percentage: %.2f%%\n", faultPercentage);

if faultPercentage > 10
    disp("System Status: Fault Detected");
else
    disp("System Status: Signal is Normal");
end

%% Frequency Analysis using FFT
N = length(faultySignal);
f = fs*(0:N-1)/N;

fftOriginal = abs(fft(originalSignal));
fftFaulty = abs(fft(faultySignal));

%% Plot Signals
figure("Name","Communication Signal Fault Detection","NumberTitle","off");

subplot(3,1,1);
plot(t, originalSignal, "LineWidth", 1.2);
grid on;
title("Original Communication Signal");
xlabel("Time (s)");
ylabel("Amplitude");

subplot(3,1,2);
plot(t, noisySignal, "LineWidth", 1.2);
grid on;
title("Noisy Communication Signal");
xlabel("Time (s)");
ylabel("Amplitude");

subplot(3,1,3);
plot(t, faultySignal, "LineWidth", 1.2);
hold on;
plot(t(faultIndex), faultySignal(faultIndex), "ro", "MarkerSize", 4);
grid on;
title("Faulty Signal with Detected Fault Points");
xlabel("Time (s)");
ylabel("Amplitude");
legend("Faulty Signal","Detected Fault");

%% FFT Plot
figure("Name","Frequency Domain Analysis","NumberTitle","off");

plot(f(1:N/2), fftOriginal(1:N/2), "LineWidth", 1.3);
hold on;
plot(f(1:N/2), fftFaulty(1:N/2), "LineWidth", 1.3);
grid on;
title("FFT Analysis of Original and Faulty Signal");
xlabel("Frequency (Hz)");
ylabel("Magnitude");
legend("Original Signal","Faulty Signal");

%% Save Result
resultTable = table(t', originalSignal', noisySignal', faultySignal', faultIndex', ...
    'VariableNames', {'Time','OriginalSignal','NoisySignal','FaultySignal','FaultDetected'});

writetable(resultTable, "signal_fault_detection_output.csv");

disp("Analysis Completed. Output saved as signal_fault_detection_output.csv");