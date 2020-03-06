% Builds the tensor product of variable number of matrices
function tp = tensor_product(mats)
    if iscell(mats)
    tp = cell2mat(mats(1));
    for i = 2:length(mats)
        tp = kron(tp,cell2mat(mats(i)));
    end
    elseif ismatrix(mats(:,:,1))
        tp = mats(:,:,1);
        for i = 2:size(mats,3)
           tp = kron(tp, mats(:,:,i)); 
        end
    end
end