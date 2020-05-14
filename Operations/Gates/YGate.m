classdef YGate < SingleBitGate
    %YGATE A Pauli Y-gate. See parent for more detail
    %   Detailed explanation goes here
    
    properties
        op_mat = sparse([0 -1i;1i 0])
    end
    
    methods
        function obj = YGate(tol,operation_time,varargin)
            %YGATE Construct an instance of this class
            %   Detailed explanation goes here
            obj@SingleBitGate(tol,operation_time,varargin{:})
        end
        
    end
end

