% Matrix for rotating angle theta around axis n defined by an R^3 vector.
function R_n = R_n(n,theta)
n = n/norm(n);
I = eye(2);
X = [0 1; 1 0];
Y = [0 -1i;1i 0];
Z = [1 0; 0 -1];
R_n = cos(theta/2)*I -sin(theta/2)*(n(1)*X + n(2)*Y + n(3)*Z);
end