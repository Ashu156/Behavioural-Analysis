%function[phi,u,v,phi2,u2,v2,u3,v3] = solvePDEsystem2(phi0,omega,gamma,Tmax,Nphi);
function[phi,u,v] = solvePDEsystem2(phi0,omega,gamma,Tmax,Nphi);
global dt

%% Solves the following system of PDEs:
%% u_t = -omega u_phi + gamma(v-u)
%% v_t =  omega v_phi + gamma(u-v)
%% using the method of lines - always upwind, with parameters: 
%% phi0 - initial angle
%% omega = angular velocity
%% gamma - rate of transitions
%% T - terminal time
%% Nphi - division size in angle
%% STABILITY: omega k/h < 1, i.e. k < h/omega

ms = 2; lw = 2; plt = 0;
% phi0 = pi/4;
% omega = 0.2;
% gamma = 0.3;
% T = 20;
% Nphi = 20;
mult = max([1, ceil(10*gamma/0.3), min([10,1/gamma])]);
if mod(mult,2)==0
    mult = mult+1;
end

%% when gamma grows the method becomes unstable. I need to choose a much smaller
%% spatial/temporal step. What I do is to choose the basic step for gamma = 0.3
%% and adjust it according to the following:


%% defining detailed grids
Nphi2 = Nphi*mult;
Nt2 = round(omega*Tmax*Nphi2/pi); %% so that omega k/h = 1/2 %Nt*mult;
u2 = zeros(Nt2,Nphi2+1);
v2 = zeros(Nt2,Nphi2+1);
k2 = Tmax/Nt2;           % time step
h2 = 2*pi/Nphi2 ;    % spatial step
phi2 = [0:h2:2*pi];
t2 = [0:k2:Tmax];
%fprintf(1,'Stability condition: omega*dt/dx = %1.2f <1',omega*k2/h2)
%fprintf(1,'\nTmax = %d, Nt=%d, Nphi=%d',T,Nt,Nphi)
%fprintf(1,'\nNt2=%d, Nphi2=%d',Nt2,Nphi2)

time = 0;
%% initial conditions
[c ind] = min(abs(phi2-phi0));
u2(1,ind) = 0.5/h2;
v2(1,ind) = 0.5/h2;

for it = 1:Nt2
    time = time + k2;
    for iphi = 2:length(phi2)-1
        u2(it+1,iphi) =  u2(it,iphi) - omega*k2/h2*(u2(it,iphi) - u2(it,iphi-1)) + gamma*k2*(v2(it,iphi) - u2(it,iphi));
        v2(it+1,iphi) =  v2(it,iphi) + omega*k2/h2*(v2(it,iphi+1) - v2(it,iphi)) + gamma*k2*(u2(it,iphi) - v2(it,iphi));        
    end
        u2(it+1,1) =  u2(it,1) - omega*k2/h2*(u2(it,1) - u2(it,end)) + gamma*k2*(v2(it,1) - u2(it,1));
        v2(it+1,1) =  v2(it,1) + omega*k2/h2*(v2(it,2) - v2(it,1)) +gamma*k2*(u2(it,1) - v2(it,1));        
        u2(it+1,end) =  u2(it,end) - omega*k2/h2*(u2(it,end) - u2(it,end-1)) + gamma*k2*(v2(it,end) - u2(it,end));
        v2(it+1,end) =  v2(it,end) + omega*k2/h2*(v2(it,1) - v2(it,end)) +gamma*k2*(u2(it,end) - v2(it,end));        
end

%% Coarse-graining to the original mesh with time step dt and spatial step h

%% defining summary grids
Nt = ceil(Tmax/dt);
u = zeros(Nt,Nphi+1);
v = zeros(Nt,Nphi+1);
k = Tmax/Nt;           % time step
h = 2*pi/Nphi ;    % spatial step
phi = [0:h:2*pi];
t = [0:k:Tmax];

%% RESAMPLING to the desired grid
%% 1. Resampling time: Simulated time step: k2, desired time step: k
u3 = zeros(Nt,Nphi2+1);
v3 = zeros(Nt,Nphi2+1);


for jt = 1:length(t)
    %fprintf(1,'\njt=%d, ind=%d',jt,1+round(t(jt)/k2))
    for iphi=1:length(phi2)
        u3(jt,iphi) = u2(1+floor(t(jt)/k2),iphi);
        v3(jt,iphi) = v2(1+floor(t(jt)/k2),iphi);
    end
end


%% 2. Resampling 2: Simulated spatial step: h2, desired spatial step: h
for it = 1:length(t)-1    
    %fprintf(1,'\n t=%d,',it)
    for jphi = 1:length(phi)
        iphi = 1 + (jphi-1)*mult;
        %fprintf(1,'\n jphi=%d, iphi=%d',jphi,iphi)
        if jphi == 1
            u(it,1) = mean( [u3(it , 1: 1 + floor(mult/2) ),u3(it , end - floor(mult/2):end-1)] );
            v(it,1) = mean( [v3(it , 1: 1+ floor(mult/2) ),v3(it , end - floor(mult/2):end-1)] );
        elseif jphi == length(phi)
            u(it,jphi) = u(it,1);
            v(it,jphi) = v(it,1);
        else
            u(it,jphi) = mean( u3(it , iphi - floor(mult/2): iphi + floor(mult/2) ) );
            v(it,jphi) = mean( v3(it , iphi - floor(mult/2): iphi + floor(mult/2) ) );
        end             
    end
end


