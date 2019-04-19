function dz = ODEdzN(t,z)

global Snow aS aU aD bS bU bD Ants beta trajs
%% trajs = 1 if inference from trajectories not from summary statistics

dz = zeros(2*Ants,1);   

%% RHS of the ODE for the position z of the motion, equals 0, 1, -1 when state = STOP, UP, DOWN
for i=1:Ants
    dz(i) = (Snow(i)==2)-(Snow(i)==3); 

    %% RHS of the ODE for the accumulation of the exiting rate, depends on the current state and position only
    %% since the same rate of exit is to all of the out states, coefficient 2 appears
    dz(i+Ants) = 2*exp(aS(i)+bS(i)*z(i))*(Snow(i)==1)+2*exp(aU(i)+bU(i)*(z(i)))*(Snow(i)==2)+2*exp(aD(i)+bD(i)*(z(i)))*(Snow(i)==3);

    if trajs == 1
        D = 1;
        for j=1:Ants
           if i~=j 
           D = D*exp(beta(i)*exp(-(z(i)-z(j))^2));
           end
        end
        dz(i+Ants) = dz(i+Ants)*D;
    else
        dz(i+Ants) = dz(i+Ants)*exp(beta(i)*exp(-(z(2)-z(1))^2));
    end
end