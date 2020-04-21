% ------------------
% ENERGY REQUIRED TO MIX and produce a well mixed layer
% Epot = int(rho*g*z,dz=0..h)
% Epot, after mixing = int(rhom*g*z,dz) = rhom*g*h^2/2
% ------------------

% water density
rho1 = approx_density(T); % density anomaly [kg/m^3] with respect to density at 4°C

% initialization of the integral
Epz(1) = 0;  % potential energy before mixing down to a generic depth
rhom(1) = rho1(1); % density after mixing down to a generic depth
Tm(1) = T(1); % temperature after mixing down to a generic depth

% z-dependent variables
for i=2:nz
    % mean temperature to this depth
    Tm(i) = mean(T(1:i));
    % potential energy down to this depth
    Epz(i) = Epz(i-1) - (rho1(i)*z(i)+rho1(i-1)*z(i-1))/2*g*dz;
end

% density corresponding to mean temperature
rhom = approx_density(Tm);

% energy required to mix a generic depth z
Epot_mix = - rhom*g.*z.^2/2 - Epz;
