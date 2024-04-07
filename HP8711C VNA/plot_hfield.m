clear all
close all

% Plotting script for use with hfield.py
% This is used to create plots of H field measurements across x,y or z
% Takes information from the file name if possible,
% otherwise: set STANDARD_SWEEP false & enter points in manual point entry (typ used for z sweep)
% optionally saves figures as images back into FOLDER_NAME.

SAVE_IMG = false;
SWEEP_TYPE = 'z'; % for correct x axis name of plots
TITLE = "Z sweep measurement of coil C at x = 0 mm"; % figure titles
FILE_NAME = "zsweep_4_87_8.csv"; % in format "..._START_STOP_POINTS.csv" for linspace
FOLDER_NAME = "Coil C/Hfield"; % file ^ in this folder
STANDARD_SWEEP = false; % true if using linspace, false if arbitrary list of points
% if not, fill in x below accordingly

if (STANDARD_SWEEP)
  % linspace of x axis extracted from filename data when a standard sweep
  sweepDetailsCell = strsplit(strtok(FILE_NAME,'.'),'_');
  sweepDetailsCell = sweepDetailsCell(2:end)
  sweepDetailsMat = [];
  for i = 1:3
    sweepDetailsMat(i) = str2num(cell2mat(sweepDetailsCell(i)));
  endfor

  % linspace from filename data.
  x = linspace(sweepDetailsMat(1), sweepDetailsMat(2), sweepDetailsMat(3));
else
  % manual point entry
  x = [4, 17, 27, 37, 50, 67, 77, 87];
endif

% read file
data = csvread([FOLDER_NAME, filesep, FILE_NAME]);

% PLOTTING

figure() % s21 plot in dB
plot(x, data, '-x')
xlabel([SWEEP_TYPE, " [mm]"])
ylabel("Transmission (S_{21}) representing H field [dB]")
title(TITLE)
grid on

figure() % linearised plot
% linearise data
linData = power(10, data/20);
plot(x, linData, '-x')
xlabel([SWEEP_TYPE, " [mm]"])
ylabel("Transmission (S_{21}) representing H field - Linearised")
title(TITLE)
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep],
              [SWEEP_TYPE, "sweep_", num2str(sweepDetailsMat(1)), "_", ...
              num2str(sweepDetailsMat(2)), "_", ...
              num2str(sweepDetailsMat(3)), " "])
endif
