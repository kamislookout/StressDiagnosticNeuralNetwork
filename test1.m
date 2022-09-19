wfdb2mat('auto/drive03')

% "Please, note that detecting QRS in ECG data is non trivial task, and
% still many research are conducted to improve the accuracy of detection algorithms."

% This is still very drafty when it comes to pre-processing. However, the
% preprocessing you'd expect has been done....it's just not able to be
% fully seen since the data we have is actually REALLY large (like 9000+
% signals large for each drive).

%Here is how this works: we need to process the ECG wave by doing

% 1. Use a fast Fourier transformation to cause the ECG wave to be
% straight. This way we will have a wave that has all low frequencies
% within it removed

% (a high frequency pass can be done but doesn't seem necessary)

% 2. Find local maxima. (We'll juse use a windowed filter that will only
% "see" maximums and ignore other values.)

% Taken by final the data will look like a bunch of R peaks with varying
% peaks ranging from 0-1 (normalization of features).

load('drive03m.mat');
x = (val(1,:));
y = sgolayfilt(x, 0, 5);
[M,N] = size(y);

Fpass  = 200;
Fstop = 400;
Dpass = 0.05;
Dstop = 0.0001;
F     = [0 Fpass Fstop Fs/2]/(Fs/2);
A     = [1 1 0 0];
D     = [Dpass Dstop];
b = firgr('minorder',F,A,D);
LP = dsp.FIRFilter('Numerator',b);

Fstop = 200;
Fpass = 400;
Dstop = 0.0001;
Dpass = 0.05;
F = [0 Fstop Fpass Fs/2]/(Fs/2); % Frequency vector
A = [0 0 1 1]; % Amplitude vector
D = [Dstop Dpass];   % Deviation (ripple) vector
b  = firgr('minord',F,A,D);
HP = dsp.FIRFilter('Numerator',b);

tic;
while toc < 30
    x = .1 * randn(M,N);
    highFreqNoise = HP(x);
    noisySignal = y + highFreqNoise;
    filteredSignal = LP(noisySignal);
end

plot(filteredSignal);
