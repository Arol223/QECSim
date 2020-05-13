function [rho] = SteaneLogicalGate(rho,gate, trgt_blk)
%STEANELOGICALGATE Summary of this function goes here
%   Detailed explanation goes here
targets = 1:7 + (trgt_blk-1)*7; % shift targets to target right logical bit. 
rho = gate.apply(rho,targets);
end

