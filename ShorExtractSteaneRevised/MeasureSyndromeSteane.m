function [rho_out,p_out] = MeasureSyndromeSteane(rho_in, block, syndrome,...
    type, cnot, cz, had)
%MEASURESYNDROME Summary of this function goes here
%   Detailed explanation goes here
votes = 1:6; % 000 ~ 001 ->00, same for 110 & 111

count = 1;
p_out = 0;
rtot = cell(3^3,1); % in each stabiliser measurement 3 alternatives give 1 resp 0

for i = votes
    syn1 = dec2binvec(i,3);
    val_1 = ~mod(sum(syn1),2);
    
    if val_1 ~= syndrome(1)
        continue
    else
        [rtmp1, ptmp1] = MajVoteMeasurement(rho_in,block,type,1,syn1,cnot,cz,had);
    end
    if ptmp1
        for j = votes
            syn2 = dec2binvec(j,3);
            val_2 = ~mod(sum(syn2),2);
            
            if val_2 ~= syndrome(2)
                continue
            else
                [rtmp2, ptmp2] = MajVoteMeasurement(rtmp1,block,type,2,syn2...
                    ,cnot,cz,had);
            end
            
            if ptmp2
                for k = votes
                    syn3 = dec2binvec(k,3);
                    val_3 = ~mod(sum(syn3),2);
                    if val_3 ~= syndrome(3)
                        continue
                    else
                        [rtmp3, ptmp3] = MajVoteMeasurement(rtmp2,block,type,3,...
                            syn3 ,cnot,cz,had);
                        p = ptmp1*ptmp2*ptmp3;
                        p_out = p_out + p;
                        [I,J,V] = find(rtmp3.rho);
                        rtot{count} = [I,J,p*V];
                        count = count + 1;
                    end
                    
                    
                end
            end
        end
    end
end

n = size(rho_in);
IJV = cell2mat(rtot);

if ~isempty(IJV)
    rho_out = NbitState(sparse(IJV(:,1),IJV(:,2),IJV(:,3),n,n));
else
    rho_out = NbitState(rho_in.rho);
end
rho_out.copy_params(rho_in);

end


