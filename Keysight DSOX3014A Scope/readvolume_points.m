close all
clear all

% Script to generate a file containing coordinates for use in detect_tag_multi.py
% In the form:
% x1,y1,z1
% x2,y2,z2
% etc.
% Creates all possible coordinates using `a`, at a fixed z (zval)

##a = linspace(0, 25, 4)
FILENAME = "points5"; % no .csv
a = [0 10 15];
zval = 17;

x = [];
y = [];
z = [];

numpoints = columns(a)

% generates all for x > 0, y > 0 (one quadrant) and also x => y, 
% roughly 1/8 of state space. Possible because coil is square so abusing symmetry
for i = 1:numpoints % for x
  for j = 1:numpoints % for y
    if (!(a(j)>a(i))) % "!(y > x)" takes 1/8 of space rather than one quadrant
      x = [x, a(i)];
      y = [y, a(j)];
      z = [z, zval];
    endif
  endfor
endfor

points = transpose(vertcat(x,y,z));

csvwrite([FILENAME, ".csv"], points)


