function [Lik2,LikGrad2] = likelihood_fishWD(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on velocity and on the wall distance

global TimeWD TransitionsWD 
global Whist Dhist
global Wbins Dbins


Lik = 0;
LikGrad = zeros(1,6*Wbins*Dbins);

    for iw = 1:Wbins
        for id = 1:Dbins
            n = (iw-1)*6 + (id-1)*6*Wbins;
            Lik = Lik + a1(1+n)*TransitionsWD(1,iw,id); LikGrad(1+n) = LikGrad(1+n) + TransitionsWD(1,iw,id);
            Lik = Lik + a1(2+n)*TransitionsWD(2,iw,id); LikGrad(2+n) = LikGrad(2+n) + TransitionsWD(2,iw,id);
            Lik = Lik + a1(3+n)*TransitionsWD(3,iw,id); LikGrad(3+n) = LikGrad(3+n) + TransitionsWD(3,iw,id);
            Lik = Lik + a1(4+n)*TransitionsWD(4,iw,id); LikGrad(4+n) = LikGrad(4+n) + TransitionsWD(4,iw,id);
            Lik = Lik + a1(5+n)*TransitionsWD(5,iw,id); LikGrad(5+n) = LikGrad(5+n) + TransitionsWD(5,iw,id);
            Lik = Lik + a1(6+n)*TransitionsWD(6,iw,id); LikGrad(6+n) = LikGrad(6+n) + TransitionsWD(6,iw,id);
        end
    end
    
    for iw = 1:Wbins
        for id = 1:Dbins
            n = (iw-1)*6 + (id-1)*6*Wbins;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeWD(1,iw,id); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeWD(1,iw,id);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeWD(1,iw,id);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeWD(2,iw,id);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeWD(2,iw,id);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeWD(2,iw,id);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeWD(3,iw,id);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeWD(3,iw,id);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeWD(3,iw,id);
        end
    end

%% REGULARIZATION
K = 10000;
for is = 1:6
    for iw = 1:Wbins
        for id = 1:Dbins
            if is == 4 || is ==6
                n = (iw-1)*6 + (id-1)*6*Wbins;
                Lik = Lik - K*(exp(a1(is+n))-1).^2;
                LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
            end
        end
    end
end

Lik2 = -Lik;
LikGrad2 = -LikGrad';

