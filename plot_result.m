clc
clear all
close all

SAVE_IMG = true;
FILE_NAME = "data_1601.csv";

data = csvread(FILE_NAME)

figure()
f = linspace(10,100, 1601)*1e6;

plot(f/1e6, data, 'DisplayName', 'S21')
xlabel("Frequency [MHz]")
ylabel("Scattering Parameter [dB]")
xlim([min(f), max(f)]/1e6)
legend()
grid on

if (SAVE_IMG)
  saveImages(["images", filesep])
endif
