clear all
close all

% COPY OF plot_hfield.m BUT PLOTS MULTIPLE FILES
% This can be multiple files or multiple folders, or both.

% Original frontmatter:
% Plotting script for use with hfield.py
% This is used to create plots of H field measurements across x,y or z
% Takes information from the file name if possible,
% otherwise: set STANDARD_SWEEP false & enter points in manual point entry (typ used for z sweep)
% optionally saves figures as images back into FOLDER_NAME.
##figure()

SAVE_IMG = true;
SWEEP_TYPE = 'x'; % for correct x axis name of plots
% FILE_NAME in format: "..._START_STOP_POINTS.csv" for linspace (STANDARD_SWEEP)
FILE_NAME = "/Hfield/xsweep_0_40_21.csv";
##FILE_NAME = ["zsweepx0_4_87_8.csv";
##             "zsweepx10_4_87_8.csv";
##             "zsweepx20_4_87_8.csv"];
##FILE_NAME = "xsweep_0_25_6.csv";
PRINT_FILE_NAME = false;
FOLDER_NAME = ["Coil A";
               "Coil C"];
##FOLDER_NAME = ["Coil A"];
##               "Coil C 2"];
##               "Coil C 3"];
##FOLDER_NAME = ["tw/hfield/Coil A/B";
##               "tw/hfield/Coil A/2_1/2";
##               "tw/hfield/Coil A/2_1_3/2";
##               "tw/hfield/Coil A/pcb1"];

STANDARD_SWEEP = true; % true if using linspace, false if arbitrary list of points
% if not, fill in x below accordingly
##TITLE = "Plot of H Field strength for different probe positions (y ~ 0 mm, z ~4 mm)";
##TITLE = "Z sweep measurement of coil A at x = 0, 10, 20 mm"; % figure titles
##TITLE = "X sweep measurement of coil A(#2)\nat z = 4 mm";#\nSingle & Chain of #2, #1"; % figure titles
TITLE = "Magnetic Field Strength, y = 0, z = 0";

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


% PLOTTING

figure()
hold on

for i = 1:size(FOLDER_NAME,1) % multiple folders
  for j = 1:size(FILE_NAME,1) % multiple files
##    data = csvread([strtrim(FOLDER_NAME(i,:)),filesep, "Hfield", filesep, ...
##                    strtrim(FILE_NAME(j,:))]);
    data = csvread([strtrim(FOLDER_NAME(i,:)),filesep, ...
                    strtrim(FILE_NAME(j,:))]);

    if (PRINT_FILE_NAME)
      plot(x, power(10, data/20)/0.0073, '-x', ...
           'DisplayName', [FOLDER_NAME(i,:), ' - ', FILE_NAME(j,:)])
    else
      plot(x, power(10, data/20)/0.0073, '-x', ...
           'DisplayName', [FOLDER_NAME(i,:)])
    endif
  endfor
endfor

xlabel([SWEEP_TYPE, " [mm]"])
ylabel("Normalised Relative H Field []")
title(TITLE)
grid on
legend('location', 'southwest', 'Interpreter', 'none') #'FontSize',11,
##yticklabels(linspace(0, 1, 5))

##if (SAVE_IMG)
##  if (STANDARD_SWEEP)
##    saveImages(["images", filesep],
##              ["overlay_", SWEEP_TYPE, "sweep_", num2str(sweepDetailsMat(1)), "_", ...
##              num2str(sweepDetailsMat(2)), "_", ...
##              num2str(sweepDetailsMat(3)), " "])
##  else
##    saveImages(["images", filesep],
##              ["overlay_", SWEEP_TYPE, "sweep_"])
##  endif
##endif

if (SAVE_IMG)
  saveImages("images/", "")
endif
