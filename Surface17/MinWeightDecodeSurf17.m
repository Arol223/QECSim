function [rho_out] = MinWeightDecodeSurf17(rho_in)
%MINWEIGHTDECODE Perform minimum weight decoding of a surface+17 round of
%EC
%   Detailed explanation goes here
cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
z = ZGate(0,0);

for i = 0:31
    syn = dec2
    [rtmp, ptmp] = MeasureSyndrome(
end

for i = 0:31
    
end
end

