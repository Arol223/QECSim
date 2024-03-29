classdef CZGate < TwoBitGate
    %CZGATE A controlled Pauli-Z gate
    %   Detailed explanation goes here
    
    properties
       kCZ = memoize(@kCZ)
    end
    
    methods
        
        function obj = CZGate(varargin)
            obj@TwoBitGate(varargin{:})
            obj.kCZ.CacheSize = 5000;
        end
        
        function op  = get_op_el(obj, nbits, target, control)
            op = obj.kCZ(control, target, nbits);
        end
        
    end
    
end

