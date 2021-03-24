function [rho_out, p_out, broke] = MeasureSyndrome(rho_in, block, syndrome,...
    flagged, flag_loc, cnot, had)
%MEASURESYNDROME Summary of this function goes here
%   Detailed explanation goes here
rho_out = NbitState(rho_in.rho);
rho_out.copy_params(rho_in);
p_out = 1;
broke = 0;
for i = 1:4
    stab_val = syndrome(i);
    [rho_out, p_tmp] = MeasureStabiliser(rho_out,block,cnot,had, i,stab_val,...
        flagged,flag_loc==i);
    p_out = p_out*p_tmp;
    if (stab_val&&flagged) || flag_loc == i
        broke = 1;
        return
    end
end

end

