function res = get_syndrome( i )
%GET_SYNDROME Helper to convert an int to a binary error syndrome for the
%steane code. 
%   There are eight different error syndromes for the Steane code, namely
%   [000],[001],...[111]. This function converts an integer i to a the
%   corresponding error syndrome, setting the syndrome as the binary
%   representation of i. 

switch i
    case 1
       res = [0 0 0];
    case 2
        res = [0 0 1];
    case 3
        res = [0 1 0];
    case 4 
        res = [0 1 1];
    case 5
        res = [1 0 0];
    case 6
        res = [1 0 1];
    case 7 
        res = [1 1 0];
    case 8
        res = [1 1 1];
end
end

