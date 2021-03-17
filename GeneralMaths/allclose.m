function [res] = allclose(a,b,atol,rtol)
%ALLCLOSE return true if the absolute difference between a and b is within the tolerance 
%   Detailed explanation goes here
if nargin<4
    rtol = 1e-5;
end
if nargin <3
    atol = 1e-8;
end

res = all( abs(a(:)-b(:)) <= atol+rtol*abs(b(:)) );
end

