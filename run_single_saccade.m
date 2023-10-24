function [  velocity_profile] = run_single_saccade( sys, target, origin, ene_dur_terms, lp_constraint, symmetry, d, Qf)
%RUN_SINGLE_SACCADE Summary of this function goes here
%   Detailed explanation goes here


if ~exist('d','var')
  d=zeros(3,1);
end

if ~exist('Qf','var')
  Qf=zeros(3,3);
end

y_0 = tan(origin*pi/180/2);
goal = tan(target*pi/180/2);

if norm(y_0) == 0
    app_zero = 1*10^-15; % very close to zero to avoid null quaternion when converting in simulator
    y_0 = [app_zero;app_zero;app_zero];
end

[simin, saccade_duration] = saccade_planner(sys, goal, y_0, ene_dur_terms, lp_constraint, symmetry, Qf);
warning('off','all')

% test in non linear simulator

sIn = Simulink.SimulationInput('Eve_v3_Simulator');
sIn = sIn.setVariable('simin',simin);
sIn = sIn.setVariable('y_0', y_0);
sIn = sIn.setVariable('d', d);
sIn = sIn.setModelParameter('StopTime',string(saccade_duration+0.2));
simulation = sim(sIn);
q = simulation.Q_imu.Data(:,:);
r = q(:,2:4)./q(:,1);
velocity = simulation.Velocity.Data(:,:);





theta(:,1:3) = 2*atan(r(:,:))*180/pi;


saccade_duration_line = [saccade_duration saccade_duration];

%THETA
figure (2)
plot([0:0.01:saccade_duration+0.2],theta(:,:))
xlabel('time (s)')
ylabel('\theta (deg)')
title('\theta(t)')
legend('\theta_x','\theta_y','\theta_z')
x_lim=get(gca,'xlim');
y_lim=get(gca,'ylim');
hold on
plot(saccade_duration_line,y_lim,'HandleVisibility','off','Color','k','LineStyle','--')

%VELOCITY
figure (3)
plot([0:0.01:saccade_duration+0.2],velocity)
xlabel('time (s)')
ylabel('motor velocity (deg/s)')
title('velocity(t)')
h1=legend('$\dot{u}_1$','$\dot{u}_2$','$\dot{u}_3$');
set(h1, 'Interpreter', 'latex');
x_lim=get(gca,'xlim');
y_lim=get(gca,'ylim');
hold on
plot(saccade_duration_line,y_lim,'HandleVisibility','off','Color','k','LineStyle','--')

velocity_profile = velocity(:,2:3);

end

