function [x,y,vx,vy,ax,ay,wall_distances] = process_raw_data(trackX, trackY, borders, st)
%process_raw_data Filters raw tracking data and produces timeseries of
%positions, velocities, and accelerations

%%only consider samples after "st"
trackX = trackX(:,st:end);
trackY = trackY(:,st:end);

%%get number of particles and samples
[N, number_of_samples] = size(trackX);

%%set frame rate
fps = 100;

%%change units to body lengths (roughly)
trackX = trackX/30;
trackY = trackY/30;

%%choose filter, either SG or mvnavg
filt = 'SG';
%filt = 'mvnavg';

%%filter data
if strcmp(filt,'SG') == 1
    %create a Savitzky-Golay filter
    polynomial_order = 2;
    window_length = 33; %needs to be odd
    %get convolution coefficients for smoothing and derivatives
    [b,conv_coeffs] = sgolay(polynomial_order,window_length);
    %initialize time series
    x = zeros(N, number_of_samples - window_length + 1);
    vx = zeros(N, number_of_samples - window_length + 1);
    ax = zeros(N, number_of_samples - window_length + 1);
    y = zeros(N, number_of_samples - window_length + 1);
    vy = zeros(N, number_of_samples - window_length + 1);
    ay = zeros(N, number_of_samples - window_length + 1);
    %filter the data and obtain differentials
    half_window = (window_length-1)/2;
    for j = (half_window+1):(number_of_samples-half_window)
        x(:,j-half_window) = trackX(:,(j-half_window):(j+half_window))*conv_coeffs(:,1);
        vx(:,j-half_window) = trackX(:,(j-half_window):(j+half_window))*conv_coeffs(:,2);
        ax(:,j-half_window) = 2*trackX(:,(j-half_window):(j+half_window))*conv_coeffs(:,3);
        y(:,j-half_window) = trackY(:,(j-half_window):(j+half_window))*conv_coeffs(:,1);
        vy(:,j-half_window) = trackY(:,(j-half_window):(j+half_window))*conv_coeffs(:,2);
        ay(:,j-half_window) = 2*trackY(:,(j-half_window):(j+half_window))*conv_coeffs(:,3);
    end
    %divide by time increment to get derivatives
    vx = vx/(1/fps);
    vy = vy/(1/fps);
    ax = ax/(1/fps^2);
    ay = ay/(1/fps^2);
elseif strcmp(filt,'mvnavg') == 1
    %apply moving average filter to trajectories
    window_length = 10%33;
    b = ones(1,window_length)/window_length;
    a = 1;
    for i = 1:N
        trackX(i,:) = filter(b,a, trackX(i,:));
        trackY(i,:) = filter(b,a, trackY(i,:));
    end
    %new positions
    x = trackX;
    y = trackY;
    %choose a timescale (in frames) over which to calculate derivatives
    dt = 1;
    %estimate velocities
    vx = (x(:,(1+dt):end) - x(:,1:(end-dt)))/(dt/fps);
    vy = (y(:,(1+dt):end) - y(:,1:(end-dt)))/(dt/fps);
    %estimate accelerations
    ax = (vx(:,(1+dt):end) - vx(:,1:(end-dt)))/(dt/fps);
    ay = (vy(:,(1+dt):end) - vy(:,1:(end-dt)))/(dt/fps);
    %delete few samples so that all time series are of the same length
    x = x(:,1:length(ax));
    y = y(:,1:length(ax));
    vx = vx(:,1:length(ax));
    vy = vy(:,1:length(ax));
end


%calculate distances from the wall, the sign of distance is the sign of the
%cross product of the vector pointing from fish to the closest point at the
%boundary with the fish's velocity
borders = borders/30;
wall_distances = zeros(size(x));

WD = 1; %% perpendicular distance from the wall
%WD = 2; %% distance in the direction of swimming

if WD == 1
    for i = 1:N
        for j = 1:length(x)
            dist = (borders(:,1) - x(i,j)).^2 + (borders(:,2) - y(i,j)).^2;
            [minim, idx] = min(dist);
            dist_sign = sign((borders(idx,1) - x(i,j))*vy(i,j) - (borders(idx,2) - y(i,j))*vx(i,j));
            wall_distances(i,j) = dist_sign*sqrt(minim);
        end
    end
elseif WD == 2
    for i = 1:N
        for j = 1:length(x)
            tx = (borders(:,1) - x(i,j))./vx(i,j); % parametrization in the x-th direction
            ty = (borders(:,2) - y(i,j))./vy(i,j); % parametrization in the y-th direction
            for k=1:length(tx)
                if tx(k)>0 & ty(k)>0 dist(k) = (tx(k)-ty(k))^2;
                else dist(k) = 10^9;
                end
            end
            [minim, idx] = min(dist);
            dist_sign = sign((borders(idx,1) - x(i,j))*vy(i,j) - (borders(idx,2) - y(i,j))*vx(i,j));
            wall_distances(i,j) = dist_sign*sqrt( (borders(idx,1) - x(i,j)).^2 + (borders(idx,2) - y(i,j)).^2 );
        end
    end    
end

