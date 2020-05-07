function b = remove_dupes(a,b)
%REMOVE_DUPES Removes elements from vector b that are in vector a.
%   Detailed explanation goes here
for i = 1:length(a)
    indx = b==a(i);
    b(indx) = []; 
end

