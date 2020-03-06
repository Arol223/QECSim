% Takes a binary vector representation of a state and returns the vector
% representation of the state
function vec = state_to_vector(bin)
    weight = length(bin);
    dim = 2^weight;
    vec = zeros(dim,1);
    num = 1;
    for i  = 0:weight-1
        if bin(i+1)==1
            num = num+2^i;
        end
    end
    vec(num) = 1;
end