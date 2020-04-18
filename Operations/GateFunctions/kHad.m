function had = kHad(targets, nbits)
%KHAD Hadamardgate on k bits
%   Hadamard gate matrix acting on bits targets of an nbits system 
    had = speye(2^nbits);
    for i = 1:length(targets)
       had = had * H_i(targets(i),nbits); 
    end

end

