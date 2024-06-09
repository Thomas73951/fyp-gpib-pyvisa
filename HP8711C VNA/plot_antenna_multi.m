clear all
close all

% Simple file plotting, designed for S21 or S11 VNA plots.
% Option to save figure to disk.

SAVE_IMG = true;
FILE_NAME = "data_1601_MEAS1.csv";
FOLDER_NAME_BASE = "tw/Coil A"; % file ^ in this folder, no filesep at end.
FOLDER_NAME = ["a";"b";"c";"d";"e";"f";"g";"h";"i"]; % no final filesep
FOLDER_NAME_EXT = "1";
TITLE = "Coil A Travelling Wave Antennas";


figure()
f = linspace(12.5, 14.5, 1601)*1e6;
##f = linspace(1, 1601, 1601)*1e6;

for i = 1:rows(FOLDER_NAME)

  data = csvread([FOLDER_NAME_BASE, filesep, strtrim(FOLDER_NAME(i,:)), ...
                  filesep, FOLDER_NAME_EXT, filesep, FILE_NAME]);

  minData = min(data);
  minIdx = find(data == minData);
  minFreq = f(minIdx);

  plot(f/1e6, data, 'DisplayName', ['S11 #', num2str(i)])
  hold on
  ##plot([13.56, 13.56], [0 -30], '--k', 'DisplayName', 'f0 (13.56 MHz)')
##  text((minFreq+10e3)/1e6, minData-0.4, ...
##          ["Minimum @ ", num2str(minFreq/1e6), " MHz, ", num2str(minData), " dB"])
endfor

xlabel("Frequency [MHz]")
ylabel("Amplitude [dB]")
xlim([min(f), max(f)]/1e6)
ylim([-35 -5])
##ylim([-60 0])
title(TITLE)
legend('location', 'southwest')
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME_BASE, filesep, 'images', filesep], "")
endif
