% ------------------
% PRE-PROCESSING of data for minimal model SELF
% Version 1.0 - April 2020
% - Contact:
% Marco Toffolon
% Department of Civil, Environmental, and Mechanical Engineering, University of Trento (Italy)
% email: marco.toffolon@unitn.it
% ------------------
% ROUTINES [functions]:
% main [air_density, drag_coeff, lw_absorption, sw_absorption]
% - folders_table
% - parameters
% - plot_meteo_forcing
% ------------------
% INPUT FILES
% $ : working folder, read from file "a0_folder_run.txt"
% /$/lake_data.xlsx
% OUTPUT FILES
% /$/results/freezing_periods.txt (control file)
% /$/results/freezing_data.mat
% /$/results/meteo.mat
% /$/figure/...
% ------------------

clear; clc;
close all;
module = 'pre';

%% PARAMETERS OF THE RUN
showfig = 1;    % =1 create and show figures, =0 does not create
saveall = 1;    % =1 save figures and data, =0 does not save

add_days = 15;  % additional days added to max(t_iceon) [default: 15]

%% READ INPUT
% define folders' names and read table with lake's features
% ---
folders_table;  %[subroutine]
% ---

ilake = 1;
% extract data from lakes' table
lake      = lakes.name{ilake};   % lake depth [m]
H         = lakes.depth(ilake);     % lake depth [m]
disp([lake,' : depth = ',num2str(H),' m' ...
    ,', altitude = ',num2str(lakes.altitude(ilake)),' m asl']);

% read LSWT (at midnights)
LSWTdata = readtable([fold_run,'lake_data.xlsx'],'Sheet','LSWT');
tn = x2mdate(LSWTdata.t_midnight);
Tw = LSWTdata.LSWT;

% time interval
[yyyy,mmm,dd,hh,mm]=datevec(tn);
% sequence of years
years = (yyyy(1):yyyy(end));
ny = length(years);

%% Find days of fall overturn (4°C) and ice-on (0°C )
t_iceon = []; t_4deg = [];

% open control file (output)
fid = fopen([fold_res,'freezing_periods.txt'],'w');

% select the first possible date for 4°C and ice
% (e.g., September 1st [9,1] of each year in the series)
ti0 = datenum(years,9,1);

% ice-on
fprintf(fid,'%s \r\n','%----- ICE-ON -----');
fprintf(fid,'%s \r\n','% yr   t(ice-on)  date(ice-on)');
tii = tn(Tw<=0); % frozen days
j = 0;
yr_ice = [];
for k = 1:ny
    ti1 = ti0(k);
    i = find(tii>ti1,1,'first'); % first frozen day of the year
    if(~isempty(i) && (tii(i)-ti1<365))
        t_iceon(k) = tii(i);
        tmp_day = datestr(t_iceon(k));
        j = j+1;
        yr_ice(j) = k;
    else
        t_iceon(k) = nan;
        tmp_day = 'no ice';
    end
    fprintf(fid,'%d %f %s \r\n',k,t_iceon(k),tmp_day);
end
t_iceon(isnan(t_iceon)) = [];
ny_ice = length(t_iceon);   % number of years with ice

% find days with LSWT>4°C
fprintf(fid,'%s \r\n','%----- FOUR DEG -----');
fprintf(fid,'%s \r\n','% yr   t(4°C)     date(4°C)');
tii = tn(Tw>4);
for k = 1:ny_ice
    ti1 = t_iceon(k);
    i = find(tii<ti1,1,'last'); % last day with LSWT>4°C
    if(~isempty(i))
        t_4deg(k) = tii(i) +1; % day after the 4°C-transition
        disp([datestr(t_4deg(k)),' - ',datestr(t_iceon(k))]);
        tmp_day = datestr(t_4deg(k));
    else
        t_4deg(k) = nan;
        tmp_day = 'no 4deg';
    end
    fprintf(fid,'%d %f %s \r\n',yr_ice(k),t_4deg(k),tmp_day);
end
disp(['number of years with ice : ',int2str(ny_ice),' / ',int2str(ny)]);

%% Print the results: t(4°C)  t(Ice-on)  N=duration
N_dat = t_iceon-t_4deg; % duration of the pre-freezing period
fprintf(fid,'%s \r\n','%----- SUMMARY -----');
fprintf(fid,'%s \r\n','% i  year  t(4°C)  t(Ice-on)  N=duration');
for k=1:ny_ice
    date_4deg = datestr(t_4deg(k));
    date_iceon = datestr(t_iceon(k));
    fprintf(fid,'%d %d %d %s %s %d %d %d \r\n',k,yr_ice(k), ...
        years(yr_ice(k)),date_4deg,date_iceon,N_dat(k),t_4deg(k),t_iceon(k));
end
fclose(fid);

% save results
save([fold_res,'freezing_data'],'lake','years', ...
    't_4deg','t_iceon','date_4deg','date_iceon', ...
    'ny_ice','yr_ice','N_dat');

%% PLOTS
if(showfig)
    % plot of the relevant dates
    figure
    plot(tn,Tw);
    hold on
    plot(t_4deg,t_4deg*0+4,'.m','markersize',12);
    plot(t_iceon,t_iceon*0,'.r','markersize',12);
    datetick('x',12);
    xlabel('Time')
    ylabel('LSWT (°C)');
    title(lake)
    drawnow
    
    if(saveall)
        saveas(gcf,[fold_fig,'ice_dates'],'png');
    end
end

%% CREATE METEO FORCING
% set the physical parameters
% ---
parameters;  %[subroutine]
% ---

% lake properties (from Excel table)
A        = lakes.area(ilake);     % [m^2] surface area
h_lake   = lakes.altitude(ilake); % [m] lake altitude
lat      = lakes.latitude(ilake); % [rad] lake latitude
p_a      = lakes.p_air(ilake);    % air pressure [hPa]
alb_sw   = lakes.alb_sw(ilake);   % short-wave radiation albedo

% select the final date for the "extended" pre-freezing period
% by adding additional days
end_date = t_iceon + add_days;
disp('---');
disp('Meteorological forcing: extended pre-freezing period');
for iw=1:ny_ice
    disp([datestr(t_4deg(iw)),' - ',datestr(end_date(iw))]);
end

% load meteorological data
meteodata = readtable([fold_run,'lake_data.xlsx'],'Sheet','meteo');
td = x2mdate(meteodata.t_day);

% air density at lake altitude
rho_a = air_density(h_lake);

for iw = 1:ny_ice
    disp(['winter ',int2str(iw),' / ',int2str(ny_ice)]);

    %% select period: from T=4°C to "end_date"
    
    % number of midnights in the period (for LSWT)
    period_n = (tn>=t_4deg(iw) & tn<=end_date(iw));
    meteo(iw).t2 = tn(period_n);
    meteo(iw).n2 = length(meteo(iw).t2);
    
    % lake surface water temperature [°C]
    meteo(iw).LSWT = Tw(period_n);  

    % number of days in the period (for daily averages) is num(midnight)-1
    period_d = (td>=t_4deg(iw) & td<=end_date(iw));
    meteo(iw).t1 = td(period_d);
    meteo(iw).n1 = length(meteo(iw).t1);
    
    % meteorological variables (daily averages)
    tw_d = td(period_d);                     % time coordinate in the single winter
    meteo(iw).W = meteodata.W(period_d);     % wind speed at 10 m [m/s]
    meteo(iw).W3 = meteodata.W3(period_d);   % wind speed at 10 m [m/s] (cubic average)
    meteo(iw).Tair = meteodata.AT(period_d); % air temperature [°C]
    meteo(iw).sol = meteodata.Hs(period_d);  % measured short-wave radiation [W/m^2]
    meteo(iw).vap = meteodata.vap(period_d); % vapour pressure [mbar]
    meteo(iw).C = meteodata.CC(period_d);    % cloud cover [-]
    % fixed value if p_atm(t) is not given
    meteo(iw).p_a = zeros(1,meteo(iw).n1) + p_a; % atmospheric pressure [mbar]

    % heat fluxes [W/m^2]
    forc(iw).H_S = sw_absorption(alb_sw,meteo(iw).sol);
    forc(iw).H_A = lw_absorption(meteo(iw).C,meteo(iw).vap,meteo(iw).Tair);
    
    % wind power [W/m^2]
    forc(iw).Cdrag = drag_coeff(meteo(iw).W3)';
    forc(iw).F_wind = kwind*forc(iw).Cdrag.*meteo(iw).W3.^3;
    
    %% PLOTS
    if(showfig)
        % plot LSWT and meteorological forcing computed with Simstrat
        % ---
        plot_meteo_forcing;  %[subroutine]
        % ---
        drawnow
    end
end

if(saveall)
    %% save data
    save([fold_res,'meteo'],'meteo','forc');
    % note that LSWT are at midnight, while
    % the daily averaged variables are "centered" in the day
    %--- meteo.variables:
    % n2, t2 : number of midnights and time vector (n2 values)
    % n1, t1 : number of days and time vector (n1=n2-1 values at midday)
    % W, W3  : wind speed (linear average, cubic average) [m/s]
    % Tair   : air temperature [°C]
    % sol    : solar radiation [W/m^2]
    % vap    : vapour pressure [mbar]
    % C      : cloud cover [-]
    % p_a    : atmospheric pressure [mbar]
    %--- forc.variables:
    % H_S    : incoming shortwave radiation (including albedo) [W/m^2]
    % H_A    : incoming longwave radition [W/m^2]
    % Cdrag  : wind drag coefficient [-]
    % F_wind : wind power [W/m^2]
end
