function [ rho, p_i ] = projective_measurement( nbitstate, target, val,...
    output_state)
%PROJECTIVE_MEASUREMENT Measures the val component of qubit specified in target. 
%   Returns measurement result and corrseponding probability. Set output to
%   'NbitState' to get the result as an instance of NbitState

if isa(nbitstate, 'NbitState')
    rho = nbitstate.rho;
    nbits = nbitstate.nbits;
elseif ismatrix(nbitstate)
    rho = nbitstate;
    nbits = log2(size(rho,1));
end
%p_i = measure_prob(rho, target, val, nbits);
if val == 0
    proj = [1 0];
elseif val == 1
    proj = [0 1];
end
proj = proj'*proj;

s1 = target - 1; % # bits 'to the left' of target.
s2 = nbits - target; % # bits 'to the right' of target.

% Building the full projection matrix.
if s1 == 0
    proj = kron(proj,speye(2^s2));
    
elseif s2 == 0
    proj = kron(speye(2^s1),proj);
   
else
    proj = tensor_product({eye(2^s1),proj,eye(2^s2)});
    
end

rho = proj*rho*proj';

p_i = trace(rho);
if p_i
    rho = rho./p_i;
end

if output_state
    rho = NbitState(rho);
end

end

