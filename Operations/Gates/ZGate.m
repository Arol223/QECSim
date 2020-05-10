classdef ZGate < SingleBitGate
    %ZGATE A Pauli Z-gate with errors
    %   Detailed explanation goes here
    
    properties
        op_mat = sparse([1 0; 0 -1])
    end
    
    methods
        function obj = ZGate(error_probs,tol,operation_time,varargin)
            obj@SingleBitGate(error_probs,tol,operation_time,varargin{:})
        end
    end
end

