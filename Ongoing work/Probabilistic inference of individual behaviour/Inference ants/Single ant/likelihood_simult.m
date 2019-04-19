function [Lik2,LikGrad2] = likelihood_lambda_simult(a)

global Nbins NSU NSD NUS NUD NDS NDU TimeS TimeU TimeD


aSU = a(1:Nbins);
aSD = a(  Nbins+1:2*Nbins);
aUS = a(2*Nbins+1:3*Nbins);
aUD = a(3*Nbins+1:4*Nbins);
aDS = a(4*Nbins+1:5*Nbins);
aDU = a(5*Nbins+1:6*Nbins); 


Lik = 0; 
LikGrad = zeros(1,6*Nbins);

for i=1:Nbins
    Lik = Lik + aSU(i)*NSU(i) + aSD(i)*NSD(i) + aUS(i)*NUS(i) + aUD(i)*NUD(i) + aDS(i)*NDS(i) + aDU(i)*NDU(i);
    Lik = Lik - (exp(aSU(i)) + exp(aSD(i)))*TimeS(i) - (exp(aUS(i)) + exp(aUD(i)))*TimeU(i) - (exp(aDS(i)) + exp(aDU(i)))*TimeD(i);
end


for i=1:Nbins
    LikGrad(          i) = NSU(i) - exp(aSU(i)) *TimeS(i); 
    LikGrad(  Nbins + i) = NSD(i) - exp(aSD(i)) *TimeS(i); 
    LikGrad(2*Nbins + i) = NUS(i) - exp(aUS(i)) *TimeU(i); 
    LikGrad(3*Nbins + i) = NUD(i) - exp(aUD(i)) *TimeU(i); 
    LikGrad(4*Nbins + i) = NDS(i) - exp(aDS(i)) *TimeD(i); 
    LikGrad(5*Nbins + i) = NDU(i) - exp(aDU(i)) *TimeD(i); 
end

Lik2 = -Lik;
LikGrad2 = -LikGrad';