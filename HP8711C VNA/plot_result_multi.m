clc
clear all
close all

% Alternative version of plot_result.m
% Primarily used for tw line measurements.

SAVE_IMG = true;
START_FREQ = 10e6;
STOP_FREQ = 17e6;
MEAS = ["2";"1"];
## tw line stuff
##FOLDER_NAME = ["Coil C", filesep, "5"]; % file ^ in this folder
##FOLDER_NAME_BASE = ["tw", filesep, "line", filesep, "Coil A"]; % no final filesep
##FOLDER_NAME = ["2";
##               "2_1";
##               "2_1_3"]; % no final filesep
##FOLDER_NAME_EXT = ["1"]; % no final filesep
##SAVE_FOLDER = ["tw/line/Coil A/images"];

## initial quasi testing
FOLDER_NAME_BASE = ["tw"]; % no final filesep
FOLDER_NAME = ["line/Coil A/2_1_3_4";
               "quasi/22apr/2x2"];
##               "2_1";
##               "2_1_3"]; % no final filesep
FOLDER_NAME_EXT = ["1"]; % no final filesep
SAVE_FOLDER = ["tw/quasi/22apr/2x2/images"];


for i = 1:rows(FOLDER_NAME)
  readFolder = [FOLDER_NAME_BASE, filesep, strtrim(FOLDER_NAME(i,:)), ...
                filesep, FOLDER_NAME_EXT];
  figure()
  f = linspace(START_FREQ, STOP_FREQ, 1601);
  hold on
  for j = 1:size(MEAS,1)
    FILE_NAME = ["data_1601_MEAS", MEAS(j), ".csv"];
    data = csvread([readFolder, filesep, FILE_NAME]);
    plot(f/1e6, data, 'DisplayName', ['S', MEAS(j), '1'])
  endfor
  xlabel("Frequency [MHz]")
  ylabel("Scattering Parameter [dB]")
  xlim([min(f), max(f)]/1e6)
  ylim([-30 0])
  legend()
  grid on
  if (i == 1)
    title(["Line containing ", num2str(i), " Antenna"])
  else
    title(["Line containing ", num2str(i), " Antennas"])
  endif
endfor


if (SAVE_IMG)
  saveImages([SAVE_FOLDER, filesep], "")
endif

