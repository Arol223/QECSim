classdef QuantumGate<handle
%QUANTUMGATE Base class for quantum gates including errors.
%   Abstract base class used to construct custom quantum gates. 
%   ------Properties-------
%   Controlled
%   operation_time
%   p_eij - the probabilities for error type i on targets and controll bits
%   p_no_op - the probability that the operation fails, i.e. an I-type
%             error.
%   -----Methods----
%   pure_operation(nbitstate, targets, controls) - performs an operation
%       without errors on targets with controls. 
%   apply_errors(nbitstate, targets, controls) - applies the errors with
%       probabilities from p_eij to specified bits.
%   apply(nbitstate, targets, conrols) - applies the full operation
%       including errors.


    properties (Abstract)
        % Controlled should be true if it's a
        % controlled gate, false otherwise. Operation_time can be used to
        % calculate decoherence and amplitude damping for bits left out of
        % the operation. target errors and control errors are the errors
        % affecting the target and control bits respectively. error_weights
        % say how strong each error should be. 
        controlled;
        operation_time;
        p_eij;
        p_no_op;
    end
    properties (Dependent)
        p_succ
    end
    
    methods (Abstract)
        res = pure_operation(obj, nbitstate, targets, controls)
        res = apply_errors(obj, nbitstate, targets, controls)
    end
    
    methods
        
        function obj = QuantumGate(p_eij, p_no_op, operation_time)  
            if nargin < 1
                obj.operation_time = 0;
                obj.p_eij = 0;
                obj.p_no_op = 0;
            elseif nargin < 2
                obj.p_eij = p_eij;
                obj.p_no_op = 0;
                obj.operation_time = 0;
            elseif nargin < 3
                obj.p_eij = p_eij;
                obj.p_no_op = p_no_op;
                obj.operation_time = 0;
            else
                obj.p_eij = p_eij;
                obj.p_no_op = p_no_op;
                obj.operation_time = operation_time;
            end
                
        end
        
        
        function fid = get.p_succ(obj)
            fid = 1 - (obj.p_no_op + sum(obj.p_eij(:)));   
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
            if nargin <4 
                if obj.controlled
                    error('Specify control bits for controlled gate')
                else
                    controls=0;
                end
            end
            
            if nargin < 4                
                rho_exact = obj.pure_operation(nbitstate, targets);
                %spy(rho_exact)
                if obj.p_succ ~= 1
                    rho_error = obj.apply_errors(nbitstate, targets);
                end
            else
                rho_exact = obj.pure_operation(nbitstate, controls, targets);
                %spy(rho_exact)
                if obj.p_succ ~= 1
                    rho_error = obj.apply_errors(nbitstate, controls, targets);
                end
            end
            %spy(rho_error)
            if obj.p_succ ~= 1
                rho = rho_exact+rho_error;
            else
                rho = rho_exact;
            end
            %spy(rho)
            if isa(nbitstate, 'NbitState')
                rho = NbitState(sparse(rho));
            end
        end
        
    end
    
    
end