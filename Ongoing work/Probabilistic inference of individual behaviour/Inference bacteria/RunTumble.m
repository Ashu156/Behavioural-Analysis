function[T,S,Z,Tdetail,Sdetail,Zdetail,L,rate,ind] = RunTumble;%(sigma,gamma,Tend)

%% simulates random transition model for bacterial chemotaxis with 2/3 states
%% xRUN, xLEFT, xRIGHT in the microscopic model
%% xRUN, xTUMBLE in the macroscopic model

global Tend plottraj plothist 
global Snow arun aLR aLrun
global z1 z2 thresh alphastar
global Xmin Xmax Ymin Ymax

Tend = 50;            % terminal time for testing PDE
plottraj = 0;           % 1 = plot trajectory, 0 = do not plot
plothist = 0;           % 1 = plot histograms

z1 = 0; z2 = 0;         % position of chemoattractant
thresh = 0;             % threshold for reaction
alphastar = 0;          % direction towards far away source 




%% simulates random transition model for ant motion with three states
%% xRUN, xLEFT, xRIGHT
%-------------> Initialize parameter values
T = 0;                      % initial time
t = 0;                      % current time
S = Snow;                   % initial state is STOP
L = 0;                      % integrated rate of transition, restarted at every transition point
rate = 0;                   
Sdetail = 0;                % S = {1,2,3} for {RUN,LET,RIGHT}
Tdetail = T;                % complete time vector, initial time for ODE solve
Zdetail = [0,10*(rand-0.5),0];% complete z(t) trajectory, setting initial position
Ldetail = L;                % cummulative rate of switching
Z = Zdetail;                % trajectory at breakpoints, setting initial position
k = 0;                      % number of updates since last generation of rv.
K = 10000;                  % Initial random vector length
numrand = rand(K,2);        % Generator of uniform random numbers
ind = [1];                  % current index
%<-------------

Xmin = -10; Xmax = 30;
Ymin = -10; Ymax = 10;

%-------------> Stochastic simulation
while t < Tend
    k = k+1;                                % next random number
    thresh = log(1/numrand(k,1));           % exponential random variable

    %% solution using ode45
    options = odeset('Events',@linevent,'RelTol',1e-4,'AbsTol',1e-3,'InitialStep',0.1,'MaxStep',0.1);
    [Ttemp,Ztemp,te,ze,ie] = ode45(@ODEdz_bacteria,[0 1000],[Z(end,1:3),0],options);
    
    T = [T,te+T(end)];                          % stores the transition time
    t = T(end);                                 % updates the current time
    Z = [Z;ze(1:3)];                            % updates the transition vector z1,z2,alpha
    L = [L;ze(4)];                              % updates the cummulative transition rate
    Tdetail = [Tdetail,Tdetail(end) + Ttemp'];  % appends the detailed time
    Zdetail = [Zdetail;Ztemp(:,1:3)];           % appends the detailed trajectory
    Ldetail = [Ldetail;Ztemp(:,4)];             % appends the integrated cummulative rate of switching
    ind = [ind,length(Zdetail(:,1))];           % appends the index of transition vector
    
    Snow = rand_pick(Snow,numrand(k,2),Z(end,:));               % random transition to a new state w/p 1/2
    S = [S,Snow];                                               % adds a new state to the total vector of states
    Sdetail = [Sdetail,S(end-1)*ones(1,length(Ztemp(:,1)))];    % adds a vector of old states to the detailed data
 
     
    rate_temp = 2*exp(arun)*(S(end-1)==1)+(exp(aLR) + exp(aLrun))*(S(end-1)==2)+(exp(aLR) + exp(aLrun))*(S(end-1)==3); % rate of exit from the current state
    rate = [rate,rate_temp']; 

    if k > K-2                                  % generate new random variables
        numrand = rand(K,2);
        k = 1;
    end
    
    if (Z(end,1) > Xmax) || (Z(end,1) < Xmin) || (Z(end,2) > Ymax) || (Z(end,2) < Ymin)     % Stopping condition
        break;
    end


end
%<-------------

%-------------> Plotting the results (when plottraj=1)
if plottraj == 1
    figure(4)
    lw=1;  
    %clf; 
    hold on;  
    set(gca,'fontsize',16)
    plot(Z(:,1),Z(:,2),'-k','linewidth',lw,'color',[0,0,0]); xlim([0,Tend]); hold on
    xlim([min(Z(:,1)'),max(Z(:,1)')]);
    ylim([min(Z(:,2)'),max(Z(:,2)')]);
    axis equal
    xlim([Xmin-2,Xmax+2]); ylim([Ymin-2,Ymax+2])
    box on
    line([0,0],[-10,10],'linewidth',2,'color',[0.6,0.3,0.3])
 
end
%<-------------