clc
clear all
close all

% Alternative version of plot_result.m
% Primarily used for tw line measurements.

SAVE_IMG = false;
START_FREQ = 10e6;
STOP_FREQ = 17e6;
MEAS = ["2";"1"];
##FOLDER_NAME = ["Coil C", filesep, "5"]; % file ^ in this folder
FOLDER_NAME_BASE = ["tw", filesep, "line", filesep, "Coil A"]; % no final filesep
FOLDER_NAME = ["2";
               "2_1";
               "2_1_3";
               "2_1_3_4";
               "2_1_3_4_5"]; % no final filesep
FOLDER_NAME_EXT = ["1"]; % no final filesep
SAVE_FOLDER = ["tw/line/Coil A/images"];


SIM_FOLDER_NAME_BASE = ["tw", filesep, "line", filesep, "Coil A", filesep, "ltspice"];
SIM_FILE_NAME = "k60R1_"; % actually "k59_1_s11.csv"

COLOURS = [0, 0.4470, 0.7410; % blue
           0.8500, 0.3250, 0.0980]; % orange


for i = 1:rows(FOLDER_NAME)
  readFolder = [FOLDER_NAME_BASE, filesep, strtrim(FOLDER_NAME(i,:)), ...
                filesep, FOLDER_NAME_EXT];
  figure()

  % plot measured data
  f = linspace(START_FREQ, STOP_FREQ, 1601);
  hold on
  for j = 1:size(MEAS,1)
    FILE_NAME = ["data_1601_MEAS", MEAS(j), ".csv"];
    data = csvread([readFolder, filesep, FILE_NAME]);
    plot(f/1e6, data, 'color', COLOURS(j,:), 'DisplayName', ['S', MEAS(j), '1 Measured'])
  endfor

  % plot simulation data
  simPath = [SIM_FOLDER_NAME_BASE, filesep, ...
             SIM_FILE_NAME, num2str(i), "_"];
  s11Lin = csvread([simPath, "s11.csv"]);
  s21Lin = csvread([simPath, "s21.csv"]);
  s11 = 20*log10(abs(s11Lin));
  s21 = 20*log10(abs(s21Lin));
  plot(f/1e6, s21, '--', 'color', COLOURS(1,:), 'DisplayName', 'S21 Simulated')
  plot(f/1e6, s11, '--', 'color', COLOURS(2,:), 'DisplayName', 'S11 Simulated')

  xlabel("Frequency [MHz]")
  ylabel("Magnitude [dB]")
  xlim([min(f), max(f)]/1e6)
  ylim([-50 0])
  legend('location', 'southwest')
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

