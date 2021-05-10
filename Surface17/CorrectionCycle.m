function [rho_out, p_out] = CorrectionCycle(rho_in, type, cnot, had, xgate, zgate,tol)
%CORRECTIONCYCLE Simulate a correction cycle for one error type with
%surface17
%       ---Inputs---
%   rho_in  - Input state
%   type    - X or Z type stabilisers
%   cnot    - Cnot gate object
%   had     - Hadamard gate object
%   xgate   - xgate object, used for correction
%   zgate   - zgate object, -||-
%   tol     - tolerance for filtering results that won't have an effect on
%             the result.
p_out = 0;
ms = memoize(@MeasureSyndrome);
ms.CacheSize = 1000;
rho_tot = cell(2^12,1);
for i = 1:2^12
   syn = dec2binvec(i-1,12);
   syn_vol = zeros(2,2,3);
   syn_vol(:,:,1) = reshape(syn(1:4),2,2)';
   syn_vol(:,:,2) = reshape(syn(5:8),2,2)';
   syn_vol(:,:,3) = reshape(syn(9:12),2,2)';
   
   
   [rtmp,ptmp,ms] = MeasureSynVol(rho_in,syn_vol,type,cnot,had,tol,ms);
   if ~ptmp
       continue
   end
   p_out = p_out + ptmp;
   corr_op = MinimalCorrection(syn_vol,type);
   corr_inds = find(corr_op~='I');
   if type == 'X' && ~isempty(corr_inds)
       rtmp = zgate.apply(rtmp, corr_inds);
   elseif type == 'Z' && ~isempty(corr_inds)
       rtmp = xgate.apply(rtmp, corr_inds);
   end
   
   [I,J,V] = find(rtmp.rho);
   rho_tot{i} = [I,J,ptmp*V];
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

