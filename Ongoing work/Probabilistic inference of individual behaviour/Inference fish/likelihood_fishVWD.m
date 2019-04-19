function [Lik2,LikGrad2] = likelihood_fishVWD(a1)

%% Likelihood based on the commulative histograms
%% Transitions and Times
%% Dependence on velocity, wall distance and mmutual distance

global Time Transitions 
global Vhist Whist Dhist
global Vbins Wbins Dbins


Lik = 0;
LikGrad = zeros(1,6*Vbins*Wbins*Dbins); %% additional entry is the magnitude of the regularization

    for iv = 1:Vbins
        for iw = 1:Wbins
            for id = 1:Dbins
                n = (iv-1)*6 + (iw-1)*6*Vbins + (id-1)*6*Vbins*Wbins;
                Lik = Lik + a1(1+n)*Transitions(1,iv,iw,id); LikGrad(1+n) = LikGrad(1+n) + Transitions(1,iv,iw,id);
                Lik = Lik + a1(2+n)*Transitions(2,iv,iw,id); LikGrad(2+n) = LikGrad(2+n) + Transitions(2,iv,iw,id);
                Lik = Lik + a1(3+n)*Transitions(3,iv,iw,id); LikGrad(3+n) = LikGrad(3+n) + Transitions(3,iv,iw,id);
                Lik = Lik + a1(4+n)*Transitions(4,iv,iw,id); LikGrad(4+n) = LikGrad(4+n) + Transitions(4,iv,iw,id);
                Lik = Lik + a1(5+n)*Transitions(5,iv,iw,id); LikGrad(5+n) = LikGrad(5+n) + Transitions(5,iv,iw,id);
                Lik = Lik + a1(6+n)*Transitions(6,iv,iw,id); LikGrad(6+n) = LikGrad(6+n) + Transitions(6,iv,iw,id);
            end
        end
    end
    
    for iv = 1:Vbins
        for iw = 1:Wbins
            for id = 1:Dbins
                n = (iv-1)*6 + (iw-1)*6*Vbins + (id-1)*6*Vbins*Wbins;
                Lik = Lik - (exp(a1(1+n)) + exp(a1(2+n)))*Time(1,iv,iw,id); 
                    LikGrad(1+n) = LikGrad(1+n) - exp(a1(1+n))*Time(1,iv,iw,id);
                    LikGrad(2+n) = LikGrad(2+n) - exp(a1(2+n))*Time(1,iv,iw,id);
                Lik = Lik - (exp(a1(3+n)) + exp(a1(4+n)))*Time(2,iv,iw,id);
                    LikGrad(3+n) = LikGrad(3+n) - exp(a1(3+n))*Time(2,iv,iw,id);
                    LikGrad(4+n) = LikGrad(4+n) - exp(a1(4+n))*Time(2,iv,iw,id);
                Lik = Lik - (exp(a1(5+n)) + exp(a1(6+n)))*Time(3,iv,iw,id);
                    LikGrad(5+n) = LikGrad(5+n) - exp(a1(5+n))*Time(3,iv,iw,id);
                    LikGrad(6+n) = LikGrad(6+n) - exp(a1(6+n))*Time(3,iv,iw,id);
            end
        end
    end
   
    
%% REGULARIZATION
K = 10000;
for is = 1:6
    for iv = 1:Vbins
        for iw = 1:Wbins
            for id = 1:Dbins
                if is == 4 || is ==6
                    n = (iv-1)*6 + (iw-1)*6*Vbins + (id-1)*6*Vbins*Wbins;
                    Lik = Lik - K*(exp(a1(is+n))-1).^2;
                    %LikGrad(end) = LikGrad(end) - 2*a1(end)*(exp(a1(is+n))-1).^2;
                    LikGrad(is+n) = LikGrad(is+n) - 2*K*(exp(a1(is+n))-1)*exp(a1(is+n)); 
                end
            end
        end
    end
end


Lik2 = -Lik;
LikGrad2 = -LikGrad';

