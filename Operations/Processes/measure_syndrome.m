function [ rho_tot, p_tot ] = measure_syndrome(nbitstate,block,CSSCode,...
    type,syndrome,e_init,e_readout,had,cnot,cz)
%MEASURE_SYNDROME gets the probability of and resulting state from
%measuring e.g. syndrome '111' in steane code. 
%   To be able to correctly simulate error correction in a CSS code we need
%   to check all different measurement outcomes of the generators, and
%   because of fault tolerance each measurement is a majority vote.
%   Therefore, to simulate measuring e.g. '111' in the steane code we need
%   to sum 27 alternative ways to get that outcome. This function does
%   exactly that for a given syndrome. 
%   ---inputs---
%   nbitstate - state to measure on
%   block - which block of physical bits to measure on in a set of several
%   logical bits.
%   CSSCode - the CSS code used for encoding.
%   type - either 'Z' or 'X'. Determines whether to use the Z- or
%   X-generators for the measurement
%   Syndrome - the desired error syndrome, e.g. .'111' in steane code. 
%   e_init, e_readout - initialisation and readout error rates.
%   had, cnot, cz - the gates required for the operations. 
rho_tot = NbitState(zeros(2^nbitstate.nbits));
p_tot = 0;

if nargin < 10
    if strcmp(type, 'Z')
        error('CZ-gate input required to measure Z-generators')
    else
        cz = 0;
    end
end
s1 = syndrome(1);
s2 = syndrome(2);
s3 = syndrome(3);
for i = 1:3
    [tmp1, p1] = FT_CSSgen_measurement(nbitstate,block,CSSCode,type,1,s1,...
        i,e_init,e_readout,had,cnot,cz);
    for j = 1:3
        [tmp2, p2] = FT_CSSgen_measurement(tmp1,block,CSSCode,type,2,s2,...
            j,e_init,e_readout,had,cnot,cz);
        for k = 1:3
            [tmp3, p3] = FT_CSSgen_measurement(tmp2,block,CSSCode,type,3,s3,...
                k,e_init,e_readout,had,cnot,cz);
            rho_tot = rho_tot+tmp3;
            p_tot = p_tot+p1*p2*p3;
        end
    end
end


end

