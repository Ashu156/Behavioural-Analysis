%% computes the likelihood function
function [Lik,LikGrad] = likelihoodRT1D(a)
global NbinsX NbinsY NbinsA Time Transitions Xhist Yhist Ahist
global ii jj kk 

i=ii; j=jj; k=kk;

Lik = 0;
Lik = Lik + a(1)*Transitions(1,i,j,k) - exp(a(1))*Time(1,i,j,k);
Lik = Lik + a(2)*Transitions(2,i,j,k) - exp(a(2))*Time(1,i,j,k);
Lik = Lik + a(3)*Transitions(3,i,j,k) - exp(a(3))*Time(2,i,j,k);
Lik = Lik + a(4)*Transitions(4,i,j,k) - exp(a(4))*Time(2,i,j,k);
Lik = Lik + a(5)*Transitions(5,i,j,k) - exp(a(5))*Time(3,i,j,k);
Lik = Lik + a(6)*Transitions(6,i,j,k) - exp(a(6))*Time(3,i,j,k);

LikGrad = zeros(1,6);

LikGrad(1) = Transitions(1,i,j,k) - exp(a(1))*Time(1,i,j,k);
LikGrad(2) = Transitions(2,i,j,k) - exp(a(2))*Time(1,i,j,k);
LikGrad(3) = Transitions(3,i,j,k) - exp(a(3))*Time(2,i,j,k);
LikGrad(4) = Transitions(4,i,j,k) - exp(a(4))*Time(2,i,j,k);
LikGrad(5) = Transitions(5,i,j,k) - exp(a(5))*Time(3,i,j,k);
LikGrad(6) = Transitions(6,i,j,k) - exp(a(6))*Time(3,i,j,k);

Lik = -Lik;
LikGrad = -LikGrad';