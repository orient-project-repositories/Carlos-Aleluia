%% listing plane plots

figure (1)
title('XY Plane');
xlabel('r_x (rad/2)');
ylabel('r_y (rad/2)');
hold on
scatter(all_r(:,1),all_r(:,2),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
xlim([-0.5 0.5])
xticks([-0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5])
ylim([-0.5 0.5])

figure (2)
title('XZ Plane');
xlabel('r_x (rad/2)');
ylabel('r_z (rad/2)');
hold on
scatter(all_r(:,1),all_r(:,3),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
xlim([-0.5 0.5])
xticks([-0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5])
ylim([-0.5 0.5])

figure (3)
title('YZ Plane');
xlabel('r_y (rad/2)');
ylabel('r_z (rad/2)');
hold on
scatter(all_r(:,2),all_r(:,3),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
xlim([-0.5 0.5])
xticks([-0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5])
ylim([-0.5 0.5])

%% plot main sequence


figure (4)
title('Saccade Durations');
xlabel('amplitude (deg)');
ylabel('duration (ms)');
hold on
scatter(all_amplitudes,all_durations,2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);

% hold on
% scatter(all_amplitudes,all_durations,25,'filled','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);

figure (5)
title('Saccade Peak Velocities');
xlabel('amplitude (deg)');
ylabel('peak velocity (deg/s)');
hold on
scatter(all_amplitudes,all_peak_velocities,2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);

% hold on
% scatter(all_amplitudes,all_peak_velocities,25,'filled','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);


%% plot delta(dz)

figure (10)
title('Listings Plane Tilt');
xlabel('dz (cm)');
ylabel('\delta (^\circ)');
hold on
data=[-8,-6,-4,-2,0,2,4,6,8 ; -8.03,-6.19,-4.24,-2.09,0.1,2.14,4.20,6.40,10.96];
scatter(data(1,:),data(2,:),10,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]);
xlim([-10 10])