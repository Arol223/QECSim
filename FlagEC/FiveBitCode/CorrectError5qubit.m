function [rho_out, p_out] = CorrectError5qubit(rho_in, block, cnot, had, zgate,...
    xgate, ygate)
%CORRECTERROR Summary of this function goes here
%   Detailed explanation goes here
rho_tot = cell(900,1);
cell_ind = 1;
p_out = 0;
check_syndromes = [0 1 2 4 8]; % Because protocol stops when stabiliser syndrome is 1 only check 0, 1, 10, 100 etc
for i  = check_syndromes
    syn1 = dec2binvec(i,4);
    
    for j = FlagPos(syn1) %for every flag location
        [rtmp1,ptmp1,broke] = MeasureSyndrome5qubit(rho_in,block,syn1,1,j,cnot,had);
        
        if j && ptmp1
            errors = split(FiveQubitCode.flag_errors(j,:),', ');
            
            for k = 0:15
                syn2 = dec2binvec(k,4);
                [rtmp2,ptmp2,~] = MeasureSyndrome5qubit(rtmp1,block,syn2,0,0,cnot,had);
                
                if ptmp2
                    for l = 1:7
                        if isequal(syn2, SyndromeMatch(j,l))
                            [x_c, y_c, z_c] = MinFlagCorrection(errors{l});
                            if ~isempty(x_c)
                                rtmp2 = xgate.apply(rtmp2,x_c);
                            end
                            if ~isempty(y_c)
                                rtmp2 = ygate.apply(rtmp2,y_c);
                            end
                            if ~isempty(z_c)
                                rtmp2 = zgate.apply(rtmp2,z_c);
                            end
                            continue
                        end
                    end
                    p = ptmp1*ptmp2;
                    p_out = p_out + p;
                    [I,J,V] = find(rtmp2.rho);
                    rho_tot{cell_ind} = [I,J,p*V];
                    cell_ind = cell_ind+1;
                end
            end
        elseif broke && ptmp1
            
            for k = 0:15
                syn2 = dec2binvec(k,4);
                [rtmp2,ptmp2,~] = MeasureSyndrome5qubit(rtmp1,block,syn2,0,0,cnot,had);
                
                if ptmp2
                    err = str2num(FiveQubitCode.minimal_corrections(k+1,:));
                    if err(1) && err(2)
                        rtmp2 = ygate.apply(rtmp2,err(1));
                        
                    elseif err(1)
                        rtmp2 = xgate.apply(rtmp2,err(1));
                    elseif err(2)
                        rtmp2 = zgate.apply(rtmp2, err(2));
                    end
                    p = ptmp1*ptmp2;
                    p_out = p_out + p;
                    [I,J,V] = find(rtmp2.rho);
                    rho_tot{cell_ind} = [I,J,p*V];
                    cell_ind = cell_ind + 1;
                end
            end
            
        elseif ptmp1
            p = ptmp1;
            p_out = p_out + p;
            [I,J,V] = find(rtmp1.rho);
            rho_tot{cell_ind} = [I,J,p*V];
            cell_ind = cell_ind + 1;
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


