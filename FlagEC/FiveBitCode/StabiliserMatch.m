function [match] = StabiliserMatch(gen_op,err)
%STABILISERMATCH 
%   Detailed explanation goes here
    switch gen_op
        
        case 'X'
            if err == 'Z'
                match = 1;
            elseif err == 'Y'
                match = 1;
            else
                match = 0;
            end
        case 'Z'
            if err == 'X'
                match = 1;
            elseif err == 'Y'
                match = 1;
            else
                match = 0;
            end
        case 'I'
            match = 0;
    end
end

