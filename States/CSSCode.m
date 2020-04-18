classdef CSSCode < handle
% Base class for CSS-codes for error correction. 
%       The CSS codes are special in that the stabilisers can be written as
%       tensor products of exclusively X and Z operators, e.g. IIIXXXX
%       which makes error correction very transparent.
    properties (Abstract)
        nbits % # Physical bits needed to encode encoded_bits.
        encoded_bits % # logical bits produced by the code
        n_generators % # Generators that specify the code
        XStabilisers % Stabilisers to correct Z-errors
        ZStabilisers % Stabilisers to correct for X- errors
        logical_X;
        logical_Y;
        logical_Z;
        logical_H;
    end
    
    methods
       
        function obj = CSSCode()
            
        end
        
        function res = get_stabweight(obj, type, i)
            if strcmp(type, 'X')
                stab = obj.XStabilisers(i,:);
            elseif strcmp(type, 'Z')
                stab = obj.ZStabilisers(i,:);
            end
            res = 0;
            for op = stab
                if ~strcmp(op, 'I')
                    res = res+1;
                end
            end
        end
        
        function stab_mat = stabiliser_matrix(obj,type, i)
            % Method to build the matrix for the i:th stabiliser of the code.
            if strcmp(type, 'X')
                components = obj.XStabilisers(i,:);
            elseif strcmp(type, 'Z')
                components = obj.ZStabilisers(i,:);
            end
            I = speye(2);
            X = sparse([0 1;1 0]);
            Y = sparse([0 -1i;1i 0]);
            Z = sparse([1 0; 0 -1]);
            pre = [];
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
                pre(:,:,end+1) = op;
            end
            stab_mat = tensor_product(pre);
        end
        
        function c_stab = cstabiliser(obj, type, i)
            % Creates a controlled version of the stabiliser used for
            % readouts. 
            if (i < 1 || i > obj.n_stabilisers)
                error('Index i out of bounds')
            end
            weight = obj.get_stab_weight(type,i);
            tot_bits = obj.nbits + weight;
            if strcmp(type, 'X')
                gen = obj.XStabilisers(i,:);
            elseif strcmp(type, 'Z')
                gen = obj.ZStabilisers(i,:);
            end
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
        end
        
        function [controls, targets] = get_gen_indices(obj, gentype, genind, block)
           % Generates the indices for target and control bits needed to 
           % perform a controlled generator operation on block i of
           % physical bits in an encoded state. 
           if strcmp(gentype, 'X')
               gen = obj.XStabilisers(genind,:);
           elseif strcmp(gentype, 'Z')
               gen = obj.ZStabilisers(genind, :);
           else
               error('Choose gentype X or Z')
           end
           blocksz = length(gen); % # of physical bits in a logical bit
           weight = obj.get_stabweight(gentype,genind); % Weight of the generator
           controls = 1:weight;
           targets = [];
           for i = 1:blocksz
               if strcmp(gen(i),gentype)
                   targets(end+1) = i + weight + (block-1)*blocksz;
               end
           end
        end
    end
    
end