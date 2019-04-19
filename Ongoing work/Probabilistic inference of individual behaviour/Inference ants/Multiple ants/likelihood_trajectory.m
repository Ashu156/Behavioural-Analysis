%% computes the likelihood function of the trajectory for the focal ant
%% with id ant relative to the non-focal ant with id nant

function [Lik2,LikGrad2] = likelihood_trajectory(a1)
global Zhist dZhist Nbins ant Ants
global Tdetail Sdetail Zdetail
global Tall Sall Zall k


a2 = reshape(a1,Nbins,12)';

alph = a2(1:6,:); bet = a2(7:12,:);

Lik = 0;
LikGrad = zeros(12,Nbins);


for ant = 1:Ants
    % ant -- reference ant
    nAnts = [1:1:Ants]; nAnts(ant) = [];
    %t = cputime;

    T = Tall(ant,1:k(ant));
    S = Sall((ant-1)*Ants+1:ant*Ants,1:k(ant));
    Z = Zall((ant-1)*Ants+1:ant*Ants,1:k(ant));


    for i=1:floor(length(S))-1
        [c1 ind(1)] = min(abs(Zhist-Z(ant,i+1)));
        for j = 1:Ants-1
            [c2 ind(j+1)] = min(abs(dZhist-(Z(nAnts(j),i+1)-Z(ant,i+1)) ));
        end
        if     (S(ant,i) == 1 & S(ant,i+1) == 2) r1 = 1;
        elseif (S(ant,i) == 1 & S(ant,i+1) == 3) r1 = 2;
        elseif (S(ant,i) == 2 & S(ant,i+1) == 1) r1 = 3;
        elseif (S(ant,i) == 2 & S(ant,i+1) == 3) r1 = 4;
        elseif (S(ant,i) == 3 & S(ant,i+1) == 1) r1 = 5;
        elseif (S(ant,i) == 3 & S(ant,i+1) == 2) r1 = 6;
        end

        Lik = Lik + alph(r1,ind(1));
        LikGrad(r1,ind(1)) = LikGrad(r1,ind(1)) + 1;
        for j = 1:Ants-1
            Lik = Lik + bet(r1 ,ind(j+1));
            LikGrad(6+r1,ind(j+1)) = LikGrad(6+r1,ind(j+1)) + 1;
        end

    end

    %cputime-t
    %t = cputime;

    for i=2:floor(length(Zdetail))
        [c1 ind(1)] = min(abs(Zhist-Zdetail(ant,i)));
        for j = 1:Ants-1
            %[c2 ind(j+1)] = min(abs(dZhist-(Zdetail(nAnts(j),i-1)-Zdetail(ant,i)) )); % check the first index!!!
            [c2 ind(j+1)] = min(abs(dZhist-(Zdetail(nAnts(j),i)-Zdetail(ant,i)) )); % check the first index!!!
        end

        if Sdetail(ant,i) == 1 r1 = 1; r2 = 2; 
        elseif Sdetail(ant,i) == 2 r1 = 3; r2 = 4; 
        elseif Sdetail(ant,i) == 3 r1 = 5; r2 = 6; 
        end
        uu=0; vv=0;
        for j = 1:Ants-1
            uu = uu + bet(r1 ,ind(j+1));
            vv = vv + bet(r2 ,ind(j+1));
        end
        u = exp(alph(r1,ind(1)) + uu); 
        v = exp(alph(r2,ind(1)) + vv);

        Lik = Lik - (u+v)*(Tdetail(i)-Tdetail(i-1)); 
        LikGrad(r1,ind(1)) = LikGrad(r1,ind(1)) - u*(Tdetail(i)-Tdetail(i-1)); 
        LikGrad(r2,ind(1)) = LikGrad(r2,ind(1)) - v*(Tdetail(i)-Tdetail(i-1));     

        for j = 1:Ants-1
            LikGrad(6+r1,ind(j+1)) = LikGrad(6+r1,ind(j+1)) - u*(Tdetail(i)-Tdetail(i-1));
            LikGrad(6+r2,ind(j+1)) = LikGrad(6+r2,ind(j+1)) - v*(Tdetail(i)-Tdetail(i-1));
        end

    end



    %penalization for nonzero entries
    delta = 1000;
    for idz=1:Nbins
        for state=7:12
            if abs(dZhist(idz))>2
                Lik = Lik - delta*(sum(sum((exp(a2(state,idz))-1).^2)))/Nbins;
            end
        end
    end
    for idz=1:Nbins
        for state = 7:12
            if abs(dZhist(idz))>2
                LikGrad(state,idz) = LikGrad(state,idz) - 2*delta*exp(a2(state,idz))*(exp(a2(state,idz))-1)/Nbins; 
            end
        end
    end
end
 
Lik2 = -Lik;
LikGrad = reshape(LikGrad',1,12*Nbins);
LikGrad2 = -LikGrad';

%cputime-t



