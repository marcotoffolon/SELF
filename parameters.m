% ------------------
% PARAMETERS
% ------------------

global g cp kappa sigma
global rho_a0 lapse_rate Nlr Ta0 % for "air_density.m"

% parameters for the hydro-thermodynamic model
kappa = 0.41;           % Von Karman constant
cp = 4186;              % heat capacity [J/(kg K)]
g = 9.81;               % gravitational acceleration [m/s^2]
sday = 86400;           % seconds in a day [s/d]
rho_w0 = 1000;          % [kg/m^3] water density (reference)
% parameters for the heat balance
sigma = 5.67e-8;        % Stefan-Boltzmann constant [W/(m^2 K^4)]
% parameters for air density
rho_a0 = 1.225;         % [kg/m^3] air sea level standard density
Ta0 = 288.15;           % [K] sea level standard temperature
Rv = 8.31447;           % [J/(mol K)] ideal gas constant
lapse_rate = 0.0065;    % [K/m] temperature lapse rate
M_dryair = 0.0289644;   % [kg/mol] molar mass of dry air
Nlr = (g*M_dryair)/(Rv*lapse_rate);

% parameters for the minimal model
Ch = 3/(2*kappa);       % [-] Chézy coefficient
kwind = rho_a0;         % SELF3
D0 = 1e-6;              % background diffusivity [m^2/s]
% surface boundary layer
h0_diff = 2*sqrt(2*D0*sday); % estimate of diffusive boundary layer [m]
% discretization
dz = 0.1;               % vertical discretization [m]
