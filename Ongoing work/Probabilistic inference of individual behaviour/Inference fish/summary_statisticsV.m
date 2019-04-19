function[TransitionsV,TimeV] = summary_statisticsV(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on just velocity or just wall distance

global Vbins 
global Vhist
global dt

%% DATA 1: Transition histogram
TransitionsV = zeros(6,Vbins);


for i=1:length(DATA)-1
  [v indV] = min(abs(Vhist-DATA(i+1,3)));

  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsV(1,indV) = TransitionsV(1,indV) + 1;
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsV(2,indV) = TransitionsV(2,indV) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsV(3,indV) = TransitionsV(3,indV) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsV(4,indV) = TransitionsV(4,indV) + 1;
  end      
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsV(5,indV) = TransitionsV(5,indV) + 1;
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
      TransitionsV(6,indV) = TransitionsV(6,indV) + 1;
  end
end

%% DATA 2: Occupancy probability

TimeV = zeros(3,Vbins);

for i=1:length(ADATA)-1
  [v indV] = min(abs(Vhist-ADATA(i+1,3)));
  if ADATA(i,2) == 1  
      TimeV(1,indV) = TimeV(1,indV) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeV(2,indV) = TimeV(2,indV) + dt; 
  end
  if ADATA(i,2) == 3  
      TimeV(3,indV) = TimeV(3,indV) + dt; 
  end
end



