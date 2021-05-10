function [rho_out] = LogGate5Qubit(rho_in,type,block,x,y,z)
%LOGGATE5QUBIT Summary of this function goes here
%   Detailed explanation goes here
stab = FiveQubitCode.stabilisers(1,:);
X_l = 'XXXXX';
Z_l = 'ZZZZZ';

if type == 'X'
    opL = PauliProduct(X_l,stab);
elseif type == 'Z'
    opL = PauliProduct(Z_l,stab);
end
rho_out = NbitState(rho_in.rho);
rho_out.copy_params(rho_in);
for i = 1:5
    op = opL(i);
    
    switch op        
        case 'I'
            continue
        case 'X'
            rho_out = x.apply(rho_out,i+(block-1)*5);
        case 'Y'
            rho_out = y.apply(rho_out,i+(block-1)*5);
        case 'Z'
            rho_out = z.apply(rho_out,i+(block-1)*5);
    end
end

end

