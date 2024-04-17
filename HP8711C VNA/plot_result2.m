clc
clear all
close all

% Alternative version of plot_result.m

SAVE_IMG = false;
START_FREQ = 10e6;
STOP_FREQ = 17e6;
MEAS = ["2";"1"];
##FOLDER_NAME = ["Coil C", filesep, "5"]; % file ^ in this folder
FOLDER_NAME = ["tw", filesep, "line", filesep, "Coil A", filesep, "2", ...
               filesep, "1"];

figure()
f = linspace(START_FREQ, STOP_FREQ, 1601);
hold on
for i = 1:size(MEAS,1)
  FILE_NAME = ["data_1601_MEAS", MEAS(i), ".csv"];
  data = csvread([FOLDER_NAME, filesep, FILE_NAME]);
  plot(f/1e6, data, 'DisplayName', ['S', MEAS(i), '1'])
endfor

xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
ylim([-30 0])
legend()
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif

