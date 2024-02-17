clear all
close all

SAVE_IMG = true;
FILE_NAME = "xsweep_0_40_21.csv";
FOLDER_NAME = "coilC/Hfield"; % file ^ in this folder


sweepDetailsCell = strsplit(strtok(FILE_NAME,'.'),'_');
sweepDetailsCell = sweepDetailsCell(2:end)

sweepDetailsMat = [];

for i = 1:3
  sweepDetailsMat(i) = str2num(cell2mat(sweepDetailsCell(i)));
endfor

x = linspace(sweepDetailsMat(1), sweepDetailsMat(2), sweepDetailsMat(3));
data = csvread([FOLDER_NAME, filesep, FILE_NAME]);

figure()
plot(x, data, '-x')
xlabel("x [mm]")
ylabel("Transmission (S_{21}) representing H field [dB]")
grid on

if (SAVE_IMG)
  saveImages([FOLDER_NAME, filesep],
              ["xsweep_", num2str(sweepDetailsMat(1)), "_", ...
              num2str(sweepDetailsMat(2)), "_", ...
              num2str(sweepDetailsMat(3)), " "])
endif
