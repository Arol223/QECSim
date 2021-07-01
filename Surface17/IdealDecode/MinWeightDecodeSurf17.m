function [rho_out] = MinWeightDecodeSurf17(rho_in)
%MINWEIGHTDECODE Perform minimum weight decoding of a surface+17 round of
%EC
%   Detailed explanation goes here
cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
z = ZGate(0,0);

rho_out = zeros(size(rho_in));
rho_int = rho_out; %Intermediate
for i = 0:15
    syn = dec2binvec(i,4);
    corr = MinWeightMatch('X',syn);
    [rtmp, ptmp] = MeasureSyndrome(rho_in,syn,'X',cnot,had);
    if ~isempty(corr)
        rtmp = z.apply(rtmp,corr);
    end
    rho_int = rho_int + ptmp*rtmp.rho;
end
rho_out = NbitState(rho_int);
for i = 0:15
    syn = dec2binvec(i,4);
    corr = MinWeightMatch('Z',syn);
    [rtmp, ptmp] = MeasureSyndrome(rho_int,syn,'Z',cnot,had);
    if ~isempty(corr)
        rtmp = x.apply(rtmp,corr);
    end
    rho_out = rho_out + ptmp*rtmp.rho;
end
rho_out = NbitState(rho_out);
end

