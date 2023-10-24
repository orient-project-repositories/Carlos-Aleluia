Thefunction [ ] = run_multiple_saccades( sys, all_goals, origin, ene_dur_terms, lp_constraint, symmetry, d, Qf, filename)
%RUN_SACCADES Summary of this function goes here
%   Detailed explanation goes here


if ~exist('d','var')
  d=zeros(3,1);
end

% if norm(d) == 0
%     symmetry = 'symmetrical';
% else
%     symmetry = 'asymmetrical';
% end

if ~exist('Qf','var')
  Qf=zeros(3,3);
end

% figure (9)
% xlabel('time (s)')
% ylabel('\theta (deg)')
% title('\theta_z(t) for different amplitudes')
% 
% figure (10)
% xlabel('time (s)')
% ylabel('motor velocity (deg/s)')
% title('velocity_z(t) for different amplitudes')
% 
% 
% figure (11)
% xlabel('time (s)')
% ylabel('\theta (deg)')
% title('\theta_y(t) for different amplitudes')
% 
% figure (12)
% xlabel('time (s)')
% ylabel('motor velocity (deg/s)')
% title('velocity_y(t) for different amplitudes')
% 
% 
% figure (13)
% xlabel('time (s)')
% ylabel('\theta (deg)')
% title('\theta(t) for different amplitudes')
% 
% figure (14)
% xlabel('time (s)')
% ylabel('motor velocity (deg/s)')
% title('velocity(t) for different amplitudes')


app_zero = 1*10^-15; % very close to zero to avoid null quaternion when converting in simulator
y_0 = [app_zero;app_zero;app_zero];

warning('off','all')
all_r = [];
final_r = [];
all_peak_velocities = zeros(size(all_goals,1),1);
all_amplitudes = zeros(size(all_goals,1),1);
all_durations = zeros(size(all_goals,1),1);
all_correlations = [];

% create simin to have u_ini (needed to compute energy)
simin=timeseries();
simin=addsample(simin,'Data',[0;0;0],'Time',0);

for i=1:size(all_goals,2)
    
    goal = tan(all_goals(:,i)*pi/180/2);
    
    [simin, saccade_duration] = saccade_planner(sys, goal, y_0, ene_dur_terms, lp_constraint, symmetry, Qf, simin.Data(:,:,end));

    
    sIn = Simulink.SimulationInput('Eve_v3_Simulator');
    sIn = sIn.setVariable('simin',simin);
    sIn = sIn.setVariable('y_0', y_0);
    sIn = sIn.setVariable('d', d);
    sIn = sIn.setModelParameter('StopTime',string(saccade_duration+0.2));
    simulation = sim(sIn);
    q = simulation.Q_imu.Data(:,:);
    r = q(:,2:4)./q(:,1);
    velocity = simulation.Velocity.Data(:,:);

%     sIn = Simulink.SimulationInput('simulate_optimal_control');
%     sIn = sIn.setVariable('simin',simin);
%     % get x_0
%     A = state_space_model.A;
%     B = state_space_model.B;
%     C = state_space_model.C;
%     % get x_des and x_0
%     phi = C*((eye(6)-A)\B);
%     u_0 = phi\y_0;
%     x_0 = (eye(6)-A)\B*u_0;
%     sIn = sIn.setVariable('x_0', x_0);
%     sIn = sIn.setVariable('ss1', d2d(state_space_model,0.001));
%     sIn = sIn.setModelParameter('StopTime',string(saccade_duration+0.2));
%     simulation = sim(sIn);    
%     r = simulation.r.Data(:,:)';
%     velocity = simulation.Velocity.Data(:,:)';

    
    theta(:,1:3) = 2*atan(r(:,:))*180/pi;
    
%     figure (9)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],theta(:,3))
%     figure (10)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],velocity(:,3))
%     
%     figure (11)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],theta(:,2))
%     figure (12)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],velocity(:,2))
%     
%     figure (13)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],2*atan(sqrt(r(:,1).^2+r(:,2).^2+r(:,3).^2))*180/pi)
%     figure (14)
%     hold on
%     plot([0:0.01:saccade_duration+0.2],sqrt(velocity(:,1).^2+velocity(:,2).^2+velocity(:,3).^2))
    
    all_r = [all_r; r];
    final_r = [final_r; r(end,:)];
    [peak_velocity, ~] = max(sqrt(sum(abs(velocity').^2,1))');
    all_peak_velocities(i) = peak_velocity;
    amplitude = 2*atan(norm(goal-y_0))*180/pi;
    all_amplitudes(i) = amplitude;
    all_durations(i) = saccade_duration*1000; %transform s to ms
    correlation = abs(corr(velocity(:,2),velocity(:,3)));
    saccade=goal-y_0;
    if abs(saccade(2)) > 0.03 && abs(saccade(3)) > 0.03
        all_correlations = [all_correlations; correlation];
    end
    if ~ origin == 1 
        y_0 = r(end,:)'; % saccades done in sequence
    else
        simin=timeseries();
        simin=addsample(simin,'Data',[0;0;0],'Time',0);
    end
    %i
    clear theta %to prevent errors
end
mean_rx = mean(all_r(:,1));
stddev_rx = std(all_r(:,1));

% fit plane
X=all_r(:,2:3);
Y=-all_r(:,1);
par=(X'*X)\X'*Y;
n=[1;par(1);par(2)]/norm([1;par(1);par(2)]);
d=abs(all_r*n);
mean_d = mean(d);
stddev_d = std(d);

save(filename,'all_r','all_amplitudes','all_durations','all_peak_velocities','all_correlations','mean_rx','stddev_rx','d','mean_d','stddev_d','final_r', 'n')


end

