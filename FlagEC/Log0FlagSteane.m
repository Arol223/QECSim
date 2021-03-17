function [rho, psi] = Log0FlagSteane()
%LOG0FLAGSTEANE Return logical zero matrix and vector of flag Steane
%   Detailed explanation goes here

support = SteaneColorCode.stabilisers;

s1 = sort(support(1,:));
s2 = sort(support(2,:));
s3 = sort(support(3,:));

s1vec = zeros(7,1);
s2vec = zeros(7,1);
s3vec = zeros(7,1);

for i = 1:7
    if ismember(i,s1)
        s1vec(i) = 1;
    end
    if ismember(i,s2)
        s2vec(i) = 1;
    end
    if ismember(i,s3)
        s3vec(i) = 1;
    end
end

w = zeros(8,7); % codewords

w(2,:) = s1vec;
w(3,:) = s2vec;
w(4,:) = s3vec;
w(5,:) = mod(s1vec+s2vec,2);
w(6,:) = mod(s1vec+s3vec,2);
w(7,:) = mod(s2vec+s3vec,2);
w(8,:) = mod(s1vec+s2vec+s3vec,2);
psi = zeros(2^7,1);

for i = 1:8
   ind = binvec2dec(w(i,:)) + 1;
   psi(ind) = 1;
end
psi = sparse(psi./norm(psi));
rho = psi*psi';
end
