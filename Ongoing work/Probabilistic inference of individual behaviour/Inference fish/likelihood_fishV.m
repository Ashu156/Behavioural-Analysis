function [Lik2,LikGrad2] = likelihood_fishV(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on velocity

global TimeV TransitionsV 
global Vbins 


Lik = 0;
LikGrad = zeros(1,6*Vbins);

    for iv = 1:Vbins
            n = (iv-1)*6;
            Lik = Lik + a1(1+n)*TransitionsV(1,iv); LikGrad(1+n) = LikGrad(1+n) + TransitionsV(1,iv);
            Lik = Lik + a1(2+n)*TransitionsV(2,iv); LikGrad(2+n) = LikGrad(2+n) + TransitionsV(2,iv);
            Lik = Lik + a1(3+n)*TransitionsV(3,iv); LikGrad(3+n) = LikGrad(3+n) + TransitionsV(3,iv);
            Lik = Lik + a1(4+n)*TransitionsV(4,iv); LikGrad(4+n) = LikGrad(4+n) + TransitionsV(4,iv);
            Lik = Lik + a1(5+n)*TransitionsV(5,iv); LikGrad(5+n) = LikGrad(5+n) + TransitionsV(5,iv);
            Lik = Lik + a1(6+n)*TransitionsV(6,iv); LikGrad(6+n) = LikGrad(6+n) + TransitionsV(6,iv);
       
    end
    
    for iv = 1:Vbins
            n = (iv-1)*6;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeV(1,iv); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeV(1,iv);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeV(1,iv);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeV(2,iv);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeV(2,iv);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeV(2,iv);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeV(3,iv);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeV(3,iv);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeV(3,iv);
    end

    
%% REGULARIZATION
K = 10000;
for is = 1:6
    for iv = 1:Vbins
        if is == 4 || is ==6
            n = (iv-1)*6;
            Lik = Lik - K*(exp(a1(is+n))-1).^2;
            LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
        end
    end
end


Lik2 = -Lik;
LikGrad2 = -LikGrad';

