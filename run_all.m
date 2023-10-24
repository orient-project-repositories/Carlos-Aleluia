addpath('Saccade_Generators/')
addpath('Simulink_Models/')
addpath('Optimal_Control/')
addpath('System_Identification/')


saccade_amplitude_stddev = 15; %15 degrees
number_saccades = 1500;

% generate list of saccades to do
[all_goals_origin, all_goals_sequence] = generate_gaussian_saccades(saccade_amplitude_stddev,number_saccades);

%% obtain models
sys = sysid();

sys_dz2 = sysid([0;0;0.02]);
sys_dz4 = sysid([0;0;0.04]);
sys_dz6 = sysid([0;0;0.06]);
sys_dz8 = sysid([0;0;0.08]);
sys_dz_2 = sysid([0;0;-0.02]);
sys_dz_4 = sysid([0;0;-0.04]);
sys_dz_6 = sysid([0;0;-0.06]);
sys_dz_8 = sysid([0;0;-0.08]);

sys_dy2 = sysid([0;0.02;0]);
sys_dy4 = sysid([0;0.04;0]);
sys_dy6 = sysid([0;0.06;0]);
sys_dy8 = sysid([0;0.08;0]);
sys_dy_2 = sysid([0;-0.02;0]);
sys_dy_4 = sysid([0;-0.04;0]);
sys_dy_6 = sysid([0;-0.06;0]);
sys_dy_8 = sysid([0;-0.08;0]);

% save all system models
save('experiments/sys.mat','sys','sys_dz2','sys_dz4','sys_dz6','sys_dz8','sys_dz_2','sys_dz_4','sys_dz_6','sys_dz_8','sys_dy2','sys_dy4','sys_dy6','sys_dy8','sys_dy_2','sys_dy_4','sys_dy_6','sys_dy_8');

%% obtain force approximations
Qf = force_approximation();

Qf_dz2 = force_approximation([0;0;0.02]);
Qf_dz4 = force_approximation([0;0;0.04]);
Qf_dz6 = force_approximation([0;0;0.06]);
Qf_dz8 = force_approximation([0;0;0.08]);
Qf_dz_2 = force_approximation([0;0;-0.02]);
Qf_dz_4 = force_approximation([0;0;-0.04]);
Qf_dz_6 = force_approximation([0;0;-0.06]);
Qf_dz_8 = force_approximation([0;0;-0.08]);

Qf_dy2 = force_approximation([0;0.02;0]);
Qf_dy4 = force_approximation([0;0.04;0]);
Qf_dy6 = force_approximation([0;0.06;0]);
Qf_dy8 = force_approximation([0;0.08;0]);
Qf_dy_2 = force_approximation([0;-0.02;0]);
Qf_dy_4 = force_approximation([0;-0.04;0]);
Qf_dy_6 = force_approximation([0;-0.06;0]);
Qf_dy_8 = force_approximation([0;-0.08;0]);

% save all force approximations
save('experiments/Qf.mat','Qf','Qf_dz2','Qf_dz4','Qf_dz6','Qf_dz8','Qf_dz_2','Qf_dz_4','Qf_dz_6','Qf_dz_8','Qf_dy2','Qf_dy4','Qf_dy6','Qf_dy8','Qf_dy_2','Qf_dy_4','Qf_dy_6','Qf_dy_8');


%% run every simulation

run_multiple_saccades(sys, all_goals_sequence, 0, 'aed', 'none','symmetrical', [0;0;0], [], 'experiments/all_saccades_aed')
run_multiple_saccades(sys, all_goals_sequence, 0, 'ae', 'none','symmetrical', [0;0;0], [], 'experiments/all_saccades_ae')
run_multiple_saccades(sys, all_goals_sequence, 0, 'ad', 'none','symmetrical', [0;0;0], [], 'experiments/all_saccades_ad')

run_multiple_saccades(sys, all_goals_sequence, 0, 'aed', 'none','symmetrical', [0;0;0], [], 'experiments/all_saccades_none')
run_multiple_saccades(sys, all_goals_sequence, 0, 'aed', 'target','symmetrical', [0;0;0], [], 'experiments/all_saccades_target')
run_multiple_saccades(sys, all_goals_sequence, 0, 'aed', 'trajectory','symmetrical', [0;0;0], [], 'experiments/all_saccades_trajectory')

run_multiple_saccades(sys, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;0], Qf, 'experiments/all_saccades_dz0')

run_multiple_saccades(sys_dz_2, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;-0.02], Qf_dz_2, 'experiments/all_saccades_dz_2')
run_multiple_saccades(sys_dz_4, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;-0.04], Qf_dz_4, 'experiments/all_saccades_dz_4')
run_multiple_saccades(sys_dz_6, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;-0.06], Qf_dz_6, 'experiments/all_saccades_dz_6')
run_multiple_saccades(sys_dz_8, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;-0.08], Qf_dz_8, 'experiments/all_saccades_dz_8')
run_multiple_saccades(sys_dz2, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;0.02], Qf_dz2, 'experiments/all_saccades_dz2')
run_multiple_saccades(sys_dz4, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;0.04], Qf_dz4, 'experiments/all_saccades_dz4')
run_multiple_saccades(sys_dz6, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;0.06], Qf_dz6, 'experiments/all_saccades_dz6')
run_multiple_saccades(sys_dz8, all_goals_sequence, 0, 'aed', 'none','asymmetrical', [0;0;0.08], Qf_dz8, 'experiments/all_saccades_dz8')


run_multiple_saccades( sys, generate_directional_saccades([0 1], 35, 8), 1, 'aed', 'none','symmetrical', [0;0;0], [], 'experiments/directional_aed')
run_multiple_saccades( sys, generate_directional_saccades([0 1], 35, 8), 1, 'ae', 'none','symmetrical', [0;0;0], [], 'experiments/directional_ae')
run_multiple_saccades( sys, generate_directional_saccades([0 1], 35, 8), 1, 'ad', 'none','symmetrical', [0;0;0], [], 'experiments/directional_ad')


% velocity_5=run_single_saccade(sys,[0;0;5],[0;0;0],'aed','none','symmetrical',[0;0;0],[]);
% velocity_10=run_single_saccade(sys,[0;10;5],[0;0;0],'aed','none','symmetrical',[0;0;0],[]);
% figure (1)
% plot([0:0.01:0.24],velocity_5(1:25,2))
% hold on
% plot([0:0.01:0.24],velocity_10(1:25,2))
% hold on
% plot([0:0.01:0.24],velocity_10(1:25,1),'--')
% legend('v_z(0)','v_z(10)','v_y(10)');
% xlabel('t (s)')
% ylabel('motor velocity (deg/s)')
% title('Stretching of velocity profiles')