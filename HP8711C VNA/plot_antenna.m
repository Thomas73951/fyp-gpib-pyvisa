clc
clear all
close all

% Simple file plotting, designed for S21 or S11 VNA plots.
% Option to save figure to disk.

SHOW_NOTCH_TEXT = false;
PLOT_FC_FS = true;
SAVE_IMG = false;
YLIM = [-50 0];
FILE_NAME = "data_1601_MEAS1.csv";
FOLDER_NAME = "antenna/Coil A/2"; % file ^ in this folder, no filesep at end.
TITLE = "Coil A";
##FOLDER_NAME = "antenna/Coil A 1W/1";
##TITLE = "Coil A 1W";
##FOLDER_NAME = "antenna/Coil C/1";
##TITLE = "Coil C";
##FOLDER_NAME = "Coil C 1W/10";
##TITLE = "Coil C 1W";



data = csvread([FOLDER_NAME, filesep, FILE_NAME]);

figure()
f = linspace(13.5-1, 13.5+1, 1601)*1e6;
##f = linspace(1, 1601, 1601)*1e6;

minData = min(data);
minIdx = find(data == minData);
minFreq = f(minIdx);

plot(f/1e6, data, 'DisplayName', 'S_{11}')
hold on
##plot([13.56, 13.56], [0 -30], '--k', 'DisplayName', 'f0 (13.56 MHz)')
if (SHOW_NOTCH_TEXT)
  text((minFreq+10e3)/1e6, minData-0.4, ...
          ["Minimum @ ", num2str(minFreq/1e6), " MHz, ", num2str(minData), " dB"])
endif
legend('location', 'southwest', 'Autoupdate', 'off')
if (PLOT_FC_FS)
  plot([12.7 12.7], YLIM, ':k')
  plot([13.56 13.56], YLIM, '--k')
  plot([14.4 14.4], YLIM, ':k')
endif
xlabel("Frequency [MHz]")
ylabel("Amplitude [dB]")
xlim([min(f), max(f)]/1e6)
ylim(YLIM)
grid on
title(TITLE)

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif
