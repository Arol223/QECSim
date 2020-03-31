function p = not_permutation_ji(control_weight, p)
target_weight = length(p)/2;
for i=control_weight:target_weight-control_weight
    temp=p(i);
    p(i)=p(i+target_weight);
    p(i+target_weight)=temp;
end
end