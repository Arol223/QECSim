% Rotate angle theta around x-axis.
function R_x = R_x(theta)
R_x = cos(theta/2)*eye(2) -1i*sin(theta/2)*[0 1; 1 0];
end