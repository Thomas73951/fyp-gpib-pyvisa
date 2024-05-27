clc
clear all
close all

% Alternative version of plot_result.m
% Primarily used for tw line measurements.
% used for quasi, plots on same figure

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
##FOLDER_NAME_BASE = ["tw"]; % no final filesep
##FOLDER_NAME = ["line/Coil A/2_1_3_4";
####               "quasi/22apr/2x2"];
##               "quasi/27apr/1x4/adaptor"];
####               "2_1";
####               "2_1_3"]; % no final filesep
##FOLDER_NAME_EXT = ["1"]; % no final filesep
####SAVE_FOLDER = ["tw/quasi/22apr/2x2/images"];
##SAVE_FOLDER = ["tw/quasi/27apr/1x4/images"];
##TITLE = "Effect of Antenna Interaction";
##LEGEND_EXT = ["No Interaction";
####              "2 x 2 Quasi-2D Grid"];
##              "1 x 4, adaptor"];

FOLDER_NAME_BASE = ["tw"]; % no final filesep
FOLDER_NAME = ["quasi/27apr/1x9/adaptor/";
               "quasi/27apr/3x3/adaptor/small";
               "quasi/27apr/3x3/adaptor/medium"];
FOLDER_NAME_EXT = ["1"]; % no final filesep
SAVE_FOLDER = ["tw/quasi/27apr/images"];
TITLE = "Effect of Antenna Interaction";
LEGEND_EXT = ["1 x 9, adaptor";
              "3 x 3, adaptor, small";
              "3 x 3, adaptor, medium"];

LINE_STYLE = ["-";":";"--"];
COLOURS = [0, 0.4470, 0.7410; % blue
           0.8500, 0.3250, 0.0980]; % orange

figure()
for i = 1:rows(FOLDER_NAME)
  readFolder = [FOLDER_NAME_BASE, filesep, strtrim(FOLDER_NAME(i,:)), ...
                filesep, FOLDER_NAME_EXT];
  f = linspace(START_FREQ, STOP_FREQ, 1601);
  hold on
  for j = 1:size(MEAS,1)
    FILE_NAME = ["data_1601_MEAS", MEAS(j), ".csv"];
    data = csvread([readFolder, filesep, FILE_NAME]);
    plot(f/1e6, data, strtrim(LINE_STYLE(i,:)), 'color', COLOURS(j,:),  ...
         'DisplayName', ['S', MEAS(j), '1 ', strtrim(LEGEND_EXT(i,:))])
  endfor


endfor
xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
ylim([-50 0])
legend('location', 'southwest')
grid on
title(TITLE)

if (SAVE_IMG)
  saveImages([SAVE_FOLDER, filesep], "")
endif

