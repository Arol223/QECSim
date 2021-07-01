function [z_ind] = XZMap(x_ind)
%XZMAP Map X-stabiliser qubit number to corresponding for Z

if length(x_ind) > 1
    z_ind = zeros(size(x_ind));
    for i = 1:length(z_ind)
        z_ind(i) = XZMap(x_ind(i));
    end
    return
end
switch x_ind
    case 1
        z_ind = 3;
    case 2 
        z_ind = 6;
    case 3
        z_ind = 9;
    case 4 
        z_ind = 2;
    case 5
        z_ind = 5;
    case 6
        z_ind = 8;
    case 7 
        z_ind = 1;
    case 8 
        z_ind = 4;
    case 9 
        z_ind = 7;
end

end

