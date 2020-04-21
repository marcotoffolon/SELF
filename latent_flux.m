% latent heat flux
function Flux = latent_flux(wind,pa,Ta,Tw,vap)
    % Tw   : water temperature
    % Ta   : air temperature
    % wind : wind speed
    % pa   : atmpspheric pressure
    % vap  : vapour pressure

    % transfer function
    fu = 4.4 + 1.82*wind + 0.26*( Tw - Ta );
    % water vapor saturation pressure
    fw = 0.61*( 1 + 1e-6*pa.*( 4.5 + 6e-5*Tw.^2 ) );               
    ew = fw*10.*( ( 0.7859 + 0.03477*Tw )./( 1 + 0.00412*Tw ) );
    % heat flux
    Flux = -fu.*( ew - vap );
end
