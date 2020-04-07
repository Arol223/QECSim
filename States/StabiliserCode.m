% Container class in which can be specified a stabiliser code encoding
% encoded_bits in nbits with distance distance and stabilisers specified in
% a character array.
classdef StabiliserCode
    properties
        nbits;
        encoded_bits;
        distance;
        n_stabilisers;
        stabilisers={};
        logical_operators = {};
        stab_weight;
    end
    
%     properties (Dependent)
%         stabiliser_matrix;
   
    
    methods
        
        function obj = StabiliserCode(nbits, encoded_bits, distance,...
                stabilisers, logical_operators, stab_weight)
            % Constructor. Requires number of bits (nbits), number of
            % encoded bits (encoded_bits), distance of the code,
            % stabilisers as a struct, logical operators as struct, and the
            % weight of the stabilisers, i.e. the number of operators in 
            % the stabiliser that are not the identity.
            obj.nbits = nbits;
            obj.encoded_bits = encoded_bits;
            obj.n_stabilisers = nbits - encoded_bits;
            obj.distance = distance;
            obj.stab_weight = stab_weight; % The weight of the stabilisers. Required for fault tolerant measurement etc.
            if length(stabilisers)< obj.n_stabilisers
                error('Too few stabilisers specified')
            else
                obj.stabilisers = stabilisers;
            end
            obj.logical_operators = logical_operators;
        end
         
        
        function stab_mat = stabiliser_matrix(obj,i)
            % Method to build the matrix for the i:th stabiliser of the code.
            components = obj.stabilisers(i,:);
            I = speye(2);
            X = sparse([0 1;1 0]);
            Y = sparse([0 -1i;1i 0]);
            Z = sparse([1 0; 0 -1]);
            pre = {};
            for s = components
                if s == 'I'
                    op = I;
                elseif s == 'X'
                        op = X;
                elseif s == 'Y'
                    op = Y;
                elseif s=='Z'
                    op = Z;
                end
                pre{end+1} = op;
            end
            stab_mat = tensor_product(pre);
        end
        
        % Matrix form of the controlled generator i, used for measurements
        % etc.
        function c_stab = cstabiliser(obj,i)
            % Creates a controlled version of the stabiliser used for
            % readouts. 
            if i < 1 || i > obj.n_stabilisers
                error('Index i out of bounds')
            end
            weight = obj.stab_weight;
            tot_bits = obj.nbits + weight;
            gen = obj.stabilisers(i,:);
            c_stab = speye(2^tot_bits);
            control = weight; % Keep track of which bit to use as control. Follows Fig.16 p29 of https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
            for j = 1:obj.nbits % but the bit at top of circuit is counted as bit nbr 1, msb.
                if control < 1
                    break
                end
                
                if gen(j) == 'I'
                    continue
                elseif gen(j) == 'X'
                    c_stab = c_stab*kCNOT(control,j+weight,tot_bits);
                    control = control - 1;
                elseif gen(j) == 'Y'
                    c_stab = c_stab*kCY(control,j+obj.weight,tot_bits);
                    control = control - 1;
                elseif gen(j) == 'Z'
                    c_stab = c_stab*kCZ(control,j+weight,tot_bits);
                    control = control - 1;
                end
                
            end
           % c_stab = c_stab'; % Transpose because of the qubit counting convention used. This reverses the order of operations
        end
        
        % Displays the i:th stabiliser as e.g. 'XXXZZII'
        % TODO: fix formatting of this so it looks sensible...
        function print_stabiliser(obj,i)
           disp('Stabiliser number') 
           disp(i)
           disp('is \n')
           disp(obj.stabilisers(i,:))
        end
    end
    
    
    
    
end

