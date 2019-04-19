function [lookfor,stop,direction] = linevent(t,z)
global Snow aS aU aD bS bU bD thresh

lookfor     = z(2)-thresh;  %% contains event we are looking for, in this case z(2) = stoch. threshold
stop        = 1;            %% stops when event z(2) = thresh is located
direction   = 0;            %% specifies direction at which the crossing must occur, 1=up, -1=down, 0=any
end
