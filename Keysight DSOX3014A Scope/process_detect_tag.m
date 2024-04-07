clear all
close all

pkg load ltfat
pkg load signal

SHOW_FIGURES = true;
##FOLDER_NAME = ["keysight/tag_auto/coilC_tinytag_hpamp_15dbm/", ...
##               "z23/x0"];
FOLDER_NAME = ["keysight/tag_4apr/E/CoilA1W/2/", ...
               "z23/y0/x0/3"];
carrierFreq = 13.56e6;
dataRate = carrierFreq / 128;
tData = 1 / dataRate;
subcarrierFreq = carrierFreq + carrierFreq / 16; % 13.56 MHz + 847.5 KHz


CHANNEL = 2;
% read files
preamble = csvread([FOLDER_NAME, filesep, ...
                    "data_CH", num2str(CHANNEL), "_preamble.csv"]);
data = csvread([FOLDER_NAME, filesep, ...
                    "data_CH", num2str(CHANNEL), ".csv"]);

% decode preamble
% FORMAT
% TYPE
numPoints = preamble(3);
##numPoints = 62499; % OVERRIDE
% COUNT
timeIncrement = preamble(5);
timeStart = preamble(6);
% X other point
% YINCREMENT - min difference between y values
% Y not relevant for plotting
% Y not relevant for plotting

% with time start set to 0.
##timeEnd = timeStart + numPoints * timeIncrement;
timeEnd = numPoints * timeIncrement;
timeStart = 0;

t = linspace(timeStart, timeEnd, numPoints);fs = 1 / timeIncrement;
fs = 1 / timeIncrement;
##data = data * amplitudeIncrement;

sampleFreq = 1 / timeIncrement;
disp(["Time sampling frequency = ", num2str(sampleFreq/1e6), " MHz"])

if (sampleFreq < 2*15e6)
  disp("WARNING Sample frequency too low")
endif

##if (SHOW_FIGURES)
##  figure() % Channel plot
##  plot(t, data)
##  xlabel("Time [s]")
##  xlim([min(t), max(t)])
##  ylabel("Amplitude [V]")
##  grid on
##endif

##dataFFT = fft(data); % uncropped unfiltered FFT
##if (SHOW_FIGURES)
##  figure()
##  plotfft(dataFFT, fs)
##  xlim([0 fs/2])
####  xlim([10e6 17e6])
##endif

%%%%%%

% Filter data, bandpass again
butterFc = subcarrierFreq; % shift cutoff with multiplier
butterBW = 200e3;
butterF = [butterFc - butterBW / 2, butterFc + butterBW / 2]; % fl, fh
butterOrder = 7;
[b,a] = butter(butterOrder, [butterF]*2/fs, "bandpass");
% low pass Butterworth filter with cutoff pi*Wc radians - choose the order of the filter n and cut-off frequency Wc to suit
data = filter(b,a,data);

##if (SHOW_FIGURES)
  figure() % Channel plot
  plot(t, data)
  xlabel("Time [s]")
  xlim([min(t), max(t)])
  ylabel("Amplitude [V]")
  grid on
##endif

% uncropped FFT
##dataFFT = fft(data);
##if (SHOW_FIGURES)
##  figure()
##  plotfft(dataFFT, fs)
####  xlim([0 fs/2])
####  xlim([10e6 17e6])
####  xlim([13e6 15e6])
##  xlim([subcarrierFreq-0.5e6, subcarrierFreq+0.5e6])
##  grid on
##endif

% crop data for tag response
tagRx1(1) = 150e-6 / timeIncrement;
tagRx1(2) = 450e-6 / timeIncrement;

t = t(tagRx1(1):tagRx1(2));
data = data(tagRx1(1):tagRx1(2));

# cropped & filtered plot of reponse - time domain
##if (SHOW_FIGURES)
##  figure() % Channel plot
##  plot(t, data)
##  xlabel("Time [s]")
##  xlim([min(t), max(t)])
##  ylabel("Amplitude [V]")
##  grid on
##endif

% cropped & filtered plot of reponse - fft
dataFFT = fft(data);
if (SHOW_FIGURES)
  figure()
  plotfft(dataFFT, fs)
  ##xlim([0 100e6])
##  xlim([10e6 17e6])
  xlim([subcarrierFreq-0.5e6, subcarrierFreq+0.5e6])
  grid on
  ylim([-60 40])
endif
