function [binvec] = dec2binvec(dec, len)
%DEC2BINVEC Transform decimal number into binary vector of length len
%   Transform decimal number into binary vector, e.g. 7 -> [1 1 1]
if nargin < 2
    len = 0;
end
tmp  = dec2bin(dec,len);
l = length(tmp);
binvec = zeros(0, l);
for i  = 1:l
    binvec(i) = str2double(tmp(i));
end

end

