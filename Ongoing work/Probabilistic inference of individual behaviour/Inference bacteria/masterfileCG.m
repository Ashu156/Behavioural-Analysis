%% ----------------------------------------------------------------
%% BACTERIAL CHEMOTAXIS, BASIC AND COARSE-GRAINED MODEL
%%  The detailed model of bacterial chemotaxis has three behavioral states: 
%%      R = run
%%      TL = tumble left
%%      TR = tumble right
%%  The coarse-grained model has just two macroscopic states:
%%      R = run
%%      T = tumble
%%
%%  This routine generates many trajectories that all start at the initial condition x=0, 
%%  with a randomly chosen y in the interval [-10,10]. Then it infers the transition rates 
%%  from these trajectories using two models: the microscopic model with all three deterministic
%%  states R,TL,TR, and the coarse-grained macroscopic model with observable states R, T.
%%
%%  To get a good resolution take ~10000 repeats
%% -----------------------------------------------------------------



clear; clc
global NbinsX NbinsY NbinsA Tmax 
global TIME TRANSITIONS TAU Time Transitions Tau 
global TRANSITIONS2 TIME2 
global T S Z Tdetail Sdetail Zdetail Snow
global TCG SCG ZCG TdetailCG SdetailCG ZdetailCG
global omega gamma aLR arun aLrun ag v
global a aCG macro

%-------------> BACTERIA: states: 1=run, 2=left, 3=right
Tmax = 20;
Snow = round(rand)+2;           % current state of the bacteria
v = 2;                          % velocity of the bacteria
omega = 1;                      % angular velocity
arun = log(0.3);                % constant coef. of RUN
aLR = log(0.3);                 % constant coef. of LEFT
gamma = exp(aLR);
aLrun = log(0.3);               % constant coef. of RIGHT
ag = 3;                         % effect of proximity to the chemoattractant (if close by)
%<-------------

% w = warning('query','last'); id=w.identifier; warning('off',id)
repeat = 100;
test1 = 0;
define_grid;


TIME = zeros(2,NbinsX,NbinsY,NbinsA);           % summary statistics in the macro model
TRANSITIONS = zeros(2,NbinsX,NbinsY,NbinsA);
TAU = [];

TIME2 = zeros(3,NbinsX,NbinsY,NbinsA);          % summary statistics in the micro model
TRANSITIONS2 = zeros(6,NbinsX,NbinsY,NbinsA);

%-------------> Stochastic simulation
for i=1:repeat
    fprintf(1,'\nTrajectory %d of %d',i,repeat)
    [T,S,Z,Tdetail,Sdetail,Zdetail,L,rate,ind] = RunTumble;
    [TCG,SCG,ZCG,TdetailCG,SdetailCG,ZdetailCG] = coarse_grain(T,S,Z,Tdetail,Sdetail,Zdetail);

    % Summaru statistics under the coarse-grained model
    [Time1,Transitions1,Tau1] = summary_histogramsRT_CG(TCG,SCG,ZCG,TdetailCG,SdetailCG,ZdetailCG);
    TRANSITIONS = TRANSITIONS + Transitions1; 
    TIME = TIME + Time1; 
    TAU = [TAU,Tau1]; %% first component: entrance angle / second component: duration

    % Summary statistics under the full model
    [Time2,Transitions2] = summary_histogramsRT(T,S,Z,Tdetail,Sdetail,Zdetail);
    TRANSITIONS2 = TRANSITIONS2 + Transitions2; TIME2 = TIME2 + Time2; 
end

%-------------> Inference in the coarse-grained model: 
macro = 1;
Time = TIME;
Transitions = TRANSITIONS;
Tau = TAU;
[Time] = TimeDistPDE2(Time,Tau,omega,gamma);    % obtain the time occupation in the coarse-grained model
inferenceRT_CG2;                                % infer the macroscopic parameter values given the knowledge of microrates
aCG = a;
plot_inferredCG(aCG,0);                         % plot the inferred rates
% for simplicity we assume that the microrates are known, the result is
% minimally sensitive to their value

%-------------> Inference in the full model: 
macro = 0;
Time = TIME2;
Transitions = TRANSITIONS2;
Tm = [Time(1,:,:,:);Time(2,:,:,:)+Time(3,:,:,:)];
inferenceRT;                                    % infer the transition rates
plot_inferred;                                  % plot the inferred rates
