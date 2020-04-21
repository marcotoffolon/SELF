% ------------------
% FOLDERS & TABLE
% ------------------

% read the position of the working folder
fid = fopen('a0_folder_run.txt');
fold_run = fscanf(fid,'%s');
fold_run = [fold_run,'/'];
fclose(fid);

% folder with figures (output)
fold_fig = [fold_run,'figures/'];

% folder with results (output)
fold_res = [fold_run,'results/'];

%% check for folder existence

% folder with input data
% this folder should exist and contain the outputs from Simstrat
if ~exist(fold_run, 'dir')
    disp(['The working folder with input data does not exist: ',fold_run]);
    disp(['STOP - ',module,'.working_folder']);
    return
end

% check for output folder
if ~exist(fold_fig, 'dir')
    mkdir(fold_fig);
end
if ~exist(fold_res, 'dir')
    mkdir(fold_res);
end

%% read table with lake's features
nlakes = 1;     % number of lakes
row_start = 2;  % initial row (with variables' names)
pp = [int2str(row_start),':',int2str(row_start+nlakes)];
lakes = readtable([fold_run,'lake_data.xlsx'], ...
    'Sheet','lake_info','Range',pp);
