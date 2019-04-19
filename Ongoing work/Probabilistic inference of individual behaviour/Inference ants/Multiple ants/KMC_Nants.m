function[Tdetail,Sdetail,Zdetail,L,rate,indall,k,Tall,Sall,Zall] = KMC_Nants;

global Ants Snow 
global aS aU aD bS bU bD beta 
global thresh Tend iplot

%-------------> Initialize parameter values
T = 0;                              % initial time
Snow = ones(Ants,1);                %floor(3*rand(Ants,1)+1); 
S = Snow;                           % initial state is STOP
Zdetail = zeros(1,Ants)';           %rand(1,Ants)';             % complete z(t) trajectory, setting initial position
Z = Zdetail;                        % trajectory at breakpoints, setting initial position
L = 0*ones(1,Ants)';                % integrated rate of transition, restarted at every transition point
Sdetail = Snow;                     % S = {1,2,3} for {STOP,UP,DOWN}
Tdetail = T;                        % complete time vector, initial time for ODE solve
Ldetail = L;                        % cummulative rate of switching
thresh = 0*ones(1,Ants);            % threshold for rate integration


initcond = [Z; zeros(Ants,1)];          % initial condition for the integration
thresh = log(1./(0.5*rand(1,Ants)))' ;  %log(1./rand(1,Ants))' ;         % exponential random variable
t = 0;                                  % current time
rate_own = 0*ones(1,Ants)';             % self-interaction
rate_int = 0*ones(1,Ants)';             % cross-interaction
k = 0*ones(1,Ants)';                    %vector of updates for each ant
K = 100000;                              % Initial random vector length
AntIndex = [];                          %ant changing state
k = k+1;
numrand = rand(K,2*Ants);               % Generator of uniform random numbers
indtotal = [1];                         % current index
indall = [ones(Ants,1),zeros(Ants,10000)]; % indices for all ants

D=10000;
Tall = zeros(Ants,D);                   % each row corresponds to one ant and captures transition times
Sall = []; sall = [Snow,zeros(Ants,D-1)]; % each Ants rows capture states of all ants given only transitions of the considered ant (reduced transitions)
for i=1:Ants
    Sall = [Sall;sall];
end
Zall = [zeros(Ants*Ants,D)];            % Ants x Ants rows, each cluster corresponds to the transitions conditioned of the considered ant only
P=1;
%fprintf(1,'\n(Transition,Current time,Current state) = (%d,%1.3f,%d,%d)',k(1)-1,t,S(1,end),S(2,end))


%-------------> Stochastic simulation
while t < Tend  
    if t>100*P
        fprintf(1,'\nTime = %1.2f',100*P)
        P = P+1;
    end
    %fprintf(1,'\n%s ',strjoin(cellstr(num2str(S(:))),', '))
    options = odeset('Events',@lineventN,'RelTol',1e-4,'AbsTol',1e-3,'InitialStep',0.01,'MaxStep',0.1);
    [Ttemp,Ztemp,te,ze,ie] = ode45(@ODEdzN,[0 30],initcond,options);
    initcond = ze';    

    [cval antIndex] = min(thresh-ze(Ants+1:end)');              % which ant hit the threshold
    Snow = rand_pickN(Snow,antIndex,numrand(k(antIndex)+1,Ants + antIndex),Zall(:,end));
    Sdetail = [Sdetail,S(:,end)*ones(1,length(Ztemp(:,1))-1)];  % adds a vector of old states to the detailed data
    S = [S,Snow];                                               % adds a new state to the total vector of states
    T = [T,te+T(end)];                                          % stores the transition time
    t = T(end);                                                 % updates the current time
    Z = [Z,ze(1:Ants)'];                                        % updates the transition position
    L = [L,ze(Ants+1:end)'];                                    % updates the cummulative transition rate
    %fprintf(1,'\n(te,Tend)=(%1.3f,%1.3f)',te,T(end))

    Tdetail = [Tdetail,Tdetail(end) + Ttemp(2:end)'];           % appends the detailed time
    Zdetail = [Zdetail,Ztemp(2:end,1:Ants)'];                   % appends the detailed trajectory
    Ldetail = [Ldetail,Ztemp(2:end,Ants+1:end)'];               % appends the integrated cummulative rate of switching
    indtotal = [indtotal,length(Zdetail)];                      % appends the index of transition vector
    k(antIndex) = k(antIndex)+1;                                % = which random number will be used next = number of past reactions+1
    indall(antIndex,k(antIndex)) = length(Zdetail); 
    
    Tall(antIndex,k(antIndex)) = t;
    Sall((antIndex-1)*Ants+1:Ants*antIndex,k(antIndex)) = Snow;
    Zall((antIndex-1)*Ants+1:Ants*antIndex,k(antIndex)) = ze(1:Ants)';
    
    initcond(Ants + antIndex) = 0;                              % restart the rate at zero
    thresh(antIndex) = log(1/numrand(k(antIndex),antIndex));    % update the threshold for the ant that hit the threshold

    %fprintf(1,'\n(Transition,Current time,Current state) = (%d,%1.3f,%d,%d)',k(1)-1,t,S(1,end),S(2,end))
    %if k > K-5                                                  % generate new random variables
    %    numrand = rand(K,2);
    %    k = 1;
    %    %fprintf(1,'\n\nTime = %1.2f',t)
    %end
end

rate = zeros(Ants,length(Zdetail(1,:))-1);
for i=1:Ants
    for j=1:length(Zdetail(1,:))
        rate(i,j) = exp(aS(i)+bS(i)*Zdetail(i,j))*(Sdetail(i,j)==1)+exp(aU(i)+bU(i)*Zdetail(i,j))*(Sdetail(i,j)==2)+exp(aD(i)+bD(i)*Zdetail(i,j))*(Sdetail(i,j)==3); % rate of exit from the current state
   end
end
%<-------------

%-------------> Plotting the results (when iplot=1)
% 
if iplot == 1
  figure(Ants); clf
   
for traj=1:Ants
  subplot(Ants+1,3,[(traj-1)*3+2,(traj-1)*3+3]); 
  set(gca,'fontsize',16)
 
  for i=1:length(indtotal)-1
      area(Tdetail(1,indtotal(i)+1:indtotal(i+1)),rate(traj,indtotal(i)+1:indtotal(i+1)),'facecolor',Scolor(Sdetail(traj,indtotal(i)+1))); 
      hold on
      xlim([0,Tend]); ylim([0,2])
  end
 end
  
  subplot(Ants+1,3,3*Ants+1); hold on
  set(gca,'fontsize',16)
  plot([-4:0.05:4],exp(aU(1)+bU(1)*[-4:0.05:4]),'--','linewidth',2,'color','b'); hold on
  plot([-4:0.05:4],exp(aD(1)+bD(1)*[-4:0.05:4]),':','linewidth',2,'color','r')
  plot([-4:0.05:4],exp(aS(1)+bS(1)*[-4:0.05:4]),'linewidth',2,'color',[0.5,0.5,0.5])
  plot([-4:0.05:4],exp(beta(1)*exp(-([-4:0.05:4]).^2)),'linewidth',2,'color',[0.5,1,0.5])
  ylim([0,2.5]); xlim([-4,4])
  
  subplot(Ants+1,3,[3*Ants+2,3*Ants+3]); hold on
  set(gca,'fontsize',16)

  
 for traj=1:Ants
      for i=1:length(indtotal)-1
          plot(Tdetail(1,indtotal(i)+1:indtotal(i+1)),Zdetail(traj,indtotal(i)+1:indtotal(i+1)),'color',Scolor(Sdetail(traj,indtotal(i)+1)),'linewidth',2)
      end
 end
  
  hold off
  ylim([-4,4]); xlim([0,Tend])
  xlabel('time'); ylabel('ode state (z)')
  
end
