# Carlos-Aleluia
Code from master thesis of Carlos Aleluia "Control of Saccades with Model of Artificial 3D Biomimetic Eye"

README

Code used in my Master Thesis. This is the main folder where it's intended to run every script. It is highly recommeded to read my Master Thesis document before studying the scripts because otherwise this brief txt file is somewhat short. In the document you can find further explanation of the different approaches and methods used. You can also see the results for each of the simulations carried out in this code.
It is also advised to create a local folder named 'experiments' to store the results, preventing the repetition of the simulations should need arise (they take several hours). The scripts are already prepared to store data in such a folder. The model I used is Simulink_Models/Eve_v3_Simulator.xlx. Should you decide to use another, it is a matter of replacing the name of the variable in the following scripts: 
- run_multiple_saccades.m
- run_single_saccade.m
- System_Identification/sys_id.m
- Optimal_Control/force_approximation.m
- Visualization_Functions/ocular_range.m

------------------------------------------------------------------------------------------------

The run_all.m script runs every simulation whose result in used in my thesis. It runs, by parts:

- generation of random gaussian saccades
- linear identification of state space models for systems both symmetrical and asymmetrical
- force approximation through least squares (to be used in force minimization approach) of the system both symmetrical and assymmetrical
- runs simulations for approaches used (aed, ae, ad, trajectory, target, force minimization)
- runs directional saccades for velocity profile comparison (main sequence and non-linear kinematic relations). This last part is not as automatic as the others, so a little tweaking with the variables can be useful for plotting

---------------------------------------------------------------------------------------------------

The Optimal_Control/saccade_planner.m script plans a specific saccade beginning in a certain orientation 'y_0' and ending in orientation 'goal'. Both are half radians. Depending on the inputs, the saccade is planned according to different approaches. This is probably the most crucial file, so I will detail a bit the inputs:
- sys: linear state space model of the system
- goal: end orientation in rotation vector notation
- y_0: starting orientation in rotation vector notation
- ene_dur_terms: classical optimization terms ('aed', 'ae' or 'ad')
- lp_constraints: direct penalizations from LP ('target', 'trajectory')
- symmetry: whether force minimization will be used (name is unfortunate). 'asymmetrical' means the force term will be present. In this case, you need to provide the next input. Should you prefer to update the name to something more intuitive, it is simply a question of replacing
- Qf: least squares approximation of quadratic form representing force (f ~ r^T Qf r)
- u_ini: initial positioning of the motors. Generally don't need to worry about this input: when running a single saccade, it does not make much difference; when running multiple in sequence, it fills itself with the last value of the last saccade


-----------------------------------------------------------------------------------------------

The run_single_saccade.m script runs a single saccade from 'origin' to 'target', both in degrees. This file allows the plotting of trajectory and velocity profile (just uncomment the plot sections). The inputs are the same as the saccade_planner plus 'd', the offset in meters of the motors with respect to the eye (see my Thesis report for asymmetry).

-----------------------------------------------------------------------------------------------

The run_multiple_saccades.m script runs multiple saccades, either starting every saccade from the origin ('origin'=1) or making them in sequence ('origin'=0). You also need to provide the list of targets, given in the all_goals variable. This kind of variable should be generated using a saccade generator file. You should also provide a string 'filename', the name of the file where the data will be saved for further analysis.
After collecting all the data, it finds the most probable orientation plane through least squares and stores: 
- all_r : all eye orientations
- all_amplitudes: list of amplitudes of all saccades done (for main sequence)
- all_durations: list of saccade durations (for main sequence)
- all_peak_velocities: list of peak velocities (for main sequence)
- all_correlations: list of correlations between horizontal and vertical velocity profiles for every saccade
- mean_rx: mean torsional component
- stddev_rx: standard deviation of torsional component
- mean_d: mean distance to the plane (in half radians)
- stddev_d: standard deviation of the distance to the plane (in half radians)
- final_r: final orientation
- n: normal to the plane found


-----------------------------------------------------------------------------------------------

System_Identification/sys_id.m script identifies the linear state space model which best resembles the non-linear simulator, sys, for a given offset 'd'.

-----------------------------------------------------------------------------------------------

Optimal_Control/force_approximation.m script obtains the least squares approximation of quadratic form representing force, Qf, for a given offset 'd'.

-----------------------------------------------------------------------------------------------

Visualization/ocular_range.m script plots the ocular range of the mode, as shown in my thesis.

-----------------------------------------------------------------------------------------------

Visualization/draw_3d_model.m script plots the model in 3d.

-----------------------------------------------------------------------------------------------

Visualization/show_plots.m script plots the results saved after running several saccades (run_multiple_saccades). These are the characteristic rx ry, rx rz and ry rz plots shown in my thesis. Regarding the crutial variables:

- stddev_d: standard deviation to the plane (named std_rx in my thesis for simplification). To obtain degrees, do 2*atan(stddev_d)*180/pi
- all_correlations: correlations (we want as close to 1 as possible). To obtain median, do mean(all_correlations)
- n: normal to the plane found. To obtain delta, do -atan(n(3)/n(1))*180/pi (find explanation in thesis)





************************************************************************************************************************************************
************************************************************************************************************************************************


I hope it was somewhat clear to you! To be completelly honest, during my thesis work I did not have time to make this code as cleanest as possible so it is perfectly normal if doubts arise (they even come to me many times when seeing it!) So don't hesitate to contact my through prof Alex Bernardino or even directly carlos.aleluia@tecnico.ulisboa.pt. I'll try to help you the best way I can. I hope you find these scripts useful to you. Good work!


Best,
Carlos Aleluia