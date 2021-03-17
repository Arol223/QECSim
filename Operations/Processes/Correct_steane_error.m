function  [rho_n,p]  = Correct_steane_error( nbitstate,block...
    ,type,e_init,e_readout,had_gate,CNot,corr_gate,CZ )
%CORRECT_STEANE_ERROR Run a bit or phase flip EC cycle using the steane
%code
%   Runs an error correction cycle for either bit or phase flip using the
%   Steane generator structure, i.e. 6 generators where 3 correct for phase
%   flips and 3 correct for bit flips. There are eight different outcomes
%   when trying to error correct, each giving a separate syndrome. This
%   adds all the outcomes and returns the total state after correction. 
%   Follows circuit in 'Error Correction for Beginners' by Devitt S. et al.
Steanecode = SteaneCode();
if nargin <9
   if strcmp(type, 'X')
       if ~isa(corr_gate, 'ZGate')
           error('Need a Z-gate for correcting phase flips')
       end
       CZ = 0;
   else
       error('Cannot use Z EC without a CZ gate')
   end
end
rho = NbitState.empty(8,0);
p = zeros(8,1);

for i = 1:8
    syndrome = get_syndrome(i);
    [r_tmp, p_tmp] = measure_syndrome(nbitstate,block,Steanecode,type,...
        syndrome,e_init,e_readout,had_gate, CNot,CZ);
    ind = 4*syndrome(1) + syndrome(2) + 2*syndrome(3);
    if ind
        r_tmp = corr_gate.apply(r_tmp, ind+(block-1)*7); % EC operation
    end
    if ~ind &&  corr_gate.tol
        r_tmp.rho = r_tmp.rho.*(abs(r_tmp.rho)>corr_gate.tol);
    end
    p(i) = p_tmp;
    rho(i) = r_tmp;
%    figure(i)
%    spy(r_tmp)
end
rho_n = zeros(size(nbitstate));

for i = 1:8
rho_n = rho_n + p(i).*rho(i).rho;
end
rho_n = sparse(rho_n);
rho_n = NbitState(rho_n);
rho_n.copy_params(nbitstate)
% figure(9)
% spy(rho_tot)
end

