classdef HadamardGate < SingleBitGate
    %HADAMARDGATE Hadamard gate with errors
    %   Detailed explanation goes here
    
    properties
        op_mat = [1 1; 1 -1]./sqrt(2);
    end
   
    methods
        function obj = HadamardGate(tol,operation_time, varargin)
                obj@SingleBitGate(tol,operation_time,varargin{:});
        end


    end
end

