function dz = ODEdz(t,z)
%% The dynamical system describing the motion of an ant dz/dt = f(t,z,state)
%% The rate of change depends on the position of the ant but also 
%% on the behavioral state Snow.
%%
%% The dynamical system also describes accumulation of the transition rate
%% necessary to obtain the next transition time. The next transition occurs 
%% when the total accumulated transition rate equals the randomly generated 
%% number from an exponential distribution.

global Snow 
global aS aU aD bS bU bD

dz = zeros(2,1);   

%% RHS of the ODE for the position z of the motion, equals 0, 1, -1 when state = STOP, UP, DOWN
dz(1) = (Snow==2)-(Snow==3); 

%% RHS of the ODE for the accumulation of the exit rate, depends on the current state and position only
%% since the same rate of exit is to all of the out states, coefficient 2 appears
dz(2) = 2*exp(aS+bS*z(1))*(Snow==1)+2*exp(aU+bU*(z(1)))*(Snow==2)+2*exp(aD+bD*(z(1)))*(Snow==3);
