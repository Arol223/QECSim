% Defines general class for damping channels. Takes a damping coefficient.
% Form of these can be found in Nielsen and Chuang chapter 8.
% Needs a separate class from other operations since the operation doesn't
% have individual weights for the elements but rather a damping coefficient
% that appears only in specific matrix elements.

classdef DampingChannel < handle
    
    properties
        DampingCoeff % For amplitude damping this would be gamma.
        DampEl = memoize(@DampEl)
    end
    
    properties(Abstract)
        operation_elements % Form depends on specific dampng behaviour.
    end
    
    methods(Abstract)
        nbit_op_element(obj, element_number, target, tot_bits)           
    end
    
    methods
        
        function obj = DampingChannel(DampingCoeff)
            obj.DampingCoeff = DampingCoeff;
            
        end
        
        function set.DampingCoeff(obj, DampingCoeff)
            obj.DampingCoeff = DampingCoeff;
        end
        
        function val = get.DampingCoeff(obj)
            val = obj.DampingCoeff;
        end
        
        function rho = apply(obj, nstate, targets)
            % Used to apply error to state, which can be defined either by
            % a density matrix or an instance of NbitState. Returns a
            % density matrix.
            return_state = 0;
            if isa(nstate,'NbitState')
                r_tmp = nstate.rho;
                
                return_state = 1;
            else
                r_tmp = nstate;
                
            end
            res = obj.apply_single(r_tmp,targets(1));
            for i=2:length(targets)
                res = obj.apply_single(res,targets(i));
            end
            
            if (nnz(res) > (size(res,1)^2)/2 && issparse(res))
                res = full(res);
            elseif ~issparse(res)
                res = sparse(res);
            end
            if return_state
                rho = NbitState(res);
                rho.copy_params(nstate);
            else
                rho = res;
            end
        end
        
        %         function op = nbit_op_element(obj, element_number, target, tot_bits)
        %             % Used to construct an operation element for a multi qubit
        %             % density matrix. targets is a vector containing indices of
        %             % bits to be affected by error.
        %             element = obj.operation_elements(:,:,element_number);
        %             pre_op = zeros(2,2,tot_bits);
        %             for i = 1:tot_bits
        %                 if ismember(i,target)
        %                     pre_op(:,:,i) = element;
        %                 else
        %                     pre_op(:,:,i) = eye(2);
        %                 end
        %             end
        %             op = tensor_product(pre_op);
        %
        %         end
        
        function res = apply_single(obj, nstate, target)
            if ~(isa(nstate,'NbitState')|| ismatrix(nstate))
                error('nstate must be an NbitState, a subclass thereof or a matrix')
            end
            tot_bits = log2(size(nstate,1));
            r_tmp = nstate;
            res = zeros(size(r_tmp));
            %             n = size(r_tmp,1);
            %             C = cell(size(obj.operation_elements,3),1);
            for i =1:size(obj.operation_elements,3)
                op = obj.nbit_op_element(i, target, tot_bits);
                %tmp = op*r_tmp*op';
                %                [I,J,S] = find(tmp);
                %                C{i} = [I,J,S];
                res = res + op*r_tmp*op';
            end
            
            %             IJS = cell2mat(C);
            %             res = sparse(IJS(:,1),IJS(:,2),IJS(:,3),n,n);
            

        end
        
    end
    
    
end


