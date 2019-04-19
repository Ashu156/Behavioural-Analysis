function[Sout] = rand_pickN(Sin,antIndex,rnd,z)
%% this function randomly picks a new state for the process knowing already the ant that changes state (antChange)

global Ants aS aU aD bS bU bD  beta
%% Available transitions for both ants
S = [1,2,3]; S(Sin(antIndex))=[];

%% choose the id of the outstate, no matter which ant changes (prob 1/2)
if rnd<1/2  idState = 1;
else          idState = 2;
end

Sout = Sin;
Sout(antIndex) = S(idState);
