function [op] = OpFromCheck(Check, num)
%OPFROMCHECK Build a representation of an operator from a Check Matrix
%   ---Inputs---
%   Check - The check matrix
%   num   - The row to build from

len = size(Check,2)/2;

G = Check(num,:);
op = char(zeros(1,len));
for i = 1:len
        
    if G(i) && G(i+8)
        op(i) = 'Y';
    elseif G(i)
        op(i) = 'X';
    elseif G(i+8)
        op(i) = 'Z';
    else
        op(i) = 'I';        
    end
    
end
%op = join(op);
%op = join(op,'');
%op = strrep(op,' ','');
end

