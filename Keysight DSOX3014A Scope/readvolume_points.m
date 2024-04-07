close all
clear all

##a = linspace(0, 25, 4)
FILENAME = "points5"; % no .csv
a = [0 10 15];
zval = 17;

x = [];
y = [];
z = [];

numpoints = columns(a)

for i = 1:numpoints % for x
  for j = 1:numpoints % for y
    if (!(a(j)>a(i))) % "!(y > x)" takes 1/8 of space rather than one quadrant (1/4)
      x = [x, a(i)];
      y = [y, a(j)];
      z = [z, zval];
    endif
  endfor
endfor

points = transpose(vertcat(x,y,z));

csvwrite([FILENAME, ".csv"], points)


