% Builds the tensor product of variable number of matrices
function tp = tensor_product(mats)
    tp = cell2mat(mats(1));
    for i = 2:length(mats)
        tp = kron(tp,cell2mat(mats(i)));
    end
end