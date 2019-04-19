clc;
clear;
format shortg

global dataset redef
global dt a a2
global Vbins Wbins Dbins
global Vhist Whist Dhist
global Transitions Time
global TransitionsV TimeV TransitionsW TimeW TransitionsD TimeD
global TransitionsVW TimeVW TransitionsVD TimeVD TransitionsWD TimeWD
global TransitionsVWD TimeVWD
global Wcrude

%% OPTIMIZATION PACKAGES
addpath('C:/Dell/Documents/MATLAB/minFunc_2012')
addpath('C:/Dell/Documents/MATLAB/minFunc_2012')
addpath('C:/Dell/Documents/MATLAB/minFunc_2012/minFunc')
addpath('C:/Dell/Documents/MATLAB/minFunc_2012/minFunc/compiled')
addpath('C:/Dell/Documents/MATLAB/minFunc_2012/minFunc/mex')

%% OPTIMIZATION SPECIFICATION
maxFunEvals = 5000;    
options.MaxIter = 5000;
options = [];
options.GradObj = 'on';
options.Display = 'off';
options.useMex = 0;
options.maxFunEvals = maxFunEvals;
options.Method = 'lbfgs';
options.MaxIter = 5000;

%% INFERENCE OF COEFFICIENTS FROM THE FULL TRAJECTORY
dt = 0.01;
LogLikVWD = [];
LogLikV = []; LogLikW = []; LogLikD = [];
LogLikVW = []; LogLikVD = []; LogLikWD = [];


%% SETS THE MODEL VARIABLES
redef = 2;      %% 0 - distance between the fish
                %% 1 - distance if in the front, 0 if in the back
                %% 2 - adds a sign due to alignment
                %% 3 - if in the front + adds a sign due to alignment
                
                
%% SETS THE INFERENCES THAT ARE TO BE DONE
opt = 2; 
    %% options: 
    %% 1 - VWD
    %% 2,3,4 - VW, VD, WD
    %% 5,6,7 - V, W, D
    
Wcrude = 1; %% if 1 then clusters wall distance into three bins like before
    

%% Gridspace
Vhist = [1,3,5,7]; Vbins = length(Vhist); %% [1,3,5,7]
Whist = [-1,1,2]; Wbins = length(Whist); %% [-1,1] or [-10,0,10] %% redefined in summary statistics!!!
Dhist = [-3,-1,1,3]; Dbins = length(Dhist); %% when redef = 2,3 in inference_input


%% READ DATASETS
dataset = 2; 
inference_input; %c = clock; fprintf(1,'\n%d hrs, %d min, %1.0f sec,  \nData %d loaded',c(4),c(5),c(6),dataset)
DATA1_set2 = DATA1; ADATA1_set2 = ADATA1;
DATA2_set2 = DATA2; ADATA2_set2 = ADATA2;
    
dataset = 3; 
inference_input; 
fprintf(1,'\nData %d loaded, elapsed time = ',dataset);
DATA1_set3 = DATA1; ADATA1_set3 = ADATA1;
DATA2_set3 = DATA2; ADATA2_set3 = ADATA2;



for samples = 1:1
    %% TIME MONITORING
    %fprintf(1,'\nIteration %d, ',samples);
    c = clock; fprintf(1,'Time: %d hrs, %d min, %1.0f sec',c(4),c(5),c(6))
       
    %% PARAMETERS OF TRAINING/TESTING SETS
    P = 1000;                       %% size of the basic data segment used for splitting the data into the 
                                    %% training and testing set
    LP = ceil(S(2)/P);              %% number of segments
    TrainVec = round(rand(1,LP));   %% i-th element is 1 if the (i-1)*P:i*P components of the trajectory
    %TrainVec = (rand(1,LP)>0.2);   %% go into the training set, 0 if in the testing set

    %% INITIALIZATION OF FIELDS
    TransitionsVWD = zeros(6,Vbins,Wbins,Dbins);    TimeVWD = zeros(3,Vbins,Wbins,Dbins); 
    TransitionsVW = zeros(6,Vbins,Wbins);     TimeVW = zeros(3,Vbins,Wbins); 
    TransitionsVD = zeros(6,Vbins,Dbins);    TimeVD = zeros(3,Vbins,Dbins); 
    TransitionsWD = zeros(6,Wbins,Dbins);     TimeWD = zeros(3,Wbins,Dbins); 
    TransitionsV = zeros(6,Vbins);    TimeV = zeros(3,Vbins); 
    TransitionsW = zeros(6,Wbins);     TimeW = zeros(3,Wbins); 
    TransitionsD = zeros(6,Dbins);     TimeD = zeros(3,Dbins); 

    %% SUMMARIZING DATASETS 2,3 for both fish
        DATA1 = DATA1_set2; ADATA1 = ADATA1_set2; DATA2 = DATA2_set2; ADATA2 = ADATA2_set2; 

        [Transitions1,Time1] = summary_statisticsVWD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVWD(DATA2,ADATA2);
        TransitionsVWD = Transitions1 + Transitions2; TimeVWD = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsVW(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVW(DATA2,ADATA2);
        TransitionsVW = Transitions1 + Transitions2; TimeVW = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsVD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVD(DATA2,ADATA2);
        TransitionsVD = Transitions1 + Transitions2; TimeVD = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsWD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsWD(DATA2,ADATA2);
        TransitionsWD = Transitions1 + Transitions2; TimeWD = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsV(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsV(DATA2,ADATA2);
        TransitionsV = Transitions1 + Transitions2; TimeV = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsW(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsW(DATA2,ADATA2);
        TransitionsW = Transitions1 + Transitions2; TimeW = Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsD(DATA2,ADATA2);
        TransitionsD = Transitions1 + Transitions2; TimeD = Time1 + Time2;

        
        DATA1 = DATA1_set3; ADATA1 = ADATA1_set3; DATA2 = DATA2_set3; ADATA2 = ADATA2_set3; 

        [Transitions1,Time1] = summary_statisticsVWD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVWD(DATA2,ADATA2);
        TransitionsVWD = TransitionsVWD + Transitions1 + Transitions2; TimeVWD = TimeVWD + Time1 + Time2;
        [Transitions1,Time1] = summary_statisticsVW(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVW(DATA2,ADATA2);
        TransitionsVW = TransitionsVW + Transitions1 + Transitions2; TimeVW = TimeVW + Time1 + Time2;      
        [Transitions1,Time1] = summary_statisticsVD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsVD(DATA2,ADATA2);
        TransitionsVD = TransitionsVD + Transitions1 + Transitions2; TimeVD = TimeVD + Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsWD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsWD(DATA2,ADATA2);
        TransitionsWD = TransitionsWD + Transitions1 + Transitions2; TimeWD = TimeWD + Time1 + Time2;
        [Transitions1,Time1] = summary_statisticsV(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsV(DATA2,ADATA2);
        TransitionsV = TransitionsV + Transitions1 + Transitions2; TimeV = TimeV + Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsW(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsW(DATA2,ADATA2);
        TransitionsW = TransitionsW + Transitions1 + Transitions2; TimeW = TimeW + Time1 + Time2;        
        [Transitions1,Time1] = summary_statisticsD(DATA1,ADATA1);
        [Transitions2,Time2] = summary_statisticsD(DATA2,ADATA2);
        TransitionsD = TransitionsD + Transitions1 + Transitions2; TimeD = TimeD + Time1 + Time2;

        
        
    
    %% COMPUTING INFERENCES AND LIKELIHOODS
    % Model VWD
        Transitions = TransitionsVWD; Time = TimeVWD;
        a0 = rand(1,6*Vbins*Wbins*Dbins)'; a = zeros([6,Vbins,Wbins,Dbins]); 
        a2 = minFunc(@likelihood_fishVWD, a0, options);
        [LVWD,LG] = likelihood_fishVWD(a2);
                   
        for n=1:6*Vbins*Wbins*Dbins %% Transformation of coefficients to the matrix form
            ep = 0.1;
            l=ceil((n-ep)/(6*Vbins*Wbins)); lr = ceil(mod(n-ep,6*Vbins*Wbins));
            k=ceil((lr-ep)/(6*Vbins)); kr = ceil(mod(lr-ep,6*Vbins));
            j=ceil((kr-ep)/6); jr=ceil(mod(kr-ep,6));
            i=jr;
            aVWD(i,j,k,l) = a2(n);
        end
        
        fprintf('\nThe VWD inferred rates are in Figure 1')
        plotVWD(1,1,aVWD,Vhist,Whist,Dhist,1)
        plotVWD(1,2,aVWD,Vhist,Whist,Dhist,2)
        plotVWD(1,3,aVWD,Vhist,Whist,Dhist,3)
      
    
    % Model VW
        a0 = rand(1,6*Vbins*Wbins)'; a = zeros([6,Vbins,Wbins]); 
        aVW = minFunc(@likelihood_fishVW, a0, options); 
        [LVW,LG] = likelihood_fishVW(aVW);
        
        
        for n=1:6*Vbins*Wbins
            ep = 0.1;
            k=ceil((n-ep)/(6*Vbins)); kr = ceil(mod(n-ep,6*Vbins));
            j=ceil((kr-ep)/6); jr=ceil(mod(kr-ep,6));
            i=jr;
            a(i,j,k) = aVW(n);
        end
        
        fprintf('\nThe VW inferred rates are in Figure 2')
        plotVW(2,a,Vhist,Whist)
    

    % Model VD
        a0 = rand(1,6*Vbins*Dbins)'; a = zeros([6,Vbins,Dbins]); 
        aVD = minFunc(@likelihood_fishVD, a0, options); 
        [LVD,LG] = likelihood_fishVD(aVD);
        
        for n=1:6*Vbins*Dbins
            ep = 0.1;
            k=ceil((n-ep)/(6*Vbins)); kr = ceil(mod(n-ep,6*Vbins));
            j=ceil((kr-ep)/6); jr=ceil(mod(kr-ep,6));
            i=jr;
            a(i,j,k) = aVD(n);
        end
        
        fprintf('\nThe VD inferred rates are in Figure 3')
        plotVD(3,a,Vhist,Dhist)

    % Model WD
        a0 = rand(1,6*Wbins*Dbins)'; a = zeros([6,Wbins,Dbins]); 
        aWD = minFunc(@likelihood_fishWD, a0, options); 
        [LWD,LG] = likelihood_fishWD(aWD);
        
        for n=1:6*Wbins*Dbins
            ep = 0.1;
            k=ceil((n-ep)/(6*Wbins)); kr = ceil(mod(n-ep,6*Wbins));
            j=ceil((kr-ep)/6); jr=ceil(mod(kr-ep,6));
            i=jr;
            a(i,j,k) = aWD(n);
        end
        
        fprintf('\nThe WD inferred rates are in Figure 4')
        plotWD(4,a,Whist,Dhist)


    % Model V
        a0 = rand(1,6*Vbins)'; a = zeros([6,Vbins]); 
        aV = minFunc(@likelihood_fishV, a0, options); 
        [LV,LG] = likelihood_fishV(aV);
        
        for n=1:6*Vbins
            ep = 0.1;
            j=ceil((n-ep)/6); jr=ceil(mod(n-ep,6));
            i=jr;
            a(i,j) = aV(n);
        end
        
        fprintf('\nThe V inferred rates are in Figure 5')
        plotV(5,a,Vhist)    
    

    % Model W
        a0 = rand(1,6*Wbins)'; a = zeros([6,Wbins]); 
        aW = minFunc(@likelihood_fishW, a0, options); 
        [LW,LG] = likelihood_fishW(aW);
        
        for n=1:6*Wbins
            ep = 0.1;
            j=ceil((n-ep)/6); jr=ceil(mod(n-ep,6));
            i=jr;
            a(i,j) = aW(n);
        end
        
        fprintf('\nThe W inferred rates are in Figure 6')
        plotW(6,a,Whist)


    % Model D
        a0 = rand(1,6*Dbins)'; a = zeros([6,Dbins]); 
        aD = minFunc(@likelihood_fishD, a0, options); 
        [LD,LG] = likelihood_fishD(aD);

        for n=1:6*Dbins
            ep = 0.1;
            j=ceil((n-ep)/6); jr=ceil(mod(n-ep,6));
            i=jr;
            a(i,j) = aD(n);
        end
        
        fprintf('\nThe D inferred rates are in Figure 7')
        plotD(7,a,Dhist)

    
end

fprintf(1,'\n\nLikelihood of the models, ordered by complexity:')
fprintf(1,'\n3 Kinematic variables: velocity, wall position, distance: L(VWD)=%1.4f',-LVWD)

fprintf(1,'\n2 Kinematic variables: velocity, wall position: L(VWD)=%1.4f',-LVW)
fprintf(1,'\n2 Kinematic variables: velocity, distance: L(VWD)=%1.4f',-LVD)
fprintf(1,'\n2 Kinematic variables: wall position, distance: L(VWD)=%1.4f',-LWD)

fprintf(1,'\n1 Kinematic variable: velocity: L(VWD)=%1.4f',-LV)
fprintf(1,'\n1 Kinematic variable: wall position: L(VWD)=%1.4f',-LW)
fprintf(1,'\n1 Kinematic variable: distance: L(VWD)=%1.4f',-LD)

%fprintf(1,'\nL(VWD)=%1.4f \nL(VW)=%1.4f, L(VD)=%1.4f, L(WD)=%1.4f \nL(V)=%1.4f, L(W)=%1.4f, L(D)=%1.4f',-LVWD,-LVW,-LVD,-LWD,-LV,-LW,-LD)
