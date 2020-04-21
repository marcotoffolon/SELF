% longwave radiation emitted by the lake
function Flux = lw_emission(Tw)
    % input    
    % Tw : water temperature
    global sigma
    % heat flux
    Flux = -0.97*sigma*(Tw+273.15).^4;   % Davies et al. (1971)
end
