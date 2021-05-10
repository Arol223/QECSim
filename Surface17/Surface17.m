classdef Surface17
    %SURFACE17 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        Xstabilisers = [0 1 1 0 0 0 0 0 0;
            1 1 0 1 1 0 0 0 0;            
            0 0 0 0 1 1 0 1 1;
            0 0 0 0 0 0 1 1 0];
        
        Zstabilisers = [1 0 0 1 0 0 0 0 0;
            0 0 0 1 1 0 1 1 0;
            0 1 1 0 1 1 0 0 0;
            0 0 0 0 0 1 0 0 1];
        
        LogX = [0 0 1 0 1 0 1 0 0];
        LogZ = [1 0 0 0 1 0 0 0 1];
    end
    
    methods
        function obj = Surface17()
           
        end
    end
end

