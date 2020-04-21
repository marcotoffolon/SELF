% longwave radiation emitted from the atmosphere
% and its fraction absorbed by the lake
function flux = lw_absorption(C,vap,air_temp)
    % input
    % C        : cloud cover
    % vap      : vapour pressure
    % air_temp : air temperature
    global sigma 

    % emissivity (Kuhn, 1978)
    E_A = ( 1+0.17*C.^2 )*1.24.*( ( vap./(air_temp+273.15) ).^0.142857);

    % LW Flux
    flux = 0.97*E_A*sigma.*(air_temp+273.15).^4;

end