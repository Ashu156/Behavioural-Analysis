function [Lik2,LikGrad2] = likelihood_fishVW(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on velocity and on the wall distance

global TimeVW TransitionsVW 
global Vhist Whist
global Vbins Wbins


Lik = 0;
LikGrad = zeros(1,6*Vbins*Wbins);

    for iv = 1:Vbins
        for iw = 1:Wbins
            n = (iv-1)*6 + (iw-1)*6*Vbins;
            Lik = Lik + a1(1+n)*TransitionsVW(1,iv,iw); LikGrad(1+n) = LikGrad(1+n) + TransitionsVW(1,iv,iw);
            Lik = Lik + a1(2+n)*TransitionsVW(2,iv,iw); LikGrad(2+n) = LikGrad(2+n) + TransitionsVW(2,iv,iw);
            Lik = Lik + a1(3+n)*TransitionsVW(3,iv,iw); LikGrad(3+n) = LikGrad(3+n) + TransitionsVW(3,iv,iw);
            Lik = Lik + a1(4+n)*TransitionsVW(4,iv,iw); LikGrad(4+n) = LikGrad(4+n) + TransitionsVW(4,iv,iw);
            Lik = Lik + a1(5+n)*TransitionsVW(5,iv,iw); LikGrad(5+n) = LikGrad(5+n) + TransitionsVW(5,iv,iw);
            Lik = Lik + a1(6+n)*TransitionsVW(6,iv,iw); LikGrad(6+n) = LikGrad(6+n) + TransitionsVW(6,iv,iw);
        end
    end
    
    for iv = 1:Vbins
        for iw = 1:Wbins
            n = (iv-1)*6 + (iw-1)*6*Vbins;
            Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*TimeVW(1,iv,iw); 
                LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*TimeVW(1,iv,iw);
                LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*TimeVW(1,iv,iw);
            Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*TimeVW(2,iv,iw);
                LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*TimeVW(2,iv,iw);
                LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*TimeVW(2,iv,iw);
            Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*TimeVW(3,iv,iw);
                LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*TimeVW(3,iv,iw);
                LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*TimeVW(3,iv,iw);
        end
    end

%% REGULARIZATION
K = 10000;
for is = 1:6
    for iv = 1:Vbins
        for iw = 1:Wbins
            if is == 4 || is ==6
                n = (iv-1)*6 + (iw-1)*6*Vbins;
                Lik = Lik - K*(exp(a1(is+n))-1).^2;
                LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
            end
        end
    end
end


Lik2 = -Lik;
LikGrad2 = -LikGrad';

