function [Lik2,LikGrad2] = likelihood_fishW(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on the wall distance

global TimeW TransitionsW 
global Whist Wbins 


Lik = 0;
LikGrad = zeros(1,6*Wbins);

    for iw = 1:Wbins
            n = (iw-1)*6;
            Lik = Lik + a1(1+n)*TransitionsW(1,iw); LikGrad(1+n) = LikGrad(1+n) + TransitionsW(1,iw);
            Lik = Lik + a1(2+n)*TransitionsW(2,iw); LikGrad(2+n) = LikGrad(2+n) + TransitionsW(2,iw);
            Lik = Lik + a1(3+n)*TransitionsW(3,iw); LikGrad(3+n) = LikGrad(3+n) + TransitionsW(3,iw);
            Lik = Lik + a1(4+n)*TransitionsW(4,iw); LikGrad(4+n) = LikGrad(4+n) + TransitionsW(4,iw);
            Lik = Lik + a1(5+n)*TransitionsW(5,iw); LikGrad(5+n) = LikGrad(5+n) + TransitionsW(5,iw);
            Lik = Lik + a1(6+n)*TransitionsW(6,iw); LikGrad(6+n) = LikGrad(6+n) + TransitionsW(6,iw);
       
    end
    
    for iw = 1:Wbins
            n = (iw-1)*6;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeW(1,iw); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeW(1,iw);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeW(1,iw);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeW(2,iw);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeW(2,iw);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeW(2,iw);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeW(3,iw);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeW(3,iw);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeW(3,iw);
    end

%% REGULARIZATION
K = 10000;
for is = 1:6
    for iw = 1:Wbins
        if is == 4 || is ==6
            n = (iw-1)*6;
            Lik = Lik - K*(exp(a1(is+n))-1).^2;
            LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
        end
    end
end



Lik2 = -Lik;
LikGrad2 = -LikGrad';

