classdef QuantumGate<handle
    
    properties 
       controlled;
    end
    
    properties (Abstract)
        % Pure op is e.g. a perfect CNOT, while real is what would happen
        % in reality. Reak op would thus depend on the specific system
        % modelled etc.
        pure_op;
        target_errors;
        control_errors;
    end
    
    methods
        
        function obj = QuantumGate()    
        end
        
        function rho = apply(obj, nbitstate, targets, controls)
            % Applies the gate to a matrix or an NbitState. if real is true
            % it applies the 'real' gate, i.e. an imperfect one, else it
            % applies a pure gate. Default is to apply a pure gate. The
            % real op should be specified as an instance of
            % QuantumOperation.
            if ~(isa(nbitstate,'NbitState')||ismatrix(nbitstate))
                error('Gate can only be applied to a density matrix or an NbitState')
            end
            if (nargin <4 && obj.controlled)
                error('Specify control bits for controlled gate')
            end
            
            
            
        end
        
    end
    
    
end