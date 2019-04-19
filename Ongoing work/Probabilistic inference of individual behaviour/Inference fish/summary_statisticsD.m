function[TransitionsD,TimeD] = summary_statisticsD(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on just velocity or just wall distance

global Dbins
global Dhist 
global dt

%% DATA 1: Transition histogram
TransitionsD = zeros(6,Dbins);

for i=1:length(DATA)-1
  [d indD] = min(abs(Dhist-DATA(i+1,5)));
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsD(1,indD) = TransitionsD(1,indD) + 1;
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsD(2,indD) = TransitionsD(2,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsD(3,indD) = TransitionsD(3,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsD(4,indD) = TransitionsD(4,indD) + 1;
  end      
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsD(5,indD) = TransitionsD(5,indD) + 1;
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
      TransitionsD(6,indD) = TransitionsD(6,indD) + 1;
  end
end

%% DATA 2: Occupancy probability

TimeD = zeros(3,Dbins);

for i=1:length(ADATA)-1
  [d indD] = min(abs(Dhist-ADATA(i+1,5)));
  if ADATA(i,2) == 1  
      TimeD(1,indD) = TimeD(1,indD) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeD(2,indD) = TimeD(2,indD) + dt; 
  end
  if ADATA(i,2) == 3  
      TimeD(3,indD) = TimeD(3,indD) + dt; 
  end
end



