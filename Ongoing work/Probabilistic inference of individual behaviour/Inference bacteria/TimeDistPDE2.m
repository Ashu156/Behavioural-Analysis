function[Time] = TimeDistPDE2(Time,Tau,omega0,gamma0)
global NbinsX NbinsY NbinsA Tmax dt dphi
global Xhist Yhist Ahist
global aLR 

%% Summarizes statistics about the time spent in each bin using the computed 
%% solution of the coupled PDEs for the angle during the TUMBLE state
%% Assumes knowledge of microscopic transition rates. However, this information 
%% is not crucial since the result is only weakly dependent on this rate.

gamma0 = exp(aLR);
[phi,u,v] = solvePDEsystem2(pi,omega0,gamma0,Tmax,NbinsA-1); 
Time(2,:,:,:) = 0;
distform = 3;

for ind=1:round(length(Tau)) 
    [c indx] = min(abs(Xhist-Tau(1,ind))); 
    [c indy] = min(abs(Yhist-Tau(2,ind))); 
    [c indA] = min(abs(Ahist-mod(Tau(3,ind),2*pi)));    %% phibin - index of the entrance angle (pi = 11)

    %% Uniform distribution
    if distform == 1
        for iA = 1:NbinsA
            Time(2,indx,indy,iA) = Time(2,indx,indy,iA) + Tau(4,ind)/NbinsA;
        end
    end

    %% Delta function
    if distform == 2
        Time(2,indx,indy,indA) = Time(2,indx,indy,indA) + Tau(4,ind);
    end
    
    
    %% Full PDE
    if distform == 3
        uu = circshift(u',indA-ceil(NbinsA/2))';
        vv = circshift(v',indA-ceil(NbinsA/2))';
        for m = 1:floor(Tmax/dt)
           for iA = 1:NbinsA
               Time(2,indx,indy,iA) = Time(2,indx,indy,iA) + (Tau(4,ind)>(m-1)*dt)*dt*(uu(m,iA)+vv(m,iA))*dphi;
           end
        end
    end

end