clc
clear all
close all

% Simple file plotting, designed for S21 or S11 VNA plots.
% Option to save figure to disk.

SAVE_IMG = true;
FILE_NAME = "cal.csv";
FOLDER_NAME = "vna/cal/3"; % file ^ in this folder, no filesep at end.


data = csvread([FOLDER_NAME, filesep, FILE_NAME]);

figure()
##f = linspace(5,20, 801)*1e6;
f = linspace(1, 1601, 1602)*1e6;

plot(f/1e6, data, 'DisplayName', 'S11')
xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
legend()
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep], "")
endif
