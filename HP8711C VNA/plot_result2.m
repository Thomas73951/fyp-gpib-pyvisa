clc
clear all
close all

% Alternative version of plot_result.m

SAVE_IMG = true;
START_FREQ = 13e6;
STOP_FREQ = 15e6;
MEAS = ["2";"1"];
##FOLDER_NAME = ["Coil C", filesep, "5"]; % file ^ in this folder
FOLDER_NAME = ["vna", filesep, "rxfilt_12mar", filesep, "13_15"];


figure()
f = linspace(START_FREQ, STOP_FREQ, 801);
hold on
for i = 1:size(MEAS,1)
  FILE_NAME = ["data_801_MEAS", MEAS(i), ".csv"];
  data = csvread([FOLDER_NAME, filesep, FILE_NAME]);
  plot(f/1e6, data, 'DisplayName', ['S', MEAS(i), '1'])
endfor

xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
legend()
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif

