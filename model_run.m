% ------------------
% MODEL RUN ON A SEQUENCE OF YEARS
% ------------------

% allocation
mm(:).N = nan(1,nw); % duration of the pre-freezing period computed with the minimal model (mm)

% cycle on nw winters
for iw = winter_list
    % RUN OF MINIMAL MODEL on a single winter
    
    winter_str = int2str(iw);
    disp(['winter : ',winter_str,' / ',int2str(nw)]);
    
    if(saveall)
        fprintf(fid_ctrl,'%s \r\n', ['winter : ',int2str(iw), ...
            ' - year : ',int2str(years(yr_ice(iw))), ...
            ' - N_dat : ',int2str(N_dat(iw)),' days'    ]);
    end
    
    %% FORCING
    
    % number of time intervals
    n  = meteo(iw).n2;  % midnights
    nd = meteo(iw).n1;  % middays (n1=n2-1)
    % time series
    t_ini = meteo(iw).t2(1);
    t  = meteo(iw).t2 - t_ini;  % midnights
    t1 = meteo(iw).t1 - t_ini;  % middays (n1=n2-1)
    
    % atmospheric forcing at daily time scale
    % part of wind energy effectively transferred to mixing in a day
    mm(iw).E_mix = eta*forc(iw).F_wind*sday; %  [J/m^2/day]
    
    Treal = meteo(iw).LSWT; % surface temperature       
    
    %% KERNEL
    % ---
    cooling_mixing;  %[subroutine]
    % ---

    if(single_winter>0)
        if(isnan(N))
            disp(['no formation of ice in ',int2str(n),' days']);
        else
            disp(['ice after ',int2str(N),' days']);
        end
    end
    mm(iw).LSWT = T_surf;
    
    %% TEST PERFORMANCE
    % performance against Simstrat (surface temperature)
    N_min = min([N,n,nd]);
    dTsurf = T_surf(1:N_min)-Treal(1:N_min);
    dTsurf = sqrt(nanmean(dTsurf.^2)); %RMSE
    if isnan(N)
        % the minimal model does not predict ice formation
        dN = 100; % imposed error
    else
        dN = N-N_dat(iw);
    end
    disp(['eta = ',num2str(eta), ...
        ' / RMSE Tsurf = ',num2str(dTsurf),'°C', ...
        ' / dN = ',int2str(dN)]);
    
    % array with values of N of the minimal model
    mm(iw).N = N;
    
    % save the values of the performance
    if(saveall)
        fprintf(fid_ctrl,'%d %d %f \r\n',[N dN dTsurf]);
    end
    
    % create and save plots
    if(Tsurf_plots)
        T_surf(T_surf<0) = 0;
        plot_Tsurf;     % subroutine producing the plots
        if(saveall)
            saveas(gcf,[fold_fig,'Tsurf_yr',int2str(iw)],'png');
        end
    end
end

