classdef CNOTGate < TwoBitGate
    %CNOTGATE A CNOT gate model including uncorrelated errors
    %   Detailed explanation goes here
    
    properties
        kCNOT = memoize(@kCNOT);
    end
    
    methods
        
        function obj = CNOTGate(error_probs,tol, operation_time,varargin)
            obj@TwoBitGate(error_probs,tol, operation_time, varargin{:})
            obj.kCNOT.CacheSize = 5000;
        end
        
        function op = get_op_el(obj, nbits, target, control)
            op = obj.kCNOT(control,target,nbits);
        end
        
    end
    
end

