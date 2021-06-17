function [t_tot, cat] = BuildCatState(cnot, had, e_init,...
    t_init, e_ro, t_ro,sym)
%BUILDCATSTATE Summary of this function goes here
%   Detailed explanation goes here

nbits = 4;
cat = NbitState();
cat.init_all_zeros(nbits + 1, e_init);
cat = had.apply(cat,2);
cat = cnot.apply(cat,3,2);
cat = cnot.apply(cat,1,2);
cat = cnot.apply(cat,4,3);
cat = cnot.apply(cat,5,4);
cat = cnot.apply(cat,1,5);
cat = measurement_e(cat,1,0,e_ro,1,sym);
cat.trace_out_bits(1)

t_tot = 5*cnot.operation_time + 5*t_init + had.operation_time + t_ro;
end

