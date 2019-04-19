function[T,S,Z,Tdetail,Sdetail,Zdetail,L,rate,ind] = KMC_ant;

%% simulates random transition model for ant motion with three states
%% xUP, xDOWN, xSTOP
%% Tend - terminal time
%% T - stores state transition times
%% S - stores states of the system
%% TZ - stores times at which the position has been evaluated
%% Z - stores positions at times TZ
%% color coding: S = gray, D = red, U = blue


global Snow                 % current state of the ant
global iplot                % 1 if plotting the trajectories
global aS aU aD bS bU bD    % parameters of the transition rates
global thresh               % threshold to set the time of next transition
global Tend                 % terminal time 

thresh = 0;             % threshold to set the time of next transition
                        % transition occurs when the accumulated transition
                        % rates equal thresh.

%-------------> Initialize parameter values
T = 0;                  % initial time
t = 0;                  % current time
S = [Snow];             % initial state is STOP
L = 0;                  % integrated rate of transition, restarted at every transition point
rate = [0];             % current transition rate
Sdetail = Snow;         % S = {1,2,3} for {STOP,UP,DOWN}
Tdetail = [0];          % complete time vector, initial time for ODE solve
Zdetail = [0];          % complete z(t) trajectory, setting initial position
Ldetail = [0];          % cummulative rate of switching
Z = 0;                  % trajectory at breakpoints, setting initial position
k = 0;                  % number of updates since last generation of rv.
K = 10000;              % Initial random vector length
numrand = rand(K,2);    % Generator of uniform random numbers
ind = [1];              % current index
dt = 0.1;               % initial time step of the integration


%-------------> Stochastic simulation
while t < Tend
    k = k+1;                               % next random number
    thresh = log(1/numrand(k,1));          % exponential random variable
    %if mod(floor(t),1000)==0 fprintf(1,'\n\n\n%1.0f, ',t); end
    
    % solution of the laws of motion using ode45
    % computes until the terminal condition is met - when the total
    % accumulated rate equals thresh
    options = odeset('Events',@linevent,'RelTol',1e-4,'AbsTol',1e-3,'InitialStep',dt,'MaxStep',0.05);
    [Ttemp,Ztemp,te,ze,ie] = ode45(@ODEdz,[0 20],[Zdetail(end) 0],options);
     
    % updating the variables
    T = [T,te+T(end)];                                  % stores the transition time
    t = T(end);                                         % updates the current time
    Z = [Z,ze(1)];                                      % updates the transition position
    L = [L,ze(2)];                                      % updates the cummulative transition rate
    Tdetail = [Tdetail,Tdetail(end) + Ttemp(1:end)'];   % appends the detailed time
    Zdetail = [Zdetail,Ztemp(1:end,1)'];                % appends the detailed trajectory
    Ldetail = [Ldetail,Ztemp(1:end,2)'];                % appends the integrated cummulative rate of switching
    ind = [ind,length(Zdetail)];                        % appends the index of transition vector
    
    Snow = rand_pick(Snow,numrand(k,2));                % random transition to a new state w/p 1/2
    S = [S,Snow];                                       % adds a new state to the total vector of states
    Sdetail = [Sdetail,S(end-1)*ones(1,length(Ztemp(:,1)))];  % adds a vector of old states to the detailed data
    rate_temp = exp(aS+bS*Ztemp(1:end,1))*(S(end-1)==1)+exp(aU+bU*Ztemp(1:end,1))*(S(end-1)==2)+exp(aD+bD*Ztemp(1:end,1))*(S(end-1)==3); % rate of exit from the current state
    rate = [rate,rate_temp'];

    if k > K-2 % generate new random variables when none left
        numrand = rand(K,2);
        k = 1;
        %fprintf(1,'\n\nTime = %1.2f',t)
    end
end
%<-------------

%-------------> Plotting the results (when iplot=1)

if iplot == 1
  figure(1); clf
  subplot(2,3,[2,3]); % plot the accumulated transition rates
  set(gca,'fontsize',16)
  for i=1:length(ind)-1
      area(Tdetail(ind(i):ind(i+1)),rate(ind(i):ind(i+1)),'facecolor',Scolor(Sdetail(ind(i)+1))); %[1,Sdetail(ind(i)+1)/3,0]
      hold on
      xlim([0,Tend]); ylim([0,2])
  end
  xlabel('time'); ylabel('mc rate')
  
  subplot(2,3,[5,6]); % plot the trajectory
  set(gca,'fontsize',16)
  plot(Tdetail,Zdetail,'-k','linewidth',1); xlim([0,Tend]); hold on
  plot([0,Tend],[0,0],'k--','linewidth',1); 
  for i=1:length(ind)-1
      %plot(T(i),Z(i),'o','linewidth',2,'markersize',2,'color',Scolor(Sdetail(ind(i)+1)));
      plot(Tdetail(ind(i):ind(i+1)),Zdetail(ind(i):ind(i+1)),'color',Scolor(Sdetail(ind(i)+1)),'linewidth',2)
  end
  hold off
  ylim([-4,4])
  xlabel('time'); ylabel('ode state (z)')
  
  subplot(2,3,4) % plot the exact rates of transition
  set(gca,'fontsize',16)
  plot([-4:0.05:4],exp(aU+bU*[-4:0.05:4]),'--','linewidth',2,'color','b'); hold on
  plot([-4:0.05:4],exp(aD+bD*[-4:0.05:4]),':','linewidth',2,'color','r')
  plot([-4:0.05:4],exp(aS+bS*[-4:0.05:4]),'linewidth',2,'color',[0.5,0.5,0.5])
  %plot([-4,4],[exp(aS),exp(aS)],'k','linewidth',1)
  ylim([0,2.5]); xlim([-4,4])
end
%<-------------