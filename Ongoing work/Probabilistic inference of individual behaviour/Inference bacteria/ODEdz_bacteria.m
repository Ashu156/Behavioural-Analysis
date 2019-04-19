function dz = ODEdz_bacteria(t,z)

global Snow v omega arun aLR aLrun  ag  alphastar

dz = zeros(4,1);   

  if Snow == 1  %% run
      dz(1) = v*cos(z(3));          % x-coordinate
      dz(2) = v*sin(z(3));          % y-coordinate
      dz(3) = 0;                    % angle
      dz(4) = 2*exp(arun + ag*(1 + cos( z(3) - pi - alphastar )));          
      
  elseif Snow == 2 %% tumble left
      dz(1) = 0;
      dz(2) = 0;
      dz(3) = omega;
      dz(4) = exp(aLR) + exp(aLrun);
      %dz(4) = 2*exp(aLrun + 0.5*ag*(1 + cos( z(3) -  alphastar )));
      
  else % tumble right
      dz(1) = 0;
      dz(2) = 0;
      dz(3) = -omega;
      dz(4) = exp(aLR) + exp(aLrun);
      %dz(4) = 2*exp(aLrun + 0.5*ag*(1 + cos( z(3) - alphastar )));
  end
