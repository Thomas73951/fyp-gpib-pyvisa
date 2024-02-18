clc
clear all
close all

SAVE_IMG = true;
FILE_NAME = "data_801_MEAS1.csv";
FOLDER_NAME = "coilA/neatlysoldered/1"; % file ^ in this folder


data = csvread([FOLDER_NAME, filesep, FILE_NAME]);

figure()
f = linspace(5,20, 801)*1e6;

plot(f/1e6, data, 'DisplayName', 'S11')
xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
legend()
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif
