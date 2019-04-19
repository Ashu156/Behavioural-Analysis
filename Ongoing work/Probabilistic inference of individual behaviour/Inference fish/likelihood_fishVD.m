function [Lik2,LikGrad2] = likelihood_fishVD(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on velocity and on the wall distance

global TimeVD TransitionsVD 
global Vhist Dhist
global Vbins Dbins


Lik = 0;
LikGrad = zeros(1,6*Vbins*Dbins);

    for iv = 1:Vbins
        for id = 1:Dbins
            n = (iv-1)*6 + (id-1)*6*Vbins;
            Lik = Lik + a1(1+n)*TransitionsVD(1,iv,id); LikGrad(1+n) = LikGrad(1+n) + TransitionsVD(1,iv,id);
            Lik = Lik + a1(2+n)*TransitionsVD(2,iv,id); LikGrad(2+n) = LikGrad(2+n) + TransitionsVD(2,iv,id);
            Lik = Lik + a1(3+n)*TransitionsVD(3,iv,id); LikGrad(3+n) = LikGrad(3+n) + TransitionsVD(3,iv,id);
            Lik = Lik + a1(4+n)*TransitionsVD(4,iv,id); LikGrad(4+n) = LikGrad(4+n) + TransitionsVD(4,iv,id);
            Lik = Lik + a1(5+n)*TransitionsVD(5,iv,id); LikGrad(5+n) = LikGrad(5+n) + TransitionsVD(5,iv,id);
            Lik = Lik + a1(6+n)*TransitionsVD(6,iv,id); LikGrad(6+n) = LikGrad(6+n) + TransitionsVD(6,iv,id);
        end
    end
    
    for iv = 1:Vbins
        for id = 1:Dbins
            n = (iv-1)*6 + (id-1)*6*Vbins;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeVD(1,iv,id); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeVD(1,iv,id);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeVD(1,iv,id);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeVD(2,iv,id);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeVD(2,iv,id);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeVD(2,iv,id);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeVD(3,iv,id);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeVD(3,iv,id);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeVD(3,iv,id);
        end
    end

%% REGULARIZATION
K = 10000;
for is = 1:6
    for iv = 1:Vbins
        for id = 1:Dbins
            if is == 4 || is ==6
                n = (iv-1)*6 + (id-1)*6*Vbins;
                Lik = Lik - K*(exp(a1(is+n))-1).^2;
                LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
            end
        end
    end
end

Lik2 = -Lik;
LikGrad2 = -LikGrad';

