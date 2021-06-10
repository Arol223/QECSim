classdef FiveQubitCode
    %FIVEQUBITCODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        stabilisers = ['XZZXI';...
            'IXZZX';...
            'XIXZZ';...
            'ZXIXZ'];
        
        minimal_corrections = ['0 0';'1 0';'0 3';'5 0';'0 5';'0 2';...
            '4 0'; '5 5'; '2 0'; '0 4'; '0 1';'1 1';'3 0';'2 2';'3 3';'4 4'];
        
        flag_errors = ['IIZXI, IXZXI, IYZXI, IZZXI, IIIXI, IIXXI, IIYXI';...
            'IIIIX, IXXII, IIIXX, XIIIY, IXIII, IIIZX, IIIYX';...
            'IIIZZ, IIXZZ, IIYZZ, IIZZZ, IIIIZ, IIIXZ, IIIYZ';...
            'IIIXZ, IXIXZ, IYIXZ, IZIXZ, IIIIZ, IIIYZ, IIIZZ'];
        
        X_L = 'XXXXX';
        Z_L = 'ZZZZZ';
        
    end
    
    methods
        function obj = FiveQubitCode()
            
        end
        
        
    end
end

