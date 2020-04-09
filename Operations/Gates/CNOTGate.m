classdef CNOTGate < QuantumGate
    %CNOTGATE A CNOT gate model including uncorrelated errors
    %   Detailed explanation goes here
    
    properties (Dependent)
        fidelity
        XerrT
        YerrT
        ZerrT
        XerrC
        YerrC
        ZerrC
    end
    
    properties
        controlled = true;
        operation_time;
        control_errors;
        target_errors;
        no_op_p; % probability that the gate fails completely, i.e.becomes an identity operation.
        p_eij; % probability for ij:th error. First row is target error, second row is control error.
    end
    
    methods
        
        function obj = CNOTGate(p_eij, no_op_p, operation_time)
            obj@QuantumGate()
            if nargin < 1
                obj.operation_time = 0;
                obj.p_eij = 0;
                obj.no_op_p = 0;
            elseif nargin < 2
                obj.p_eij = p_eij;
                obj.no_op_p = 0;
                obj.operation_time = 0;
            elseif nargin < 3
                obj.p_eij = p_eij;
                obj.no_op_p = no_op_p;
                obj.operation_time = 0;
            else
                obj.p_eij = p_eij;
                obj.no_op_p = no_op_p;
                obj.operation_time = operation_time;
            end
                
        end
        function random_errors(obj, fidelity)
           % Sets the error coefficients randomly to get desired total fidelity.
           ep = 1-fidelity; % error probability
           p_eij = rand(2,3);
           p_no_op = rand;
           N = sum(p_eij(:))+p_no_op; %Normalisation constant
           p_eij = ep*p_eij./N;
           p_no_op = ep*p_no_op/N;
           obj.p_eij = p_eij;
           obj.no_op_p = p_no_op;
        end
        function fid = get.fidelity(obj)
            fid = 1 - (obj.no_op_p + sum(obj.p_eij(:)));   
        end
        function res = get.XerrT(obj)
            res = BitflipError(obj.p_eij(1,1));
        end
        function res = get.YerrT(obj)
            res = PauliYError(obj.p_eij(1,2));
        end
        function res = get.ZerrT(obj)
            res = PhaseflipError(obj.p_eij(1,3));
        end
        
        function res = get.XerrC(obj)
            res = BitflipError(obj.p_eij(2,1));
        end
        function res = get.YerrC(obj)
            res = PauliYError(obj.p_eij(2,2));
        end
        function res = get.ZerrC(obj)
            res = PhaseflipError(obj.p_eij(2,3));
        end
        function err = get_error(obj, ind)
                
                if ind == [1 1]
                    err = obj.XerrT;
                elseif ind == [1 2]
                    err = obj.YerrT;
                elseif ind == [1 3]
                    err = obj.ZerrT;
                elseif ind == [2 1]
                   err = obj.XerrC;
                elseif ind == [2 2]
                    err = obj.YerrC;
                elseif ind == [2 3]
                    err = obj.ZerrC;
                end
        end
        
        function rho = pure_operation(obj, nbitstate, targets, controls)
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                rho = nbitstate.rho;
            elseif ismatrix(nbitstate)
                nbits = log2(size(nbitstate,1));
                rho = nbitstate;
            end
            cnot = knCNOT(controls,targets,nbits);
            %spy(cnot)
            rho = obj.fidelity*cnot*rho*cnot';
            %spy(rho)
        end
        
        function rho = apply_errors(obj, nbitstate, targets, controls)
            % Applies errors for cnot gate. This needs to be fixed to
            % accomodate correlated errors on both control and target bits.
            
            if isa(nbitstate, 'NbitState')
                rho = zeros(size(nbitstate.rho));
            elseif ismatrix(nbitstate)
                rho = zeros(size(nbitstate));
            end
            for i = 1:2
                for j = 1:3
                    err = obj.get_error([i j]);
                    if i == 1
                        rho = rho + err.apply_channel(nbitstate,targets,0);
                    else
                        rho = rho + err.apply_channel(nbitstate,controls,0);
                    end       
                end
            end
            
            
            % Adds an identity component
            if isa(nbitstate, 'NbitState')
                rho = rho + obj.no_op_p*nbitstate.rho;
            elseif ismatrix(nbitstate)
                rho = rho + obj.no_op_prob*nbitstate;
            end
            
        end
        
    end
    
end

