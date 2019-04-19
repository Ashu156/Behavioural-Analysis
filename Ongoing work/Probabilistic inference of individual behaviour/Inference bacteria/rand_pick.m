function[Sout] = rand_pick(Sin,R,z)
global Tend plottraj plothist Nbins Snow arun aLR aLrun  v omega  ag af z1 z2 Zbin Nz Time a thresh
global alphastar
%% this function randomly picks a new state for the process
%% the initial state is Sin, the rate of exiting is accounted for in the integration part
%% and since both out states are equally likely to transition into, the threshold is 1/2

S = [1,2,3]; S(Sin)=[];

if Sin == 1
  outrates = [ exp(arun + ag*(1 + cos( z(3) - pi - alphastar ))) , exp(arun + ag*(1 + cos( z(3) - pi - alphastar )))];
elseif Sin == 2
  outrates = [exp(aLrun),exp(aLR)]; 
else 
  outrates = [exp(aLrun),exp(aLR)];
end 
outrates = outrates/sum(outrates);

if R<outrates(1)  Sout = S(1);
else      Sout = S(2);
end