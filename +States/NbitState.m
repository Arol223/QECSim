% Class to represent an nbit QM state. Provides functionality to perform
% operations and initialisation.
classdef NbitState < handle
    
    properties
        rho; %Density matrix
    end
    
    properties (Dependent = true)
        nbits;  %number of bits in state
    end
    
    methods
        
        %Constructor, takes argument initial number of bits nbits_i
        function obj = NbitState(rho)
            if nargin == 1
                obj.rho = rho;
            end
        end
        %         function set.nbits(obj)
        %             v = size(obj.rho,1);
        %             obj.nbits
        %         end
        function val = get.nbits(obj)
            val = size(obj.rho,1);
            val = log2(val);
        end
        function set.rho(obj, rho)
            obj.rho = rho;
        end
        % Enables adding NbitStates as s = a+b where a & b are NbitStates
        function s = plus(obj,oth)
            if isa(oth, 'NbitState')
                x = obj.rho + oth.rho;
            elseif ismatrix(oth) && size(oth) == size(obj.rho)
                x = obj.rho + oth;
            else
                error('Both operands must be NbitStates or matrices of right dimension')
            end
            bitn = log2(size(x,1));
            s = NbitState(bitn);
            s.initialise(x);
        end
        
        % Overloads * to become the tensor product of two NbitStates
        function tp = mtimes(obj, oth)
            if isa(oth, 'NbitState')
                mat = tensor_product({obj.rho,oth.rho});
                tp = NbitState();
                tp.initialise(mat);
            elseif ismatrix(oth)
                mat = tensor_product({obj.rho,oth});
                tp = NbitState();
                tp.initialise(mat);
            else
                error('Both operands must be NbitStates or matrices of right dimension')
            end
            
        end
        
        
        function initialise(obj, rho)
            % Initialise in the state given by state, a density matrix
            obj.rho = rho;
        end
        
        
        function init_all_zeros(obj, nbits)
            % Initialise the register with 0 in every position
            obj.rho = sparse(zeros(2^nbits));
            obj.rho(1,1) = 1;
        end
        
        
        % Performs arbitrary unitary operation, overloads .*.
        function t = times(obj, op)
            t = op*obj.rho*op';
        end
        
        
        function extend_state(obj, oth, pos)
            % Extends the state with density matrix rho, could be used for e.g
            % adding ancilla bits. 
            % Ex: If state a is described by density matrix s, 
            % a.extend_state(p,'start') = pxs where x is the kronecker product. 
            if isa(oth,'NbitState')
                if strcmp(pos,'end')
                    obj.rho = kron(obj.rho,oth.rho);
                elseif strcmp(pos, 'start')
                    obj.rho = kron(oth.rho,obj.rho);
                end
                
            elseif ismatrix(oth)
                if strcmp(pos,'end')
                    obj.rho = kron(obj.rho, oth);
                elseif strcmp(pos, 'start')
                    obj.rho = kron(oth,obj.rho);
                end
            else
                error('Input has to be either derived from NbitState or be a matrix')
            end
            %spy(obj.rho)
        end
        
        
        % TODO: This doesn't work, try to fix if time exists|| fixed
        function trace_out_bits(obj, bit_nbrs)
            % Traces out the bits specified in bit_nbrs. See
            % TrX for implementation details and source. 
            obj.rho = TrX(obj.rho, bit_nbrs, 2*ones(1, obj.nbits));
        end
        
        function trace_out_system(obj, sys, dim)
            % Trace out system number sys. Dim is a vector containing the
            % dimensions of all subsystems. See TrX for implementation
            % details. 
            obj.rho = TrX(obj.rho, sys, dim);
        end
        
        function operation(obj, operator)
            % Performs an operation on the form U*rho*U*, U given by
            % operator in matrix form.
            obj.rho = operator*obj.rho*operator';
        end
        
        function noisy_operation(obj, op, noise, targets)
            if nargin < 2
                obj.operation(op)
            elseif ~isa(noise, 'QuantumErrorChannel')
                error('Noise has to be empty or instance of QuantumErrorChannel')
            else
               obj.operation(op);
               obj.rho = noise.apply_error(obj.rho, targets);
            end
        end
    end
    
end