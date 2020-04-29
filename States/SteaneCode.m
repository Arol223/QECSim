classdef SteaneCode < CSSCode
    %STEANECODE Specifies the properties of the 7 qubit Steane CSS code
    %   Detailed explanation goes here
    
    properties
        XStabilisers = ['IIIXXXX';'XIXIXIX';'IXXIIXX'];
        ZStabilisers = ['IIIZZZZ';'ZIZIZIZ';'IZZIIZZ'];
        nbits = 7;
        encoded_bits = 1;
        n_generators = 6;
        logical_X = 'XXXXXXX';
        logical_Z = 'ZZZZZZZ';
        logical_Y = 'YYYYYYY';
        logical_H = 'HHHHHHH';
    end
    
    methods
        
        function obj = SteaneCode()
        
        end
        
        
    end
    
end

