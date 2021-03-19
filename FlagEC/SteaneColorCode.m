classdef SteaneColorCode 
    %SteneColorCode Provides a specification of the 7-qubit Steane color code
    %   Provides a specification of the 7 qubit steane color code as well
    %   as utility functions for simulating syndrome measurement etc. The
    %   stabilisers are specified by naming the qubits on which they have
    %   support. Note that the stabilisers are given in the right
    %   permutation for getting distinct flag error syndromes.
    %   Because the Steane code is a CSS code, the support of the
    %   X- and Z- type stabilisers is identical, and correcting Z and X
    %   errors disjoint. 
    
    properties (Constant)
        stabilisers = [1 2 3 4; 5 6 3 2 ; 7 4 3 6]
        
        flag_syndromes = ['1  0  0,1  0  1,0  1  0';...
                          '0  1  0,1  1  0,0  0  1';...
                          '0  0  1,0  1  1,1  0  0'];
                      
        flag_error_set = ['1, 4, 3 4';
                          '5, 2, 2 3';
                          '7, 6, 3 6'];
                      
        minimal_corrections = [0 7 5 6 1 4 2 3]; 
        % Read as appropriate Pauli correction on given qubit
    end
    
    methods
        function obj = SteaneColorCode()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        
    end
end

