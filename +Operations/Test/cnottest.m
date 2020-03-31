tic;
C=CNOT_ij(12,13,15);
rho=rand(2^15,2^15);
p=C*rho*C;
toc

%%
tic;
rho=rand(2^15,2^15);
toc

%% 
tic;
%C=kCNOT([11,12],13,15);
C*rho;
toc

%%
tic;
C*C;
toc
%%
R = rand(2^8,2^8);
R = R+R';
[P,H] = hess(R);
H = sparse(H);
C = kCNOT([2,3],4,8);
H_n = C*H*C';
tic;
H_n = C*H*C';
toc
had = kCHad(2,3,8);


%%
R = rand(2^13,2^13);
[C,p] = kCNOT([2,3],4,13);
tic;
C*R*C';
toc

tic;
permute(R,p);
toc