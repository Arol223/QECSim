classdef XGate < SingleBitGate
    
    properties
        op_mat = sparse([0 1;1 0]);
    end
    
    methods
        function obj = XGate(varargin)
            obj@SingleBitGate(varargin{:})
        end
    end
    
end