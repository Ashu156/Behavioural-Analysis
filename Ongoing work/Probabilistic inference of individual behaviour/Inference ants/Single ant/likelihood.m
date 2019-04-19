function [Lik] = likelihood_lambda(a)

global ibar NSU NSD NUS NUD NDS NDU TimeS TimeU TimeD


aSU = a(1);
aSD = a(2);
aUS = a(3);
aUD = a(4);
aDS = a(5);
aDU = a(6); 

Lik = 0;
Lik = Lik + aSU*NSU(ibar) + aSD*NSD(ibar) + aUS*NUS(ibar) + aUD*NUD(ibar) + aDS*NDS(ibar) + aDU*NDU(ibar);
Lik = Lik - (exp(aSU) + exp(aSD))*TimeS(ibar) - (exp(aUS) + exp(aUD))*TimeU(ibar) - (exp(aDS) + exp(aDU))*TimeD(ibar);

