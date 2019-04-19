function [Lik,LikGrad] = likelihoodRT_CG(a)
global Time Transitions Tau
global Ahist Xhist Yhist
global ii jj kk 
global phi u v
global Tmax dt
%% computes the likelihood function
%% 1. Terms with Transitions stay the same
%% 2. Terms with Time split into two parts, depending on the current state
%%      a) If in state RUN (1) leave the same
%%      b) if in state TUMBLE (2) numerically solve the PDE system 
%%         and use Tau to sompute the statistics for each entrance angle

i=ii; j=jj; k=kk;

Lik = 0;
%% add here the contribution of the Transitions
Lik = Lik + a(1)*Transitions(1,i,j,k) - exp(a(1))*Time(1,i,j,k);
Lik = Lik + a(2)*Transitions(2,i,j,k) - exp(a(2))*Time(2,i,j,k);

LikGrad = zeros(1,2);
%% add here the contribution of the Transitions
LikGrad(1) = LikGrad(1) + Transitions(1,i,j,k) - exp(a(1))*Time(1,i,j,k);
LikGrad(2) = LikGrad(2) + Transitions(2,i,j,k) - exp(a(2))*Time(2,i,j,k);

Lik = -Lik;
LikGrad = -LikGrad';