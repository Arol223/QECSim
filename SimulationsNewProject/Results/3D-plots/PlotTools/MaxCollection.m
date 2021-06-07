function [mv] = MaxCollection(varargin)
%MAXCOLLECTION Find max value of collection of matrices
n = length(varargin);
mtmp = zeros(n,1);

for i = 1:n
   mtmp(i) = max(max(varargin{i})); 
end

mv = max(mtmp);
end

