clear all
close all

SAVE_IMG = true;
SWEEP_TYPE = 'z';
##FILE_NAME = "xsweep_0_40_21.csv";
FILE_NAME = ["zsweepx0_4_87_8.csv";
             "zsweepx10_4_87_8.csv";
             "zsweepx20_4_87_8.csv"];
##FOLDER_NAME = ["Coil A";
##               "Coil C"];
FOLDER_NAME = ["Coil A"];
##               "Coil C 2"];
##               "Coil C 3"];
STANDARD_SWEEP = false; % true if using linspace, false if arbitrary list of points
% if not, fill in x below accordingly
##TITLE = "Plot of H Field strength for different probe positions (y ~ 0 mm, z ~5 mm)";
TITLE = "Z sweep measurement of coil A at x = 0, 10, 20 mm";


if (STANDARD_SWEEP) % linspace extracted from filename data
  sweepDetailsCell = strsplit(strtok(FILE_NAME,'.'),'_');
  sweepDetailsCell = sweepDetailsCell(2:end)

  sweepDetailsMat = [];

  for i = 1:3
    sweepDetailsMat(i) = str2num(cell2mat(sweepDetailsCell(i)));
  endfor

  x = linspace(sweepDetailsMat(1), sweepDetailsMat(2), sweepDetailsMat(3));
else
  % manual point entry
  x = [4, 17, 27, 37, 50, 67, 77, 87];
endif

figure()
hold on

for i = 1:size(FOLDER_NAME,1)
  for j = 1:size(FILE_NAME,1)
    data = csvread([strtrim(FOLDER_NAME(i,:)),filesep, "Hfield", filesep, ...
                    strtrim(FILE_NAME(j,:))]);

    plot(x, power(10, data/20), '-x', ...
         'DisplayName', [FOLDER_NAME(i,:), ' - ', FILE_NAME(j,:)])
  endfor
endfor

xlabel([SWEEP_TYPE, " [mm]"])
ylabel("Transmission (S_{21}) representing H field - Linearised")
title(TITLE)
grid on
legend('FontSize',11, 'Interpreter', 'none')

if (SAVE_IMG)
  if (STANDARD_SWEEP)
    saveImages(["images", filesep],
              ["overlay_", SWEEP_TYPE, "sweep_", num2str(sweepDetailsMat(1)), "_", ...
              num2str(sweepDetailsMat(2)), "_", ...
              num2str(sweepDetailsMat(3)), " "])
  else
    saveImages(["images", filesep],
              ["overlay_", SWEEP_TYPE, "sweep_"])
  endif
endif
