clear all
close all

% Plotting script for use with data collected from keysight scopes,
% in the form "data_CHx.csv" with accompanying "data_CHx_preamble.csv" 
% Optionally saves figures as images back into FOLDER_NAME.

SAVE_IMG = false;
##TITLE = "13.56 MHz sine wave. WAV:POINTS 2000";
TITLE = "Rx from coupler";
CHANNEL = 2;
FOLDER_NAME = "keysight/tag_auto"; % file ^ in this folder, no final filesep


% read files
preamble = csvread([FOLDER_NAME, filesep, ...
                    "data_CH", num2str(CHANNEL), "_preamble.csv"]);
data = csvread([FOLDER_NAME, filesep, ...
                    "data_CH", num2str(CHANNEL), ".csv"]);

% decode preamble
% FORMAT
% TYPE
numPoints = preamble(3);
% COUNT
timeIncrement = preamble(5);
timeStart = preamble(6);
% X other point
% YINCREMENT - min difference between y values
% Y not relevant for plotting
% Y not relevant for plotting


timeEnd = timeStart + numPoints * timeIncrement;
t = linspace(timeStart, timeEnd, numPoints);
##data = data * amplitudeIncrement;

figure() % Channel plot
plot(t, data)
xlabel("Time [s]")
xlim([min(t), max(t)])
ylabel("Amplitude [V]")
title(TITLE)
grid on


if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif
