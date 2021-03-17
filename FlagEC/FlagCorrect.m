function [rho_out, p_out] = FlagCorrect(rho_in, block, type, cnot, had, cor_s, cor_f)
%FLAGCORRECT Flag EC with flags raised
%   Simulate the flag error correction protocol for the Steane code as
%   described in [Chamberland2018] with all flags being raised
%
%   -----Inputs-----
%   rho_in - The input state
%   block - The block to error correct if several blocks
%   type - 'Z' or 'X', the type of stabiliser to correct with
%   cnot,had - gate objects used in the circuit
%   cor_s - Gate object used for correcting regular error, i.e. X-gate for Z-type
%             stabiliser and Z-gate for X-type stabiliser
%   cor_f - Gate object used to correct flag error, i.e. Z for Z-stabiliser
%           and X for X-stabiliser
%
%   -----Outputs----
%   rho_out - The output state
%   p_out - The total probability of the given outcome, i.e. error correction
%           with given type stabiliser was performed with a flag being
%           raised at some point in the circuit

p_out = 0;
rho_tot = cell(1800,1);
cell_ind = 1;   % Cell for storing matrices
for i = 1:8 % First syndrome measurement
    
    syn_1 = dec2binvec(i-1,3);
    
    for j = 0:3 % Flag location
        
        [rho_1, p_1] = FlagSyndromeMeasurement(rho_in, syn_1,...
            block, type,1,j,cnot,had); % flag is raised when measuring stabiliser j
        
        if ~j && p_1 % No flag raised in 1st syndrome measurement and probability not 0
            
            for k = 1:8 % Second syndrome measurement
                
                syn_2 = dec2binvec(k-1,3);
                
                for l = 1:3  % Flag can happen in 3 places (1st 2nd or 3d stabiliser measurement)
                    
                    [rho_2, p_2] = FlagSyndromeMeasurement(rho_1, syn_2,...
                        block, type,1,l,cnot,had);
                    if p_2
                        for n = 1:8  % measure the syndrome with non flag circuit
                            
                            syn_3 = dec2binvec(n-1,3);
                            [rho_3, p_3] = FlagSyndromeMeasurement(rho_2, syn_3,...
                                block, type,0,0,cnot,had);
                            if p_3
                            p_tot = p_1*p_2*p_3;
                            p_out = p_out + p_tot;
                            
                            flag_syndromes = SteaneColorCode.flag_syndromes(l,:);
                            flag_syndromes = split(flag_syndromes,', ');
                            flag_errors = SteaneColorCode.flag_error_set(l,:);
                            flag_errors = split(flag_errors,', ');
                            
                            [isflag, fl_ind] = ismember(num2str(syn_3),flag_syndromes);
                            if isflag
                                corr_ind = str2double(flag_errors{fl_ind});
                                rho_3 = cor_f.apply(rho_3, corr_ind);
                            else
                                err = SteaneColorCode.minimal_corrections(n);
                                if err ~= 0
                                    rho_3 = cor_s.apply(rho_3, err);
                                end
                            end
                            [I,J,V] = find(rho_3.rho);
                            rho_tot{cell_ind} = [I,J,p_tot*V];
                            cell_ind = cell_ind + 1;
                            end
                        end
                    end
                end
            end
            
        elseif p_1 % Flag at some point in first measurement
            
            for k = 1:8
                syn_2 = dec2binvec(k-1,3);
                [rho_2,p_2] = FlagSyndromeMeasurement(rho_1, syn_2,...
                    block,type,0,0,cnot,had);
                p_tot = p_1*p_2;
                p_out = p_out + p_tot;
                flag_syndromes = SteaneColorCode.flag_syndromes(j,:);
                flag_syndromes = split(flag_syndromes,', ');
                flag_errors = SteaneColorCode.flag_error_set(j,:);
                flag_errors = split(flag_errors,', ');
                
                [isflag, fl_ind] = ismember(num2str(syn_2),flag_syndromes);
                
                if isflag
                    corr_ind = str2double(flag_errors{fl_ind});
                    rho_2 = cor_f.apply(rho_2, corr_ind);
                else
                    err = SteaneColorCode.minimal_corrections(k);
                    if err 
                        rho_2 = cor_s.apply(rho_3, err);
                    end
                end
                [I,J,V] = find(rho_2.rho);
                rho_tot{cell_ind} = [I,J,p_tot*V];
                cell_ind = cell_ind + 1;
            end
            
            
        end
    end
    
end

n = size(rho_in);
IJV = cell2mat(rho_tot);
if ~isempty(IJV)
rho_out = NbitState(sparse(IJV(:,1),IJV(:,2),IJV(:,3),n,n));
else
   rho_out = NbitState(rho_in.rho); 
end
rho_out.copy_params(rho_in);

end

