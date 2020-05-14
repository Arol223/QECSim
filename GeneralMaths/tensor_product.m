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
           mat = mats(:,:,i);
           if nnz(mat) <= size(mat,1)*size(mat,2)/2
               mat = sparse(mat);
           end
           tp = kron(tp, mat); 
        end
    end
end