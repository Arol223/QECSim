classdef YGate < SingleBitGate
    %YGATE A Pauli Y-gate. See parent for more detail
    %   Detailed explanation goes here
    
    properties
        op_mat = sparse([0 -1i;1i 0])
    end
    
    methods
        function obj = YGate(varargin)
            %YGATE Construct an instance of this class
            %   Detailed explanation goes here
            obj@SingleBitGate(varargin{:})
        end
        
    end
end

