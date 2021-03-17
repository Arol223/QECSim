function [op] = DampEl(type, element, target, tot_bits, damp_coeff)
%PHASEDAMPEL Build element for amplitude or phase damping channel
%   Type - 'P' or 'A'
if type == 'P'
    
    if element == 1
        el = [1 0; 0 sqrt(1-damp_coeff)];
    elseif element == 2
        el = [0 0; 0 sqrt(damp_coeff)];
    end
    
elseif type == 'A'
    
    if element == 1
        el = [1 0; 0 sqrt(1-damp_coeff)];
    elseif element == 2
        el = [0 sqrt(damp_coeff);0 0];
    end
end

pre_op = zeros(2,2,tot_bits);
for i = 1:tot_bits
    if ismember(i,target)
        pre_op(:,:,i) = el;
    else
        pre_op(:,:,i) = eye(2);
    end
end
op = tensor_product(pre_op);

end



