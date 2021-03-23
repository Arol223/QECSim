function [rho_out, p_out] = NoFlagCorrect(rho_in, block, type, cnot, had, cor)
%NOFLAGCORRECT Flag EC with no raised flags
%   Simulate the flag error correction protocol for the Steane code as
%   described in [Chamberland2018] with no flags raised at any point.
%
%   -----Inputs-----
%   rho_in - The input state
%   block - The block to error correct if several blocks
%   type - 'Z' or 'X', the type of stabiliser to correct with
%   cnot,had - gate objects used in the circuit
%   cor     - Gate object used for correcting error, i.e. X-gate for Z-type
%             stabiliser and Z-gate for X-type stabiliser
%
%   -----Outputs----
%   rho_out - The output state
%   p_out - The total probability of the given outcome, i.e. error correction
%           with given type stabiliser was performed without any flags
%           being raised

p_out = 0;
rho_tot = cell(8*8*8,1);
ind = 1; % counting which cell index to add matrix to
for i  = 1:8
    syn_1 = dec2binvec(i-1,3);
    [temp1,pt_1] = FlagSyndromeMeasurement(rho_in, syn_1, block,type,1,0,cnot,had);
    if pt_1
        for j = 1:8
            syn_2 = dec2binvec(j-1,3);
            [temp2, pt_2] = FlagSyndromeMeasurement(temp1, syn_2, block,type,1,0,cnot,had);
            if syn_2 == syn_1
                err = SteaneColorCode.minimal_corrections(j);
                if err ~=0
                    temp2 = cor.apply(temp2,err);
                end
                p = pt_1*pt_2;
                [I,J,V] = find(temp2.rho);
                rho_tot{ind} = [I,J,p*V];
                ind = ind + 1;
                p_out = p_out + p;
            elseif pt_2 
                for k = 1:8
                    syn_3 = dec2binvec(k-1,3);
                    [temp3, pt_3] = FlagSyndromeMeasurement(temp2,syn_3,block,type,0,0,cnot,had);
                    err = SteaneColorCode.minimal_corrections(k);
                    if err ~= 0
                        temp3 = cor.apply(temp3,err);
                    end
                    p = pt_1*pt_2*pt_3;
                    [I,J,V] = find(temp3.rho);
                    rho_tot{ind} = [I,J,p*V];
                    ind = ind + 1;
                    p_out = p_out + p;
                end
            end
        end
    end
end
n = size(rho_in);
IJV = cell2mat(rho_tot);
rho_out = NbitState(sparse(IJV(:,1),IJV(:,2),IJV(:,3),n,n));
rho_out.copy_params(rho_in);
end

