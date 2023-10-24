function [ Qf ] = force_approximation( d )

addpath('../Simulink_Models/')

if ~exist('d','var')
  d=zeros(3,1);
end

% important - switch simin sampling time to 0.5 s
% important - switch Q_imu and F sampling time to 0.1 s

% IMPORTANT VARIABLES TO DEFINE
range = 30; %RANGE -> DEGREES THAT EACH MOTOR DEVIATES FROM REST
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
sIn = sIn.setVariable('d', d);
sIn = sIn.setModelParameter('StopTime',string(4630));

sIn = sIn.setBlockParameter('Eve_v3_Simulator/quaternion_output','SampleTime',string(0.1));
sIn = sIn.setBlockParameter('Eve_v3_Simulator/simin','SampleTime',string(0.5));

simulation = sim(sIn);

q = simulation.Q_imu.Data(5:5:end,:);
r = q(:,2:4)./q(:,1);
f = simulation.Fi.Data(5:5:end);

% uncomment to see figures

figure (1)
scatter(r(:,1),r(:,2),[],f)
title('Measured force (plane xy)');
xlabel('r_x (rad/2)');
ylabel('r_y (rad/2)');
cb1 = colorbar;
set(get(cb1,'Title'),'String','Force (N)')
figure (2)
scatter(r(:,1),r(:,3),[],f)
title('Measured force (plane xz)');
xlabel('r_x (rad/2)');
ylabel('r_z (rad/2)');
cb2 = colorbar;
set(get(cb2,'Title'),'String','Force (N)')
figure (3)
scatter(r(:,2),r(:,3),[],f)
title('Measured force (plane yz)');
xlabel('r_y (rad/2)');
ylabel('r_z (rad/2)');
cb3 = colorbar;
set(get(cb3,'Title'),'String','Force (N)')
% 

X = zeros(size(r,1),6);%9);
X(:,1) = r(:,1).^2;
X(:,2) = r(:,2).^2;
X(:,3) = r(:,3).^2;
X(:,4) = r(:,1).*r(:,2);
X(:,5) = r(:,1).*r(:,3);
X(:,6) = r(:,2).*r(:,3);
% X(:,7) = r(:,1);
% X(:,8) = r(:,2);
% X(:,9) = r(:,3);
Y = f;
par = (X'*X)\(X'*Y);
Qf = [par(1) par(4)/2 par(5)/2;par(4)/2 par(2) par(6)/2;par(5)/2 par(6)/2 par(3)];
% ff = [par(7) par(8) par(9)];
f_ = zeros(size(r,1),1);
for i=1:size(r,1)
   f_(i) = r(i,:)*Qf*r(i,:)';%+ff*r(i,:)'; 
end

% uncomment to see figures

figure (4)
scatter(r(:,1),r(:,2),[],f_)
title('Estimated force (plane xy)');
xlabel('r_x (rad/2)');
ylabel('r_y (rad/2)');
cb1 = colorbar;
set(get(cb1,'Title'),'String','Force (N)')
figure (5)
scatter(r(:,1),r(:,3),[],f_)
title('Estimated force (plane xz)');
xlabel('r_x (rad/2)');
ylabel('r_z (rad/2)');
cb2 = colorbar;
set(get(cb2,'Title'),'String','Force (N)')
figure (6)
scatter(r(:,2),r(:,3),[],f_)
title('Estimated force (plane yz)');
xlabel('r_y (rad/2)');
ylabel('r_z (rad/2)');
cb3 = colorbar;
set(get(cb3,'Title'),'String','Force (N)')