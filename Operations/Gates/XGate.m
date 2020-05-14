classdef XGate < SingleBitGate
    
    properties
        op_mat = sparse([0 1;1 0]);
    end
    
    methods
        function obj = XGate(tol,operation_time,varargin)
            obj@SingleBitGate(tol,operation_time,varargin{:})
        end
    end
    
end