clear all
close all

pkg load ltfat
pkg load signal

SHOW_FIGURES = true;
##FOLDER_NAME = ["keysight/tag_auto/coilC_tinytag_hpamp_15dbm/", ...
##               "z23/x0"];
FOLDER_NAME = ["keysight/tag_auto/rxChain/", ...
              "coilC1W_10dBm_z13/9"];
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

if (SHOW_FIGURES)
  figure() % Channel plot
  plot(t, data)
  xlabel("Time [s]")
  xlim([min(t), max(t)])
  ylabel("Amplitude [V]")
  grid on
endif

##dataFFT = fft(data);
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

dataFFT = fft(data);
if (SHOW_FIGURES)
  figure()
  plotfft(dataFFT, fs)
##  xlim([0 fs/2])
##  xlim([10e6 17e6])
  xlim([13e6 15e6])
endif

% crop data for tag response
tagRx1(1) = 150e-6 / timeIncrement;
tagRx1(2) = 400e-6 / timeIncrement;

t = t(tagRx1(1):tagRx1(2));
data = data(tagRx1(1):tagRx1(2));

# re plot channel time domain
if (SHOW_FIGURES)
  figure() % Channel plot
  plot(t, data)
  xlabel("Time [s]")
  xlim([min(t), max(t)])
  ylabel("Amplitude [V]")
  grid on
endif


##dataFFT = fft(data);
##if (SHOW_FIGURES)
##  figure()
##  plotfft(dataFFT, fs)
##  ##xlim([0 100e6])
##  xlim([10e6 17e6])
##endif


##
##% mix to baseband
##baseband = data .* sin(2*pi*subcarrierFreq*t);
####figure()
####plot(t,baseband)
##
##butterFc = dataRate*1; % shift cutoff with multiplier
##butterOrder = 5;
##[b,a] = butter(butterOrder, (pi*butterFc)/fs, "low");
##% low pass Butterworth filter with cutoff pi*Wc radians - choose the order of the filter n and cut-off frequency Wc to suit
##filtBaseband = filter(b,a,baseband);
##
##if (SHOW_FIGURES)
##  figure()
##  plot(t, filtBaseband)
##endif
##
##basebandFFT = fft(baseband);
##basebandFiltFFT = fft(filtBaseband);
##
##if (SHOW_FIGURES)
##  figure()
##  hold on
##  plotfft(basebandFFT,fs)
##  plotfft(basebandFiltFFT,fs)
##  ##xlim([0 17e6])
##  xlim([0 1e6])
##  legend('Before filtering', 'After filtering')
##endif
##
##% process the digital data
##filtBaseband = -filtBaseband; % flip data
##filtBaseband = filtBaseband - min(filtBaseband); % shift min value to 0
##scalingFactor = 1 / max(abs(filtBaseband));
##digital = filtBaseband * scalingFactor; % normalise to 0 - 1 for data.
##
##figure()
##xlabel("Time [s]")
##ylabel("Digital Value []")
##ylim([-0.1 1.1])
##hold on
##plot(t, digital)
##
##function digital = compareDigital(data, value)
##  % compares data to threshold value and sets to 0 or 1 for each.
##  for i = 1:size(data,2)
##    if (data(i) > value)
##      digital(i) = 1;
##    else
##      digital(i) = 0;
##    endif
##  endfor
##endfunction
##
##digital = compareDigital(digital, 0.5);
##crossings = zerocrossing(t, digital - 0.5);
##
##% crop data to message start
##messageStart = crossings(1) - tData/2
##
##idx = find(abs(t-messageStart)<timeIncrement);
##t = t(idx(1):end);
##digital = digital(idx(1):end);
##plot(t, digital)
####xlim([min(t) max(t)])
##
##
######clockOffset = mod(crossings(1),tData);
####clockOffset = crossings(1) / tData
####clockOffset = mod(clockOffset,1)
####clockOffset = (1 - clockOffset) * tData
####clockOffset = clockOffset - tData/2
######clockOffset = 1e-6;
##clockOffset = tData / 4;
##clock = 0.5*(1 + square(2*pi*dataRate*(t + clockOffset)));
####
######plot(t, clock)
##plot(t, 0.5*(0.5 + clock)) % offset and shrunk for visibility.
######plot(t+clockOffset, 0.5*(0.5 + clock)) % offset and shrunk for visibility.
####
######figure()
######clockFFT = fft(clock);
######plotfft(clockFFT)
########xlim([0 1e6])
##
##
##sampleTimes = zerocrossing(t, clock - 0.5);
##tSize = size(t,2);
##sampleTimesIdx = round(zerocrossing(linspace(0,tSize, tSize), clock-0.5));
##
##digital(sampleTimesIdx)
