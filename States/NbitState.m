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
        function x = plus(obj,oth)
            if isa(oth, 'NbitState')
                x = sparse(obj.rho + oth.rho);
            elseif (ismatrix(oth) && (isequal(size(oth), size(obj.rho))))
                x = sparse(obj.rho + oth);
    
            else
                error('Both operands must be NbitStates or matrices of right dimension')
            end
            x = NbitState(x);
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
        
        function [m,n] = size(obj)
           [m,n] = size(obj.rho); 
        end
        
        function init_all_zeros(obj, nbits, init_error)
            % init_all_zeros(nbits, init_error)
            % Initialise the register with 0 in every position with
            % initialisation error. 
            p_0 = 1 - init_error; % Prob to be initialised in 0
            p_1 = init_error; % -||- 1
            el = sparse([p_0 0; 0 p_1]);
            obj.rho = el;
            for i = 1:nbits-1
                obj.rho = kron(obj.rho, el);
            end
        end
        
        function res = times(obj, op)
        % Performs arbitrary operation or scalar multiplication,
        % overloads '.*'.
            if isscalar(op)
                res = op.*obj.rho;
                res = NbitState(res);
            elseif ismatrix(op)
                res = obj.rho*op;
                res = NbitState(res);
            elseif (isa(op,'NbitState') && ismatrix(obj))
                res = obj*op.rho;
                res = NbitState(res);
            end
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
        
        function trace_out_bits(obj, bit_nbrs)
            % Traces out the bits specified in bit_nbrs. See
            % TrX for implementation details and source. 
            if isequal(bit_nbrs, 1:length(bit_nbrs)) % A check if the bipartite partial trace is requested;
                dims = [2^length(bit_nbrs),2^(obj.nbits - length(bit_nbrs))];
                obj.rho = TraceOutLeft(dims,obj.rho);
            else
                obj.rho = TrX(obj.rho, bit_nbrs, 2*ones(1, obj.nbits));
            end
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
        
        function res = trace(obj)
            res = trace(obj.rho);
        end
        
        function spy(obj)
            spy(obj.rho)
        end
        
        function res = nnz(obj)
            res = nnz(obj.rho);
        end
        function normalise(obj)
            obj.rho = obj.rho./trace(obj.rho);
        end
    end
    
end