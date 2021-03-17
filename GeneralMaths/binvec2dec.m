function [dec] = binvec2dec(binvec)
%BINVEC2DEC Converts a binary vector into decimal number
%   Detailed explanation goes here

len = length(binvec)-1;
dec = 0;
for i = len:-1:0
    dec = dec + binvec(i+1)*2^(len-i);
end

