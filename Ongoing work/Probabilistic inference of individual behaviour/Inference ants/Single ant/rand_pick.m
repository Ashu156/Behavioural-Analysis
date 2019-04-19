function[Sout] = rand_pick(Sin,R)
%% this function randomly picks a new state for the process
%% the initial state is Sin, the rate of exiting is accounted for in the integration part
%% and since both out states are equally likely to transition into, the threshold is 1/2

S = [1,2,3]; S(Sin)=[];
if R<1/2  Sout = S(1);
else      Sout = S(2);
end