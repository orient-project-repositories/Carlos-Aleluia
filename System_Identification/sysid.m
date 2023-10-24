function [ sys ] = sysid( d )

if ~exist('d','var')
  d=zeros(3,1);
end

addpath('../Simulink_Models/')

% important - switch Q_imu sampling time to 0.01 s
% important - switch simin sampling time to 0.01 s
Range = [-20,20]; % -20 / +20 degrees
Band = [0 1/100]; % minimum waiting time = 1s = 100*0.01 Ts
Length = 180*100 + 1; % 180 sec
u1 = idinput([Length, 3, 1], 'prbs',Band,Range);
t1 = 0:1:18000;

% uncomment to see figures

% figure (1)
% plot(t1(:),u1(:,:));


simin=timeseries(u1,0:0.01:180);

app_zero = 1*10^-15; % very close to zero to avoid null quaternion when converting in simulator
y_0 = [app_zero;app_zero;app_zero];
warning('off','all')

sIn = Simulink.SimulationInput('Eve_v3_Simulator');
sIn = sIn.setVariable('simin',simin);
sIn = sIn.setVariable('y_0', y_0);
sIn = sIn.setVariable('d', d);
sIn = sIn.setModelParameter('StopTime',string(180));
simulation = sim(sIn);
q = simulation.Q_imu.Data(:,:);
r = q(:,2:4)./q(:,1);

Ts = 0.01;
train_data = iddata(r(1:12000,:),u1(1:12000,:),Ts,'InputName',{'motor_1';'motor_2';'motor_3'},'InputUnit',{'deg';'deg';'deg'},'OutputName',{'r_x';'r_y';'r_z'},'OutputUnit',{'deg';'deg';'deg'});
sys = n4sid(train_data,6);

test_data = iddata(r(12001:18001,:),u1(12001:18001,:),Ts,'InputName',{'motor_1';'motor_2';'motor_3'},'InputUnit',{'deg';'deg';'deg'},'OutputName',{'r_x';'r_y';'r_z'},'OutputUnit',{'deg';'deg';'deg'});

% uncomment to see figures 

% figure (2)
% compare(test_data,sys)


% plot non-linearities

Range = [-20,20]; % -20 / +20 degrees
Band = [0 1/100]; % minimum waiting time = 1s = 100*0.01 Ts
Length = 240*100 + 1; % 4 minutes
u2 = idinput([Length, 3, 1], 'prbs',Band,Range);
for i=1:12000
    u2(i,3) = u2(i,1); %remains the same
end
for i=12001:24001
    u2(i,3) = -u2(i,1); %remains the same
end
simin=timeseries(u2,0:0.01:240);

d=zeros(3,1);
app_zero = 1*10^-15; % very close to zero to avoid null quaternion when converting in simulator
y_0 = [app_zero;app_zero;app_zero];
warning('off','all')

sIn = Simulink.SimulationInput('Eve_v3_Simulator');
sIn = sIn.setVariable('simin',simin);
sIn = sIn.setVariable('y_0', y_0);
sIn = sIn.setVariable('d', d);
sIn = sIn.setModelParameter('StopTime',string(240));
simulation = sim(sIn);
q = simulation.Q_imu.Data(:,:);
r = q(:,2:4)./q(:,1);

input = u2;
output = r;
model=lsim(sys,input,0:0.01:240);

% uncomment to see figures

% figure (3)
% subplot(4,1,1)
% plot(0:0.01:120,output(1:12001,2));
% hold on
% plot(0:0.01:120,model(1:12001,2));
% subplot(4,1,2)
% plot(0:0.01:120,input(1:12001,1));
% subplot(4,1,3)
% plot(0:0.01:120,input(1:12001,2));
% subplot(4,1,4)
% plot(0:0.01:120,input(1:12001,3));
% 
% 
% figure (4)
% subplot(4,1,1)
% plot(120:0.01:240,output(12001:24001,1));
% hold on
% plot(120:0.01:240,model(12001:24001,1));
% subplot(4,1,2)
% plot(120:0.01:240,input(12001:24001,1));
% subplot(4,1,3)
% plot(120:0.01:240,input(12001:24001,2));
% subplot(4,1,4)
% plot(120:0.01:240,input(12001:24001,3));