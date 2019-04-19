%% in case of more ants we infer the parameters directly from the trajectory and this way to resolve
%% the problem of many-dimensional statistics. This is done here but one needs to consider that very long 
%% trajectories are difficult to optimize since the log-likelihood has to be evaluated many times on 
%% this large data
clear

%% LOAD VARIABLES
global Ants Tend aS aU aD bS bU bD beta aexact
global Nbins Zhist dZhist 
global T S Z Tdetail Sdetail Zdetail Tall Sall Zall ant nant
global trajs a k
global iplot

addpath('C:/Users/Dell/Documents/MATLAB/minFunc_2012')
addpath('C:/Users/Dell/Documents/MATLAB/minFunc_2012')
addpath('C:/Users/Dell/Documents/MATLAB/minFunc_2012/minFunc')
addpath('C:/Users/Dell/Documents/MATLAB/minFunc_2012/minFunc/compiled')
addpath('C:/Users/Dell/Documents/MATLAB/minFunc_2012/minFunc/mex')

Ants = 5;
iplot = 1;
Tend = 50;             % terminal time
aS = log(0.4)*ones(1,Ants);          % constant coef. of STOP
aU = log(0.25)*ones(1,Ants);         % constant coef. of UP
aD = log(0.25)*ones(1,Ants);         % constant coef. of DOWN
bS = 0*ones(1,Ants);                 % linear coef. of STOP
bU = 0.7*ones(1,Ants);               % linear coef. of UP
bD = -0.7*ones(1,Ants);              % linear coef. of DOWN
beta = 0.5*ones(1,Ants);               % interaction
repeat = 1;
ttotal = 0;
trajs = 1; %% if inference from trajectories

%% LOADING DATA/RUNNING SIMULATION
tm = cputime;
[Tdetail,Sdetail,Zdetail,L,rate,indall,k,Tall,Sall,Zall] = KMC_Nants;
fprintf(1,'\n\nSimulation %d of length %d complete\n',i,Tend)

%% INFERENCE OF COEFFICIENTS
ant = 1; nant = 2;
T = Tall(ant,1:k(ant));
S = Sall((ant-1)*Ants+1:ant*Ants,1:k(ant));
Z = Zall((ant-1)*Ants+1:ant*Ants,1:k(ant));
    
maxFunEvals = 1000;    
options.MaxIter = 1000;
options = [];
options.GradObj = 'on';
options.Display = 'iter';
options.useMex = 0;
options.maxFunEvals = maxFunEvals;
options.Method = 'lbfgs';

Nbins = 31;
Zhist = linspace(-4,4,Nbins+1);
Zhist = (Zhist(1:end-1)+Zhist(2:end))/2;
dZhist = linspace(-5,5,Nbins+1);
dZhist = (dZhist(1:end-1)+dZhist(2:end))/2;

%% inference from the trajectory
a = ones(1,12*Nbins)'; 
C = clock; fprintf(1,'\nTime:  %1.0f:%1.0f:%1.0f\n',C(4),C(5),C(6))
aexact = [exp(aS(ant)+bS(ant)*Zhist);exp(aS(ant)+bS(ant)*Zhist);exp(aU(ant)+bU(ant)*Zhist);exp(aU(ant)+bU(ant)*Zhist);exp(aD(ant)+bD(ant)*Zhist);exp(aD(ant)+bD(ant)*Zhist);exp(beta(ant)*exp(-dZhist.^2));exp(beta(ant)*exp(-dZhist.^2));exp(beta(ant)*exp(-dZhist.^2));exp(beta(ant)*exp(-dZhist.^2));exp(beta(ant)*exp(-dZhist.^2));exp(beta(ant)*exp(-dZhist.^2))];
a = ones(1,12*Nbins)'; 
a2 = minFunc(@likelihood_trajectory, reshape(a,12*Nbins,1), options);
a = reshape(a2,Nbins,12)';
plot_inferredN_trajectory(1)

C = clock; fprintf(1,'\nTime:  %1.0f:%1.0f:%1.0f\n',C(4),C(5),C(6))
