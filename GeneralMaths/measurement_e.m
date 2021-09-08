function [rho, p_out] = measurement_e( nbitstate, target, val, e_readout,...
    output_state, sym)
%MEASUREMENT_E Performs a projective measurement with readout error.
%Returns resulting state rho and corresponding probability p
%   Works the same way as function projective_measurement, but adds a
%   component of the wrong result to account for readout error so e.g.
%   rho_0 = (1-e_readout)*rho_0 + e_readout*rho_1.
%   Sym argument determines if the readout error is symmetric or not. 
%   sym = 0 gives the asymmetric case, where there's a chance a 1 will be
%   read as a 0 but not the other way around. If sym = 1 a 1 can be read as
%   0 and 0 can be read as 1.


[rho, p] = projective_measurement(nbitstate, target, val, 0); % rho returned as matrix
%sym = 0;

if e_readout 
%     x = XGate();
%     y = YGate();
%     z = ZGate();
    [rho_e, ~] = projective_measurement(nbitstate, target, mod(val+1,2), 0);
    if sym
         rho = (1-e_readout)*p*rho + e_readout*(1-p)*rho_e;
         p_out = (1-e_readout)*p + e_readout*(1-p);
%          p_err = e_readout/3;
%          p_out = p;
%          rho = rho + p_err*(x.apply(rho,target)+y.apply(rho,target)+z.apply(rho,target)); 
    elseif val == 0
        rho = p*rho + e_readout*(1-p)*rho_e;
        p_out = p + e_readout*(1-p);
%         p_err = e_readout/3;
%         rho = rho + p_err*(x.apply(rho,target)+y.apply(rho,target)+z.apply(rho,target)); 
    elseif val == 1
        p_out = (1-e_readout)*p;
    end
else
    p_out = p;
end

if p_out
    rho = rho./p_out;
end
if (isa(nbitstate, "NbitState") && nbitstate.t_ro)
    % Idle non-measured bits unless measurement time of state is 0
    sym = nbitstate.sym_ro;
    T2_hf = nbitstate.T_2_hf;
    t_ro = nbitstate.t_ro;
    c_phase = DampCoeff(t_ro,T2_hf);
    idles = 1:nbitstate.nbits;
    idles = [idles(1:target-1) idles(target+1:end)];
    rho = idle_bits(rho,idles,0,c_phase);
end


if output_state
    rho = NbitState(rho);
    rho.copy_params(nbitstate);
end

end

