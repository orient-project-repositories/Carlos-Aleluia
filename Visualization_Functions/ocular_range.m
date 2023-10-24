
addpath('../Simulink_Models/')

% important - switch simin sampling time to 0.5 s
% important - switch Q_imu and F sampling time to 0.1 s

% IMPORTANT VARIABLES TO DEFINE
range = 50; %RANGE -> DEGREES THAT EACH MOTOR DEVIATES FROM REST
steps = 10;  %STEPS -> HOW MANY STEPS FROM REST TO MAX DEVIATION


delta_angle = 512*range/45/steps;
allT=[];
for i=-steps:steps
    for j=-steps:steps
        for l=-steps:steps
            if i == 0 && j==0 && l==0 
            
            else    
                allT=[allT;round(512+delta_angle*i) round(512+delta_angle*j) round(512+delta_angle*l)];
            end
        end
    end
end
allT_rand = allT(randperm(length(allT)),:);

simin = timeseries();
delta_t = 0.5; % 
for j=1:size(allT_rand,1)
    simin = addsample(simin,'Data',(allT_rand(j,:)-512)*45/512,'Time',(j-1)*delta_t);
end

app_zero = 1*10^-15; % very close to zero to avoid null quaternion when converting in simulator
y_0 = [app_zero;app_zero;app_zero];
warning('off','all')

sIn = Simulink.SimulationInput('Eve_v3_Simulator');
sIn = sIn.setVariable('simin',simin);
sIn = sIn.setVariable('y_0', y_0);
sIn = sIn.setVariable('d', [0;0;0]);
sIn = sIn.setModelParameter('StopTime',string(4630));

sIn = sIn.setBlockParameter('Eve_v3_Simulator/quaternion_output','SampleTime',string(0.01));
sIn = sIn.setBlockParameter('Eve_v3_Simulator/simin','SampleTime',string(0.5));

simulation = sim(sIn);

q = simulation.Q_imu.Data(:,:);
r = q(:,2:4)./q(:,1);

% correlations= zeros(4630,1);
% 
% for j=1:4630
%     correlation = abs(corr(simulation.Velocity.Data((j-1)*50+1:(j-1)*50+50,2),simulation.Velocity.Data((j-1)*50+1:(j-1)*50+50,3)));
%     correlations(j) = correlation;
% end


figure (1)
scatter(r(:,1),r(:,2),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
title('Attained orientations (plane xy)');
xlabel('r_x (rad/2)');
ylabel('r_y (rad/2)');
xlim([-0.5 0.5])
ylim([-0.5 0.5])
figure (2)
scatter(r(:,1),r(:,3),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
title('Attained orientations (plane xz)');
xlabel('r_x (rad/2)');
ylabel('r_z (rad/2)');
xlim([-0.5 0.5])
ylim([-0.5 0.5])
figure (3)
scatter(r(:,2),r(:,3),2.5,'filled','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])
title('Attained orientations (plane yz)');
xlabel('r_y (rad/2)');
ylabel('r_z (rad/2)');
xlim([-0.5 0.5])
ylim([-0.5 0.5])
