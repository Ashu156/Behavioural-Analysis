%% ----------------------------------------------------------------
%% SINGLE ANT ON THE LINE
%%  The ant is modeled using three behavioral states: 
%%      S = stop
%%      U = up
%%      D = down
%%  Transitions between these states are functions of the position.
%%  Namely: 
%%      lambda(S->*) = exp[aS+bS*z]
%%      lambda(U->*) = exp[aU+bU*z]
%%      lambda(D->*) = exp[aD+bD*z]
%%
%%  To plot the stochastic trajectories choose repeat = 1, iplot = 1
%%  and Tend not too large (Tend~100)
%%
%%  To get enough data for a good result use Tend = 500, repeat = 100-500
%%  and set iplot = 0
%% -----------------------------------------------------------------

clear; clc;
global Nbins Zhist 
global Tend
global NSU NSD NUS NUD NDS NDU 
global TimeS TimeU TimeD
global aS aU aD bS bU bD
global iplot Snow
global infer

%-------------> Defining the spatial bins
Nbins = 31;                                 % Number of bins in the state space
Zhist = linspace(-4,4,Nbins+1);             % State space vector
Zhist = (Zhist(1:end-1)+Zhist(2:end))/2;    % State space vector

%w = warning('query','last'); id=w.identifier; warning('off',id)

%-------------> Defining simulation parameters
repeat = 1;         % It is more efficient to generate more trajectories 
                    % that are shorter and compute the cummulative statistics
                    % on the go than to generate one long trajectory
ttotal = 0;         % Monitors the total time of this computation

%-------------> Simulation parameters
Tend = 500;             % terminal time
iplot = 1;              % 1 if plotting the trajectories (do not use for long simulations!)
Snow = 1;               % initial state (1=S, 2=U, 3=D)
aS = log(0.4);          % constant coef. of STOP
aU = log(0.25);         % constant coef. of UP
aD = log(0.25);         % constant coef. of DOWN
bS = 0;                 % linear coef. of STOP
bU = 0.7;               % linear coef. of UP
bD = -0.7;              % linear coef. of DOWN

%-------------> Defining arrays
NSUt = zeros(1,Nbins); NSU = zeros(1,Nbins);    % Number of transitions between states
NSDt = zeros(1,Nbins); NSD = zeros(1,Nbins);    % S=stop, D=down, U=up
NUSt = zeros(1,Nbins); NUS = zeros(1,Nbins);    % For example: NSU = number of transitions S->U
NUDt = zeros(1,Nbins); NUD = zeros(1,Nbins);    % NSUt = temporary total number of transitions S->U 
NDSt = zeros(1,Nbins); NDS = zeros(1,Nbins);    % summed through repeats
NDUt = zeros(1,Nbins); NDU = zeros(1,Nbins);

TimeSt = zeros(1,Nbins)'; TimeS = zeros(1,Nbins)';  % Total time spent st the state S, U, D
TimeUt = zeros(1,Nbins)'; TimeU = zeros(1,Nbins)';  % TimeS = time spent in S in the current repeat
TimeDt = zeros(1,Nbins)'; TimeD = zeros(1,Nbins)';  % TimeSt = temporary total time spent in S (summed through repeats)

%-------------> Stochastic simulation & obtaining cummulative statistics
% The simulation is split into "repeat" steps, each of duration "Tend"
for i=1:repeat
    t = cputime;
    [T,S,Z,Tdetail,Sdetail,Zdetail,L,rate,ind] = KMC_ant;   % Run the stochastic simulation
    fprintf(1,'\n\nSimulation %d of length %d complete',i,Tend)
    [NSU, NSD, NUS, NUD, NDS, NDU, TimeS, TimeU, TimeD] = summary_statistics(T,S,Z,Tdetail,Sdetail,Zdetail); % compute the cummulative statistics

    NSUt = NSUt + NSU; NSDt = NSDt + NSD;   % Update the transition counts
    NUSt = NUSt + NUS; NUDt = NUDt + NUD; 
    NDSt = NDSt + NDS; NDUt = NDUt + NDU;
    TimeSt = TimeSt + TimeS;                % Update the times spent in the states
    TimeUt = TimeUt + TimeU; 
    TimeDt = TimeDt + TimeD;

    ttotal = ttotal + cputime-t;            % Update the simulation duration
    fprintf(1,'\nSummary completed, data appended:  %1.2f,  total time = %1.2f',cputime-t,ttotal)
end

%-------------> Assigning the cummulative statistics 
NSU = NSUt; NSD = NSDt; 
NUS = NUSt; NDS = NDSt; 
NDU = NDUt; NUD = NUDt; 

TimeS = TimeSt; 
TimeU = TimeUt; 
TimeD = TimeDt;

%-------------> Inference of transition rates
infer = 2;              % 1=inference separately for each bin
                        % 2=inference together for all bins (answer should be the same)
infer_1ant;             % Inferrence 
plot_infer_1ant(2,3);   % Plotting the results
