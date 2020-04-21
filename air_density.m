% air density
function rho_a = air_density(h_lake)
global rho_a0 lapse_rate Nlr Ta0

    % air density depending on altitude
    rho_a = rho_a0*(1-(lapse_rate*h_lake)/Ta0)^(Nlr-1);
    
end
