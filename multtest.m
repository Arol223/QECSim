rho=rand(2^13,2^13);
X = sparse([0 1;1 0]);
temp = X;
for i=1:12
   temp = kron(temp,X); 
end
tic;
C=temp*rho*temp;
toc
tic;
rho*rho;
toc