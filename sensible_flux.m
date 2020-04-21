% sensible heat flux
function Flux = sensible_flux(wind,Ta,Tw)
    % input
    % Tw   : water temperature
    % Ta   : air temperature
    % wind : wind speed
    
    % transfer function
    fu = 4.4 + 1.82*wind + 0.26*( Tw - Ta );
    B = 0.61;
    % heat flux
    Flux = -fu.*B.*( Tw - Ta );
end
