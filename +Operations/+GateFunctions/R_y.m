% Rotate angle theta around y-axis.
function R_y = R_y(theta)
R_y = cos(theta/2)*eye(2) -1i*sin(theta/2)*[0 -1i;1i 0];
end