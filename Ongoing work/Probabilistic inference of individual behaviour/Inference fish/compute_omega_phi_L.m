function[omega,phi,L]=compute_omega_phi_L(X,Y)
%% X,Y - real coordinates of the walkers

omega = zeros(1,length(X)-1);
phi = zeros(1,length(X)-1);
%% compute the direction of swimming
for k=1:length(X)-1
   if X(k+1)>X(k) 
       omega(k) = atan((Y(k+1)-Y(k))/(X(k+1)-X(k)));
   else
       omega(k) = pi + atan((Y(k+1)-Y(k))/(X(k+1)-X(k)));
   end
   if omega(k) > pi
       omega(k) = omega(k) - 2*pi;
   end
   L(k) = sqrt((Y(k+1)-Y(k))^2+ (X(k+1)-X(k))^2);
end

for k=2:length(X)-1
   if omega(k) - omega(k-1) > pi 
       phi(k) = omega(k) - omega(k-1) - 2*pi;
   elseif omega(k) - omega(k-1) < -pi
       phi(k) = omega(k) - omega(k-1) + 2*pi;
   else
       phi(k) = omega(k) - omega(k-1);
   end
end


