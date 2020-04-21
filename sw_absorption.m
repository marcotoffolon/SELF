% fraction of the (solar) shortwave radiation absorbed by the lake
function flux = sw_absorption(albedo,sol)
    % input
    % albedo : shortwave albedo
    % sol    : measured incoming sw radiation (already affected by cloud cover)

    flux = ( 1-albedo ).*sol; % Imboden and Wuest (1995), Table 4 p.97

end