# SELF
Stratification Energy before Lake Freezing: 
A minimal model to predict the duration of the pre-freezing period in lakes

------------------
SELF (v.1.0 - April 2020)
'Stratification Energy for Lake Freezing' minimal model:
competition of cooling and wind mixing leading to ice formation in lakes
- Contact:
Marco Toffolon
Department of Civil, Environmental, and Mechanical Engineering, University of Trento (Italy)
email: marco.toffolon@unitn.it
------------------
GitHub repository: https://github.com/marcotoffolon/SELF
------------------

------------------
INPUT FILES

1. select folder with input data: 
Read from ASCII file 'a0_folder_run.txt' in the same directory of the Matlab scripts.

2. lake properties and meteorological variables: 
Read from Excel file 'lake_data.xlsx' located in the folder defined above.
Excel sheets:
- readme : instructions
- lake_info : main properties of the lake (including efficiency eta)
- meteo : meteorological variables (daily averaged values, ideally centered at midday)
- LSWT : values of lake surface water temperatuare (at midnights)
Note that nr of midnights = nr of middays + 1
------------------

------------------
MATLAB SCRIPTS

1. a1_PreProcData.m (MAIN)
Pre.processing of the data to define full mixing date and ice-on date
and prepare the forcing of the SELF model.

2. a2_MainSELF.m (MAIN)
Main program, reading data written from the pre-processing.

3. folders_table.m (SUB)
Create folders and read table with lake's input data.

4. parameters.m (SUB)
Set the parameters of the model.

5. model_run.m (SUB)
Run the model for the sequence of years.

6. cooling_mixing.m (SUB)
Compute the evolution of the temperature profile.

7. energymix.m (SUB)
Compute the energy required for mixing a part of the water column.

8. all_plots.m (SUB)
Plots water temperature's vertical profiles (optional).

9. plot_Tsurf.m (SUB)
Plot surface water temperature (optional).

10. plot_meteo_forcing.m (SUB)
Plot meteorological forcing (optional).

Functions to compute variables:
. air_density    : density of air at the lake's altitude
. approx_density : water density approximated as a parabolic function of water temperature in the range 0-4°C
. drag_coeff     : wind drag coefficient as a function of wind speed
. lw_absorption  : longwave radiation absorbed by the lake
. sw_absorption  : longwave radiation absorbed by the lake
. lw_emission    : longwave radiation emitted by the lake
. sensible_flux  : sensible heat flux
. latent_flux    : latent heat flux
------------------

------------------
FOLDERS

1. input files
$ : working folder read from file "a0_folder_run.txt"
/$/lake_data.xlsx
/$/results/freezing_data.mat
/$/results/meteo.mat

2. output files
/$/results/freezing_periods.txt (control file)
/$/results/freezing_data.mat
/$/results/meteo.mat
/$/results/ctrl.txt (control file)
/$/results/model.mat
/$/figure/...
------------------
