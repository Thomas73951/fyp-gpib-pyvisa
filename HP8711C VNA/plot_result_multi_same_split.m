clc
clear all
close all

% Splits S11 and S21 onto separate plots


% Alternative version of plot_result.m
% Primarily used for tw line measurements.
% used for quasi, plots on same figure


SAVE_IMG = true;
START_FREQ = 10e6;
STOP_FREQ = 17e6;
PLOT_SIMULATED = true;
YLIM = [-50 0];
PLOT_FC_FS = true;

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
FOLDER_NAME = [%"line/Coil A/2_1_3_4";
               "quasi/27apr/3x3/small/xl";
##               "quasi/27apr/3x3/adaptor/medium";
               "quasi/27apr/3x3/adaptor/small"];
FOLDER_NAME_EXT = ["1"]; % no final filesep
SAVE_FOLDER = ["tw/images"];
##TITLE = "Effect of Antenna Interaction";
TITLE = "Antenna Configurations";
LEGEND_EXT = [%"1 x 4, no interaction"; %"1 x 4, no interaction, simulated";
##              "1 x 9 Line";
              "3 x 3 Wide Grid";
##              "3 x 3, adaptor, medium gap";
              "3 x 3 Narrow Grid"];
## ALSO PLOTTING KEYSIGHT VNA DATA BIT JANKY



SIM_FOLDER_NAME_BASE = ["tw", filesep, "line", filesep, "Coil A", filesep, "ltspice"];
SIM_FILE_NAME = "k60R1_9";

##FOLDER_NAME_BASE = ["tw"]; % no final filesep
##FOLDER_NAME = ["line/Coil A/2_1_3_4";
##               "quasi/27apr/2x2/adaptor/small";
##               "quasi/27apr/2x2/adaptor/medium"];
##FOLDER_NAME_EXT = ["1"]; % no final filesep
##SAVE_FOLDER = ["tw/quasi/27apr/images"];
##TITLE = "Effect of Antenna Interaction";
##LEGEND_EXT = ["1 x 4, no interaction"; %"1 x 4, no interaction, simulated";
##              "2 x 2, adaptor, small";
##              "2 x 2, adaptor, medium"];
##
##SIM_FOLDER_NAME_BASE = ["tw", filesep, "line", filesep, "Coil A", filesep, "ltspice"];
##SIM_FILE_NAME = "k60R1_4";


% plot simulation data
if (PLOT_SIMULATED)
  simPath = [SIM_FOLDER_NAME_BASE, filesep, ...
             SIM_FILE_NAME, "_"];
  s11Lin = csvread([simPath, "s11.csv"]);
  s21Lin = csvread([simPath, "s21.csv"]);
  s11 = 20*log10(abs(s11Lin));
  s21 = 20*log10(abs(s21Lin));
endif

f = linspace(START_FREQ, STOP_FREQ, 1601);

% initialise figures and plot simulation data
figure(1)
hold on
figure(2)
hold on

if (PLOT_SIMULATED)
  figure(1)
  plot(f/1e6, s11, ':k', 'DisplayName', 'Simulated')
endif
hold on
if (PLOT_SIMULATED)
  figure(2)
  plot(f/1e6, s21, ':k', 'DisplayName', 'Simulated')
endif

% plot the keysight vna stuff
s11Key = csvread([FOLDER_NAME_BASE, filesep, "keysightvna", ...
                filesep, "S11.CSV"]);
s21Key = csvread([FOLDER_NAME_BASE, filesep, "keysightvna", ...
                filesep, "S21.CSV"]);
fKey = s11Key(:,1);
figure(1)
plot(fKey/1e6, s11Key(:,2), 'DisplayName', '1 x 9 Line')
figure(2)
plot(fKey/1e6, s21Key(:,2), 'DisplayName', '1 x 9 Line')


for i = 1:rows(FOLDER_NAME)
  readFolder = [FOLDER_NAME_BASE, filesep, strtrim(FOLDER_NAME(i,:)), ...
                filesep, FOLDER_NAME_EXT];
  for j = 1:2 % for S11 and S21
    FILE_NAME = ["data_1601_MEAS", num2str(j), ".csv"];
    data = csvread([readFolder, filesep, FILE_NAME]);
    figure(j) % selects correct figure to plot onto
    plot(f/1e6, data, 'DisplayName', [strtrim(LEGEND_EXT(i,:))])
  endfor


endfor
figure(1) % S11
xlabel("Frequency [MHz]")
ylabel("S_{11} [dB]") % S11
xlim([min(f), max(f)]/1e6)
##legend('location', 'southwest')
grid on
title([TITLE])

ylim(YLIM)
legend('location', 'southwest', 'Autoupdate', 'off')
if (PLOT_FC_FS)
##  plot([12.7 12.7], YLIM, ':k')
  plot([13.56 13.56], YLIM, '--k')
##  plot([14.4 14.4], YLIM, ':k')
endif

figure(2) % S21
xlabel("Frequency [MHz]")
ylabel("S_{21} [dB]") % S21
xlim([min(f), max(f)]/1e6)
##legend('location', 'south')
grid on
title(TITLE)
ylim(YLIM)
legend('location', 'south', 'Autoupdate', 'off')
if (PLOT_FC_FS)
  plot([12.7 12.7], YLIM, ':k')
  plot([13.56 13.56], YLIM, '--k')
  plot([14.4 14.4], YLIM, ':k')
endif

if (SAVE_IMG)
  saveImages([SAVE_FOLDER, filesep], "")
endif

