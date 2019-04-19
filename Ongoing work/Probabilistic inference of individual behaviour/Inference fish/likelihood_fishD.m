function [Lik2,LikGrad2] = likelihood_fishD(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on the mutual distance

global TimeD TransitionsD 
global Dbins 


Lik = 0;
LikGrad = zeros(1,6*Dbins);

    for id = 1:Dbins
            n = (id-1)*6;
            Lik = Lik + a1(1+n)*TransitionsD(1,id); LikGrad(1+n) = LikGrad(1+n) + TransitionsD(1,id);
            Lik = Lik + a1(2+n)*TransitionsD(2,id); LikGrad(2+n) = LikGrad(2+n) + TransitionsD(2,id);
            Lik = Lik + a1(3+n)*TransitionsD(3,id); LikGrad(3+n) = LikGrad(3+n) + TransitionsD(3,id);
            Lik = Lik + a1(4+n)*TransitionsD(4,id); LikGrad(4+n) = LikGrad(4+n) + TransitionsD(4,id);
            Lik = Lik + a1(5+n)*TransitionsD(5,id); LikGrad(5+n) = LikGrad(5+n) + TransitionsD(5,id);
            Lik = Lik + a1(6+n)*TransitionsD(6,id); LikGrad(6+n) = LikGrad(6+n) + TransitionsD(6,id);
       
    end
    
    for id = 1:Dbins
            n = (id-1)*6;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeD(1,id); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeD(1,id);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeD(1,id);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeD(2,id);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeD(2,id);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeD(2,id);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeD(3,id);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeD(3,id);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeD(3,id);
    end

%% REGULARIZATION
K = 10000;
for is = 1:6
    for id = 1:Dbins
        if is == 4 || is ==6
            n = (id-1)*6;
            Lik = Lik - K*(exp(a1(is+n))-1).^2;
            LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
        end
    end
end


Lik2 = -Lik;
LikGrad2 = -LikGrad';

