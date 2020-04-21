% quadratic approximation of water density between 0°C and 4°C
% as a function of T, assuming S=0
function rho1 = approx_density(T)

    % PARABOLIC MODEL
    % interpolation of the relation provided by:
    %   http://www.marine.csiro.au/~morgan/seawater
    % $Revision: 1.10 $  $Date: 1998/04/21 05:50:33 $
    % Copyright (C) CSIRO, Phil Morgan 1993.
    % 'SEAWATER Version 2.0.1'
    
    p2 = -0.0085244;
    p1 = 0.067053;
    p0 = -0.1318; % to compute density anomaly with respect to 4°C
    rho1 = p2*T.^2 + p1*T + p0;

return
