function [lookfor,stop,direction] = linevent(t,z)
global Tend plottraj plothist Nbins Snow arun aLR aLrun v omega  ag af z1 z2 Zbin Nz Time a thresh

lookfor     = z(4)-thresh;      %% contains event we are looking for, in this case z(2) = stoch. threshold
stop        = 1;                %% stops when event z(2) = thresh is located
direction   = 0;                %% specifies direction at which the crossing must occur, 1=up, -1=down, 0=any
end
