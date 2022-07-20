clear

x = readmatrix("x.txt");
Z = readmatrix("Z.txt");
d = readmatrix("d.txt");

real = [];
imaginary = [];

for r = 1:300
    temp_real = Z(r)*sind(d(r));
    real = [real;temp_real];    
    
    temp_imaginary = Z(r)*cosd(d(r));
    imaginary = [imaginary;temp_imaginary];
end

scatter(real,imaginary)