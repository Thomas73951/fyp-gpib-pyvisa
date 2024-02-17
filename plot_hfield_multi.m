clear all
close all

SAVE_IMG = true;
LOG_PLOT = false;
FILE_NAME = "xsweep_0_40_21.csv";
FOLDER_NAME = ["Coil A";
               "Coil C"];
##FOLDER_NAME = ["Coil C";
##               "Coil C 2"];


sweepDetailsCell = strsplit(strtok(FILE_NAME,'.'),'_');
sweepDetailsCell = sweepDetailsCell(2:end);

sweepDetailsMat = [];

for i = 1:3
  sweepDetailsMat(i) = str2num(cell2mat(sweepDetailsCell(i)));
endfor

x = linspace(sweepDetailsMat(1), sweepDetailsMat(2), sweepDetailsMat(3));

figure()
hold on

for i = 1:size(FOLDER_NAME,1)
  data = csvread([strtrim(FOLDER_NAME(i,:)),filesep, "Hfield", filesep, FILE_NAME]);

  if (LOG_PLOT)
    % Log plot
  ##  plot(x, data, '-x', 'DisplayName', FOLDER_NAME(i,:))
  else
    % Lin plot
    plot(x, power(10, data/20), '-x', 'DisplayName', FOLDER_NAME(i,:))
  endif
endfor

xlabel("x [mm]")
if (LOG_PLOT)
  ylabel("Transmission (S_{21}) representing H field [dB]")
else
  ylabel("Transmission (S_{21}) representing H field - Linearised")
endif
title("Plot of H Field strength for different probe positions (y ~ 0 mm, z ~5 mm)")
grid on
legend('FontSize',11)

if (SAVE_IMG)
  saveImages(["images", filesep],
              ["overlay_xsweep_", num2str(sweepDetailsMat(1)), "_", ...
              num2str(sweepDetailsMat(2)), "_", ...
              num2str(sweepDetailsMat(3)), " "])
endif
