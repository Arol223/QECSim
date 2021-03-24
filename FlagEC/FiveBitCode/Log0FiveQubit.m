function [rho, psi] = Log0FiveQubit()
%LOG0FIVEQUBIT Summary of this function goes here
%   Detailed explanation goes here
tmp_pos = [0 0 0 0 0;
    1 0 0 1 0;
    0 1 0 0 1;
    1 0 1 0 0;
    0 1 0 1 0;
    0 0 1 0 1];
tmp_neg = [1 1 0 1 1;
    0 0 1 1 0;
    1 1 0 0 0;
    1 1 1 0 1;
    0 0 0 1 1;
    1 1 1 1 0;
    0 1 1 1 1;
    1 0 0 0 1;
    0 1 1 0 0;
    1 0 1 1 1];
psi = zeros(2^5,1);
for i = 1:size(tmp_pos,1)
    psi(binvec2dec(tmp_pos(i,:))+1) = 1;
end
for i  = 1:size(tmp_neg,1)
   psi(binvec2dec(tmp_neg(i,:))+1) = -1; 
end
psi = sparse(psi./norm(psi));
rho = psi*psi';
end



