function [psi,rho] = LogStatePrep(code, word)
%LOGSTATEPREP Return a logical state of the chosen code
%   --------Inputs--------
%   code - 'Surf', '5Qubit', 'Steane'
%   word - '0', '+'

switch code
    case 'Surf'
        [psi_0, ~] = Logical0Surf17();
        X = BuildOpMat('IIXIXIXII');
    case '5Qubit'
        [~,psi_0] = Log0FiveQubit();
        X = BuildOpMat('XXXXX');
    case 'Steane'
        [psi_0,~] = Log0FlagSteane();
        X = BuildOpMat('XXXXXXX');
end
   
switch word
    case '0'
        psi = psi_0;
    case '+'
        psi = (1/sqrt(2))*(psi_0+X*psi_0);
    
end
rho = NbitState(psi*psi');
end

