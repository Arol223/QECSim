function p = not_permutation_ij(target_weight, indices)
p=indices;
n_rows = 2*target_weight;
for i = 1:n_rows:length(p)
    for j = 0:n_rows/2-1
        temp=p(i+j);
        p(i+j)=p(i+j+target_weight);
        p(i+j+target_weight) = temp;
    end 
end
end