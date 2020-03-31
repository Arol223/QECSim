% Rotation matrix for rotation of theta around z-axis
function R_z = R_z(theta)
R_z = cos(theta/2)*eye(2)-1i*sin(theta/2)*[1 0; 0 -1];
end