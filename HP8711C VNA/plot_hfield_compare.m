clear all
close all

% COPY OF plot_hfield.m BUT DOES "COMPARISON" BETWEEN SIMULATION AND EXPERIMENTAL

% TODO: support for more sweeps, curr. x sweep at z = 5mm
% TODO: fix that experiment was actually 4mm not 5.

% Expects sim files from fastHenryHelper by Thomas Sharratt (c) 2024.
% Other files may be compatible but need rewriting of "Process sim file" section
% due to file information location and decoding methods.

% Original frontmatter:
% Plotting script for use with hfield.py
% This is used to create plots of H field measurements across x,y or z
% Takes information from the file name if possible,
% otherwise: set STANDARD_SWEEP false & enter points in manual point entry (typ used for z sweep)
% optionally saves figures as images back into FOLDER_NAME.

SIM_FOLDER_NAME = ["C1_T5_ID40_S1_W0.4", filesep, "C2_T20_ID0.2_S0.1_W0.03"];
MEAS_FOLDER_NAME = "Coil A";
% Coil C
##SIM_FOLDER_NAME = ["C1_T9_ID10_S2.4_W0.4", filesep, "C2_T20_ID0.2_S0.1_W0.03"];
##MEAS_FOLDER_NAME = "Coil C";

% should be the same filename for any of the above folders from how it's generated
SIM_FILE_NAME = ["Sweep2_inductances.csv"];
MEAS_FILE_NAME = "xsweep_0_40_21.csv";

% Other settings:
LINE_WIDTH = 1;
SAVE_IMG = true;
NORMALISED = true; % "normalised", sets axes to 0 -> max for each plot


% PROCESS MEASURED FILE
measData = csvread([strtrim(MEAS_FOLDER_NAME), filesep, "Hfield", filesep, ...
                    MEAS_FILE_NAME]);
% linearise data
measData = power(10, measData/20);

% find sweep from filename
sweepDetailsCell = strsplit(strtok(MEAS_FILE_NAME,'.'),'_');
sweepDetailsCell = sweepDetailsCell(2:end);
sweepDetailsMat = [];
for i = 1:3
  sweepDetailsMat(i) = str2num(cell2mat(sweepDetailsCell(i)));
endfor


% PROCESS SIMULATION FILE
simData = csvread([strtrim(SIM_FOLDER_NAME), filesep, SIM_FILE_NAME]);
sweepX = simData(:,2); % requires comma separated folder name: ".../Offset,x,y/"
sweepY = simData(:,3);
sweepZ = simData(:,4);
L1 = simData(:,6);
L2 = simData(:,7);
M = simData(:,8);
k = M ./ sqrt(L1.*L2);
sweepVar = sweepX;
sweepAxis = "x";
##constCoords = ['y = ', num2str(sweepY(1)), ', z = ', num2str(sweepZ(1))];


% set up axis
x = linspace(sweepDetailsMat(1), sweepDetailsMat(2), sweepDetailsMat(3));


% PLOTTING
figure()
hold on
% Lin plot of meas
##plot(x, power(10, measData/20), MEAS_PLOT_MARKER, 'DisplayName', 'Measured', 'LineWidth', LINE_WIDTH)
% Coupling factor plot of sim data
##plot(sweepVar, k, SIM_PLOT_MARKER, 'DisplayName', 'Simulated', 'LineWidth', LINE_WIDTH)

[ax, h1, h2] = plotyy(x, measData, sweepVar, k); % two y axis plot
set([h1,h2], 'LineWidth', LINE_WIDTH)
set(h1, 'DisplayName', 'Measured')
set(h2, 'DisplayName', 'Simulated')
set(h1, 'marker', 'x')
##set(h2, 'marker', SIM_PLOT_MARKER)


xlabel("Sweep over x-axis [mm]")
ylabel(ax(1), "Transmission (S_{21}) representing H field - Linearised")
ylabel(ax(2), "Coupling Factor []")
if (NORMALISED)
  ylim(ax(1), [min(measData) max(measData)])
  ylim(ax(2), [0 max(k)])
endif
title("Plot of H Field strength for different probe positions (y = 0 mm, z = 5 mm)")
grid on
legend('FontSize',11)


if (SAVE_IMG)
  saveImages(["images", filesep],
              ["Comparison - ", MEAS_FOLDER_NAME, " "])
endif
