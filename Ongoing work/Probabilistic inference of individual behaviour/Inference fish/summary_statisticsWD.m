function[TransitionsWD,TimeWD] = summary_statisticsWD(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on both velocity and wall distance

global Wbins Dbins
global Whist Dhist 
global dt

%% DATA 1: Transition histogram
TransitionsWD = zeros(6,Wbins,Dbins);


%% DATA 1: Transition histogram
for i=1:length(DATA)-1
  [w indW] = min(abs(Whist-DATA(i+1,4)));
  [d indD] = min(abs(Dhist-DATA(i+1,5)));
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsWD(1,indW,indD) = TransitionsWD(1,indW,indD) + 1; 
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsWD(2,indW,indD) = TransitionsWD(2,indW,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsWD(3,indW,indD) = TransitionsWD(3,indW,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsWD(4,indW,indD) = TransitionsWD(4,indW,indD) + 1; 
  end
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsWD(5,indW,indD) = TransitionsWD(5,indW,indD) + 1; 
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
       TransitionsWD(6,indW,indD) = TransitionsWD(6,indW,indD) + 1; 
  end
end

%% DATA 2: Occupancy probability

TimeWD = zeros(3,Wbins,Dbins);

for i=1:length(ADATA)-1
  [w indW] = min(abs(Whist-ADATA(i+1,4)));
  [d indD] = min(abs(Dhist-ADATA(i+1,5)));
  if ADATA(i,2) == 1  
      TimeWD(1,indW,indD) = TimeWD(1,indW,indD) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeWD(2,indW,indD) = TimeWD(2,indW,indD) + dt; 
  end
  if ADATA(i,2) == 3  
      TimeWD(3,indW,indD) = TimeWD(3,indW,indD) + dt; 
  end
end



