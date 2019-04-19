function[minvel,maxvel] = velocity_segments(x,y,vx,vy,fish)

minvel = [];
maxvel = [];
v = sqrt(vx(fish,:).^2+vy(fish,:).^2);

L = length(v(1,:));
if v(1) < v(2) 
    minvel = [minvel,1];        %% start = min
    state = -1;                 %% minimum
else
    maxvel = [maxvel,1];        %% start = max
    state = 1;                  %% maximum
end

tempvel = 1;
for i=2:L-1
    if state == -1 & v(i) > v(i-1) & v(i) > v(i+1) % i-tempvel>5 
        maxvel = [maxvel,i];
        state = 1;
    elseif state == 1 & v(i) < v(i-1) & v(i) < v(i+1) % i-tempvel>5 
        minvel = [minvel,i];
        state = -1;
    end
    
end

        
for i = min(length(minvel),length(maxvel))-3:-1:1
    if abs(maxvel(i)-minvel(i)) < 5
        maxvel(i) = []; minvel(i) = [];
    end
    if v(1) < v(2) & minvel(i+1) - maxvel(i) < 5
        maxvel(i) = []; minvel(i+1) = [];
    end
    if v(1) > v(2) & maxvel(i+1) - minvel(i) < 5
        minvel(i) = []; maxvel(i+1) = [];
    end
end



