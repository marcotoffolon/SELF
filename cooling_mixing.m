% ------------------
% TEMPORAL EVOLUTION OF WATER TEMPERATURE
% simplified description of the evolution of the temperature profile in a
% lake during the cooling phase until the formation of ice at the surface
% time step: 1 day
% ------------------

% allocation
T_surf = nan(n,1); % surface temperature
forc(iw).H_W = nan(nd,1);
forc(iw).H_C = nan(nd,1);
forc(iw).H_E = nan(nd,1);
forc(iw).H_net = nan(nd,1);
mm(iw).E_cool = nan(nd,1);

% initial conditions
T_ini = Treal(1);
N = nan;
h = h0_diff;
j = 1; % first time step
Epz = nan(1,nz); % potential energy
rhom = nan(1,nz); % mixed density
Tm = nan(1,nz); % mixed temperature

% initial temperature profile
T = linspace(T_ini,4,nz); % linear from Tsurf to 4°C at the bottom

T_surf(j) = T(1);

% compute the energy required for mixing part of the water column
% ---
energymix;  %[subroutine]
% ---

if(anim_plots)
    figure;
    hmix = 0; imix = 1; dT = 0; T2 = T; jday = 1;
    all_plots;
end

%% temporal evolution
for j=1:n-1
    if(j==n && isnan(N))
        break;
    end
    %% --- wind mixing ---
    % depth of the well mixed layer (based on wind energy)
    if(mm(iw).E_mix(j)>max(Epot_mix))
        hmix = H;
        imix = nz;
    else
        hmix = min(z(Epot_mix >= mm(iw).E_mix(j)));
        hmix = max(hmix,h0_diff); % set a minimum mixed depth
        % index of the last cell of the well mixed layer
        imix = find(z<=hmix,1,'last');
    end
        
    %% --- cooling ---
    % compute fluxes dependent on LSWT using estimate from minimal model
    % and using daily averaged values of meteorological variables
    forc(iw).H_W(j) = lw_emission(T_surf(j));
    forc(iw).H_C(j) = sensible_flux(meteo(iw).W(j), meteo(iw).Tair(j), T_surf(j));
    forc(iw).H_E(j) = latent_flux(meteo(iw).W(j), meteo(iw).p_a(j), ...
        meteo(iw).Tair(j), T_surf(j), meteo(iw).vap(j));
    forc(iw).H_net(j) =  forc(iw).H_S(j) + forc(iw).H_A(j) + forc(iw).H_W(j) + forc(iw).H_C(j) + forc(iw).H_E(j);
    mm(iw).E_cool(j) = -forc(iw).H_net(j)*sday;
    
    % thermal energy E = rho*cp*dT*h
    dT = mm(iw).E_cool(j)/(rho_w0*cp*hmix); % average decrease of temperature
    T2 = T;
    T2(1:imix) = Tm(imix);
    T2(1:imix) = T2(1:imix) - 2*dT*(hmix-z(1:imix))/hmix;
    
    %% next day
    jday = j+1;
    if(anim_plots)
        all_plots    % plots the different variables
    end
    T = T2; % temperature at step j+1

    % --- surface temperature at the end of the day (next midnight)
    T_surf(jday) = T(1);
    % --- compute energy required to mix ---
    energymix;

    %% check ice formation
    if(min(T)<=0)
        % ice formation
        N = t(jday); % ice-on day
        break
    end
end
