%% 3D simulator - debug and draw

% initial positions
figure (11)
Q1_0 = [-0.007; 0.05302; 0.05302];
Q2_0 = [-0.007; 0.05302; -0.05302];

Q3_0 = [-0.007; -0.07498; 0];
Q4_0 = [-0.007; 0.07498; 0];

Q5_0 = [-0.007; -0.05302; 0.05302];
Q6_0 = [-0.007; -0.05302; -0.05302];


theta = [0; 0; 0];
P1 = [-0.436 - 0.1*sin(theta(1)); -0.0835; -1*0.021 + 0.1*cos(theta(1))];
P2 = [-0.436 + 0.1*sin(theta(1)); -0.0835; -1*0.021 - 0.1*cos(theta(1))];

P3 = [-0.323 - 0.140*sin(theta(2)); -0.140*cos(theta(2)); -1*0.0475];
P4 = [-0.323 + 0.140*sin(theta(2)); 0.140*cos(theta(2)); -1*0.0475];

P5 = [-0.436 + 0.1*sin(theta(3)); 0.0835; -1*0.021 + 0.1*cos(theta(3))];
P6 = [-0.436 - 0.1*sin(theta(3)); 0.0835; -1*0.021 - 0.1*cos(theta(3))];

X1 = [-0.2055; 0; 0.0525];
X2 = [-0.2055; 0; -0.0525];

X5 = X1;%[-0.2055; 0; 0.0625];
X6 = X2;%[-0.2055; 0; -0.0625];

all_points = [Q1_0 Q2_0 Q3_0 Q4_0 Q5_0 Q6_0];
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[1 0 0]);
all_points = [P1 P2 P3 P4 P5 P6 X1 X2 X5 X6];
hold on
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 1 0]);
hold on
line([P1(1),X1(1)],[P1(2),X1(2)],[P1(3),X1(3)],'Color','black', 'LineWidth', 2)
hold on
line([P2(1),X2(1)],[P2(2),X2(2)],[P2(3),X2(3)],'Color','black', 'LineWidth', 2)
hold on
line([X1(1),Q1_0(1)],[X1(2),Q1_0(2)],[X1(3),Q1_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X2(1),Q2_0(1)],[X2(2),Q2_0(2)],[X2(3),Q2_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P3(1),Q3_0(1)],[P3(2),Q3_0(2)],[P3(3),Q3_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P4(1),Q4_0(1)],[P4(2),Q4_0(2)],[P4(3),Q4_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P5(1),X5(1)],[P5(2),X5(2)],[P5(3),X5(3)],'Color','black', 'LineWidth', 2)
hold on
line([P6(1),X6(1)],[P6(2),X6(2)],[P6(3),X6(3)],'Color','black', 'LineWidth', 2)
hold on
line([X5(1),Q5_0(1)],[X5(2),Q5_0(2)],[X5(3),Q5_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X6(1),Q6_0(1)],[X6(2),Q6_0(2)],[X6(3),Q6_0(3)],'Color','black', 'LineWidth', 2)
xlabel('x');
ylabel('y');
zlabel('z');

% hexagon
hexagon_Q = [Q1_0 Q5_0 Q3_0 Q6_0 Q2_0 Q4_0];
fill3(hexagon_Q(1,:),hexagon_Q(2,:),hexagon_Q(3,:),'magenta')


% end positions
hold on
all_points = [Qi.Data(:,:,end)];
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 0 1]);
all_points = [Pi.Data(:,:,end) X1 X2 X5 X6];
hold on
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 0.5 0.5]);
P1 = Pi.Data(:,1,end);
P2 = Pi.Data(:,2,end);
P3 = Pi.Data(:,3,end);
P4 = Pi.Data(:,4,end);
P5 = Pi.Data(:,5,end);
P6 = Pi.Data(:,6,end);

Q1_0 = Qi.Data(:,1,end);
Q2_0 = Qi.Data(:,2,end);
Q3_0 = Qi.Data(:,3,end);
Q4_0 = Qi.Data(:,4,end);
Q5_0 = Qi.Data(:,5,end);
Q6_0 = Qi.Data(:,6,end);
hold on
line([P1(1),X1(1)],[P1(2),X1(2)],[P1(3),X1(3)],'Color','black', 'LineWidth', 2)
hold on
line([P2(1),X2(1)],[P2(2),X2(2)],[P2(3),X2(3)],'Color','black', 'LineWidth', 2)
hold on
line([X1(1),Q1_0(1)],[X1(2),Q1_0(2)],[X1(3),Q1_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X2(1),Q2_0(1)],[X2(2),Q2_0(2)],[X2(3),Q2_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P3(1),Q3_0(1)],[P3(2),Q3_0(2)],[P3(3),Q3_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P4(1),Q4_0(1)],[P4(2),Q4_0(2)],[P4(3),Q4_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P5(1),X5(1)],[P5(2),X5(2)],[P5(3),X5(3)],'Color','black', 'LineWidth', 2)
hold on
line([P6(1),X6(1)],[P6(2),X6(2)],[P6(3),X6(3)],'Color','black', 'LineWidth', 2)
hold on
line([X5(1),Q5_0(1)],[X5(2),Q5_0(2)],[X5(3),Q5_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X6(1),Q6_0(1)],[X6(2),Q6_0(2)],[X6(3),Q6_0(3)],'Color','black', 'LineWidth', 2)

hexagon_Q = [Q1_0 Q5_0 Q3_0 Q6_0 Q2_0 Q4_0];
fill3(hexagon_Q(1,:),hexagon_Q(2,:),hexagon_Q(3,:),'cyan')
% xlabel('x');
% ylabel('y');
% zlabel('z');


%%

% initial positions
figure (12)

angle_eye = 3*pi/2;
R_eye = [cos(angle_eye) -sin(angle_eye) 0; sin(angle_eye) cos(angle_eye) 0; 0 0 1];

Q1_0 = R_eye*[-0.00965; 0.00884; 0];
Q2_0 = R_eye*[0.01008; 0.0065; 0];

Q3_0 = R_eye*[0.00276; 0.00646; 0.01025];
Q4_0 = R_eye*[0.00176; 0.00685; -0.01022];

Q5_0 = R_eye*[0.00290; -0.008; 0.00882];
Q6_0 = R_eye*[0.008; -0.00918; 0];


theta = [0; 0; 0];
P1 = R_eye*[-0.017; -0.030; 0.001];
P2 = R_eye*[-0.013; -0.034; -0.001];

P3 = R_eye*[-0.015; -0.03176; 0.0036];
P4 = R_eye*[-0.017; -0.03176; -0.0024];

P5 = R_eye*[-0.018; -0.0315; 0.005];
P6 = R_eye*[-0.013; 0.010; -0.01546];

X1 = R_eye*[-0.014; -0.005; 0.00014];
X2 = R_eye*[0.012; -0.008; 0.00033];

X3 = R_eye*[-0.00516; -0.01078; 0.010];
X4 = R_eye*[-0.00516; -0.00878; -0.012];

X5 = R_eye*[-0.01527; 0.011; 0.01175];
X6 = R_eye*[-0.013; 0.010; -0.01546];

all_points = [Q1_0 Q2_0 Q3_0 Q4_0 Q5_0 Q6_0];
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[1 0 0]);
all_points = [P1 P2 P3 P4 P5 P6 X1 X2 X3 X4 X5 X6];
hold on
scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 1 0]);
hold on
line([P1(1),X1(1)],[P1(2),X1(2)],[P1(3),X1(3)],'Color','black', 'LineWidth', 2)
hold on
line([P2(1),X2(1)],[P2(2),X2(2)],[P2(3),X2(3)],'Color','black', 'LineWidth', 2)
hold on
line([X1(1),Q1_0(1)],[X1(2),Q1_0(2)],[X1(3),Q1_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X2(1),Q2_0(1)],[X2(2),Q2_0(2)],[X2(3),Q2_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P3(1),X3(1)],[P3(2),X3(2)],[P3(3),X3(3)],'Color','black', 'LineWidth', 2)
hold on
line([P4(1),X4(1)],[P4(2),X4(2)],[P4(3),X4(3)],'Color','black', 'LineWidth', 2)
hold on
line([X3(1),Q3_0(1)],[X3(2),Q3_0(2)],[X3(3),Q3_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X4(1),Q4_0(1)],[X4(2),Q4_0(2)],[X4(3),Q4_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([P5(1),X5(1)],[P5(2),X5(2)],[P5(3),X5(3)],'Color','black', 'LineWidth', 2)
hold on
line([P6(1),X6(1)],[P6(2),X6(2)],[P6(3),X6(3)],'Color','black', 'LineWidth', 2)
hold on
line([X5(1),Q5_0(1)],[X5(2),Q5_0(2)],[X5(3),Q5_0(3)],'Color','black', 'LineWidth', 2)
hold on
line([X6(1),Q6_0(1)],[X6(2),Q6_0(2)],[X6(3),Q6_0(3)],'Color','black', 'LineWidth', 2)
xlabel('x');
ylabel('y');
zlabel('z');

% hexagon
hexagon_Q = [Q1_0 Q5_0 Q3_0 Q6_0 Q2_0 Q4_0];
fill3(hexagon_Q(1,:),hexagon_Q(2,:),hexagon_Q(3,:),'magenta')

hold on
[x,y,z] = sphere; surf(x*0.012,y*0.012,z*0.012);
axis([-0.04 0.02 -0.04 0.02 -0.03 0.03])

% end positions
% hold on
% all_points = [Qi.Data(:,:,end)];
% scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 0 1]);
% all_points = [Pi.Data(:,:,end) X1 X2 X5 X6];
% hold on
% scatter3(all_points(1,:), all_points(2,:), all_points(3,:) ,'filled', 'MarkerFaceColor',[0 0.5 0.5]);
% P1 = Pi.Data(:,1,end);
% P2 = Pi.Data(:,2,end);
% P3 = Pi.Data(:,3,end);
% P4 = Pi.Data(:,4,end);
% P5 = Pi.Data(:,5,end);
% P6 = Pi.Data(:,6,end);
% 
% Q1_0 = Qi.Data(:,1,end);
% Q2_0 = Qi.Data(:,2,end);
% Q3_0 = Qi.Data(:,3,end);
% Q4_0 = Qi.Data(:,4,end);
% Q5_0 = Qi.Data(:,5,end);
% Q6_0 = Qi.Data(:,6,end);
% hold on
% line([P1(1),X1(1)],[P1(2),X1(2)],[P1(3),X1(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([P2(1),X2(1)],[P2(2),X2(2)],[P2(3),X2(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([X1(1),Q1_0(1)],[X1(2),Q1_0(2)],[X1(3),Q1_0(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([X2(1),Q2_0(1)],[X2(2),Q2_0(2)],[X2(3),Q2_0(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([P3(1),Q3_0(1)],[P3(2),Q3_0(2)],[P3(3),Q3_0(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([P4(1),Q4_0(1)],[P4(2),Q4_0(2)],[P4(3),Q4_0(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([P5(1),X5(1)],[P5(2),X5(2)],[P5(3),X5(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([P6(1),X6(1)],[P6(2),X6(2)],[P6(3),X6(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([X5(1),Q5_0(1)],[X5(2),Q5_0(2)],[X5(3),Q5_0(3)],'Color','black', 'LineWidth', 2)
% hold on
% line([X6(1),Q6_0(1)],[X6(2),Q6_0(2)],[X6(3),Q6_0(3)],'Color','black', 'LineWidth', 2)
% 
% hexagon_Q = [Q1_0 Q5_0 Q3_0 Q6_0 Q2_0 Q4_0];
% fill3(hexagon_Q(1,:),hexagon_Q(2,:),hexagon_Q(3,:),'cyan')
% xlabel('x');
% ylabel('y');
% zlabel('z');
