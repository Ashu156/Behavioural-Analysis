function[TransitionsVD,TimeVD] = summary_statisticsVD(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on both velocity and wall distance

global Vbins Dbins
global Vhist Dhist 
global dt

%% DATA 1: Transition histogram
TransitionsVD = zeros(6,Vbins,Dbins);


%% DATA 1: Transition histogram
for i=1:length(DATA)-1
  [v indV] = min(abs(Vhist-DATA(i+1,3)));
  [d indD] = min(abs(Dhist-DATA(i+1,5)));
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsVD(1,indV,indD) = TransitionsVD(1,indV,indD) + 1; 
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsVD(2,indV,indD) = TransitionsVD(2,indV,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsVD(3,indV,indD) = TransitionsVD(3,indV,indD) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsVD(4,indV,indD) = TransitionsVD(4,indV,indD) + 1; 
  end
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsVD(5,indV,indD) = TransitionsVD(5,indV,indD) + 1; 
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
      TransitionsVD(6,indV,indD) = TransitionsVD(6,indV,indD) + 1; 
  end
end

%% DATA 2: Occupancy probability

TimeVD = zeros(3,Vbins,Dbins);

for i=1:length(ADATA)-1
  [v indV] = min(abs(Vhist-ADATA(i+1,3)));
  [d indD] = min(abs(Dhist-ADATA(i+1,5)));
  if ADATA(i,2) == 1  
      TimeVD(1,indV,indD) = TimeVD(1,indV,indD) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeVD(2,indV,indD) = TimeVD(2,indV,indD) + dt; 
  end
  if ADATA(i,2) == 3  
      TimeVD(3,indV,indD) = TimeVD(3,indV,indD) + dt; 
  end
end



