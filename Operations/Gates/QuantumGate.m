classdef QuantumGate<handle
    
    properties (Abstract)
        % Fidelity is self-evident. Controlled should be true if it's a
        % controlled gate, false otherwise. Operation_time can be used to
        % calculate decoherence and amplitude damping for bits left out of
        % the operation. target errors and control errors are the errors
        % affecting the target and control bits respectively. error_weights
        % say how strong each error should be. 
        controlled;
        fidelity;
        operation_time;
        target_errors;
        control_errors;
        p_eij;
    end
    
    methods (Abstract)
        res = pure_operation(obj, nbitstate, targets, controls)
        res = apply_errors(obj, nbitstate, targets, controls)
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
            
            
            rho_exact = obj.pure_operation(nbitstate, targets, controls);
            spy(rho_exact)
            rho_error = obj.apply_errors(nbitstate, targets, controls);
            spy(rho_error)
            rho = rho_exact+rho_error;
            spy(rho)
        end
        
    end
    
    
end