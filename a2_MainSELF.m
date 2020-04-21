% ------------------
% MAIN PROGRAM SELF (v.1.0 - April 2020)
% 'Stratification Energy for Lake Freezing' minimal model:
% competition of cooling and wind mixing leading to ice formation
% - Contact:
% Marco Toffolon
% Department of Civil, Environmental, and Mechanical Engineering, University of Trento (Italy)
% email: marco.toffolon@unitn.it
% ------------------
% ROUTINES [functions]:
% main [air_density]
% - folders_table
% - parameters
% - model_run
% -- cooling_mixing [lw_emission, sensible_flux, latent_flux]
% --- all_plots
% --- energymix [approx_density]
% -- plot_Tsurf
% ------------------
% INPUT FILES
% $ : working folder, read from file "a0_folder_run.txt"
% /$/lake_data.xlsx
% /$/results/freezing_data.mat
% /$/results/meteo.mat
% OUTPUT FILES
% /$/results/ctrl.txt (control file)
% /$/results/model.mat
% /$/figure/...
% ------------------
clc; clear;
close all;
module = 'main';

%% PARAMETERS
single_winter = 0;  % =0 all winters, >0 specific winter (choose one in the range from 1 to ny_ice)
Tsurf_plots = 1;    % =1 final plots of surface temperature, =0 no plots
saveall = 1;        % =1 save figures and data, =0 does not save

anim_plots = 0;     % =1 show plots of T profile at each day, =0 no plots
pauseplot = 0;      % =1 pause after each profile (effective if anim_plots=1), =0 without pause

%% INPUT
% define folders' names and read table with lake's features
% ---
folders_table;  %[subroutine]
% ---

% values of the parameters
% ---
parameters;  %[subroutine]
% ---

%% select lake (note that this version of the code considers only one lake)
ilake = 1;
% extract data from lakes' table (from Excel file) - not all of them are used
lake      = lakes.name{ilake};   % lake depth [m]
H         = lakes.depth(ilake);     % lake depth [m]
A        = lakes.area(ilake);     % [m^2] surface area
h_lake   = lakes.altitude(ilake); % [m] lake altitude
p_a      = lakes.p_air(ilake);    % air pressure [hPa]
alb_sw   = lakes.alb_sw(ilake);   % short-wave radiation albedo
eta      = lakes.eta(ilake);      % energy transfer efficiency
% air density at lake altitude
rho_a = air_density(h_lake);

% print case
disp([lake,' : depth = ',num2str(H),' m' ...
    ,', altitude = ',num2str(lakes.altitude(ilake)),' m asl' ...
    ,', eta = ',num2str(lakes.eta(ilake))]);

% open control file
if(saveall)
    fid_ctrl = fopen([fold_res,'ctrl.txt'],'w');
    fprintf(fid_ctrl,'%s \r\n', ['lake : ',lake]);
end

%% load data elaborated previously (a1_PreProcData)
% load dates of freezing periods
load([fold_res,'freezing_data'],'lake','years', ...
    't_4deg','t_iceon','date_4deg','date_iceon', ...
    'ny_ice','yr_ice','N_dat');
nw = ny_ice; % number of years with ice formation
% N_dat : duration of the pre-freezing period in Simstrat

% simulated winters
if(single_winter==0)
    winter_list = (1:nw);
else
    winter_list = single_winter;
end

% meteorological forcing
load([fold_res,'meteo'],'meteo','forc');

%% MINIMAL MODEL
% vertical discretization
z = (0:dz:H);
nz = length(z);

% --- computation of the cycle of winters ---
model_run;  %[subroutine]
% --- ---

if(saveall)
    % save results
    fclose(fid_ctrl);
    save([fold_res,'model'],'N_dat','mm','forc');
end
