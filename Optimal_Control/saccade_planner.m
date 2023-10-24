function [ optimal_input, saccade_duration ] = saccade_planner( sys, goal, y_0, ene_dur_terms, lp_constraint, symmetry, Qf, u_ini )
%SACCADE_PLANNER Summary of this function goes here
%   Detailed explanation goes here




Ts = 0.01;                          % sampling time
minimum_saccade_duration = 0.03;    % minimum saccade time
duration = 1;                       % complete movement time
y_des = goal;                       % r_x, r_y and r_z components

% if no restriction is done on r_x, y_des has less components
if strcmp(lp_constraint,'none') == 1
    delta = eye(3);
    delta = delta(2:3,:);
    y_des = delta*goal;
end
Tc = 0.01;                          % command time
number_time_lengths = 30;           % number of iterations on p

% maximum saccade duration = minimum + number_time_lengths*Tc



% COST WEIGHTS

if strcmp(lp_constraint,'none') == 1
    % cost function weights
    lambda_1 = 100000/100000; % position weight
    lambda_2 = 1*10^-07; % energy coefficient
    lambda_3 = 2*10^-03; % time weight
    lambda_4 = 1*10^2;%1*10^4; % equilibrium weight
    
    % time discount factor
    beta = 1/30;    

    if strcmp(symmetry,'asymmetrical') == 1
        lambda_5 = 1*10^-03;
    end
    
elseif strcmp(lp_constraint,'target') == 1
    lambda_1 = 1; % position weight
    lambda_2 = 1*10^-07; % energy coefficient
    lambda_3 = 6*10^-03; % time weight
    lambda_4 = 1000; % equilibrium weight

    % time discount factor
    beta = 1/120;
    
elseif strcmp(lp_constraint,'trajectory') == 1
    lambda_1 = 1; % position weight
    lambda_2 = 1*10^-06; % energy coefficient
    lambda_3 = 3*10^-03;
    lambda_4 = 100; % equilibrium coefficient

    beta = 1/50;
    
end

if strcmp(ene_dur_terms,'ae') == 1
    lambda_3 = 0;
    number_time_lengths = 20;
elseif strcmp(ene_dur_terms,'ad') == 1
    lambda_2 = 0;
    minimum_saccade_duration = 0.1;
end


ss_discrete = d2d(sys,Ts); %convert continuos to discrete
A = ss_discrete.A;
B = ss_discrete.B;
C = ss_discrete.C;
d = 3; % dimension



% get x_des and x_0
phi = C*((eye(6)-A)\B);
u_0 = phi\y_0;
x_0 = (eye(6)-A)\B*u_0;



extra_cycles = 0;

% if number of iterations is too big, can overcome the full duration
if (duration-minimum_saccade_duration)/Tc < number_time_lengths
    number_time_lengths = round((duration-minimum_saccade_duration)/Tc);
end

% pre allocation
cost_function = zeros(number_time_lengths,1);
cost_function_1 = zeros(number_time_lengths,1);
cost_function_2 = zeros(number_time_lengths,1);
cost_function_3 = zeros(number_time_lengths,1);
cost_function_4 = zeros(number_time_lengths,1);
if strcmp(symmetry,'asymmetrical') == 0
    cost_function_5 = zeros(number_time_lengths,1);
end
u_optimal = zeros(d*round((minimum_saccade_duration + number_time_lengths * Tc)/Tc) + extra_cycles*d, number_time_lengths);


% outer optimization on time
for p=0:number_time_lengths - 1
    number_cycles = round((minimum_saccade_duration + p * Tc)/Tc) + extra_cycles;
    
    if strcmp(lp_constraint,'trajectory') == 1
        y_des = zeros(d*number_cycles,1);
    end
    
    G = zeros((d)*number_cycles, d*(number_cycles+1));
    F = zeros((d)*number_cycles, 2*d);
    for i=1:number_cycles
        
        if strcmp(lp_constraint,'trajectory') == 1
            % sigmoidal interpolation
            L = goal - y_0;
            k = 10/(minimum_saccade_duration + Tc*p);
            t0 = (minimum_saccade_duration + Tc*p)/2;
            t = i*Tc;
            y_des((i-1)*d+1:(i-1)*d+d) = L/(1+exp(-k*(t-t0))) + y_0;
        end
        
        
        J_line = zeros(2*d,d*(number_cycles+1));
        for j=0:number_cycles - 1
            if j<=i-1
                J_line(1:2*d,d*j+1:d*j+d) = A^(i-1-j)*B;
            else
                J_line(1:2*d,d*j+1:d*j+d) = zeros(2*d,d);
            end
        end
        J_line(1:2*d,d*(number_cycles)+1:d*(number_cycles)+d) = zeros(2*d,d);
        L_line = A^(i);
        G_line = C*J_line;
        F_line = C*L_line;
        G((d)*(i-1)+1:(d)*(i-1)+d,:) = G_line;
        F((d)*(i-1)+1:(d)*(i-1)+d,:) = F_line;
    end
    
    
    M = zeros(d*(number_cycles+1));
    for k=1:d
        M(k,k) = 1;
    end
    for k=d + 1:d*(number_cycles+1)
       M(k,k-d) = -1;
       M(k,k) = 1;
    end
    
    M_ = zeros(d*(number_cycles+1),1);
    
    if ~exist('u_ini','var')
        M_(1:3) = u_0;
    else
        M_(1:3) = u_ini;
    end
    
    
     % Equilibrium constraint
    Up = zeros(d,d*(number_cycles+1));
    Up(1:3,d*number_cycles+1:d*(number_cycles+1)) = eye(3);
    T_eq = B*Up-(eye(6)-A)*J_line;
    
    e = (eye(6)-A)*L_line*x_0;
    E = (eye(6)-A)*J_line-B*Up;
   
   
    
    % min 1/2 u^T H u + f^T u
    
    if strcmp(lp_constraint,'none') == 1
        position_term_squared = lambda_1 * ( (delta*G_line)'*(delta*G_line) );
    elseif strcmp(lp_constraint,'target') == 1
        position_term_squared = lambda_1 * ( G_line'*G_line );
    elseif strcmp(lp_constraint,'trajectory') == 1
        position_term_squared = lambda_1 * ( G'*G );
    end
        
    energy_term_squared = lambda_2*(M'*M);
    
    equilibrium_term_squared = lambda_4*(E'*E);
    
    
    if strcmp(lp_constraint,'none') == 1
        position_term_linear = lambda_1*2* (delta*G_line)'*( (delta*F_line) *x_0-y_des);
    elseif strcmp(lp_constraint,'target') == 1
        position_term_linear = lambda_1*2*G_line'*(F_line*x_0-y_des);
    elseif strcmp(lp_constraint,'trajectory') == 1
        position_term_linear = lambda_1*2*G'*(F*x_0-y_des);
    end
    
    energy_term_linear = -2*lambda_2*M'*M_;
    
    equilibrium_term_linear = lambda_4*2*E'*e;

    
    H = 2* ( position_term_squared + energy_term_squared + equilibrium_term_squared);
    f = position_term_linear + equilibrium_term_linear + energy_term_linear;
    
    if strcmp(symmetry,'asymmetrical') == 1
        force_term_squared = lambda_5*(G_line'*Qf*G_line);
        force_term_linear = lambda_5*G_line'*(Qf*F_line*x_0);
        H = H + 2*force_term_squared;
        f = f + force_term_linear;
    end
    
    options = optimoptions('quadprog','Display','off');
    
    u_optimal(1:d*(number_cycles+1), p + 1) = quadprog(H,f,[],[],[],[],[],[],[],options);

    if strcmp(lp_constraint,'none') == 1
        y_pred = (delta*G_line)*u_optimal(1:d*(number_cycles+1),p + 1)+ (delta*F_line)*x_0;
    elseif strcmp(lp_constraint,'target') == 1
        y_pred = G_line*u_optimal(1:d*(number_cycles+1),p + 1)+ F_line*x_0;
    elseif strcmp(lp_constraint,'trajectory') == 1
        y_pred = G*u_optimal(1:d*(number_cycles+1),p + 1)+ F*x_0;
    end
    
    cost_function_1(p + 1) = lambda_1*norm(y_pred - y_des)^2;
    cost_function_2(p + 1) = lambda_2*u_optimal(1:d*(number_cycles+1),p + 1)'*M'*M*u_optimal(1:d*(number_cycles+1),p + 1) + energy_term_linear'*u_optimal(1:d*(number_cycles+1),p+1);
    cost_function_3(p + 1) = lambda_3*(1-1/(1 + beta*p));
    cost_function_4(p + 1) = u_optimal(1:d*(number_cycles+1),p+1)'*equilibrium_term_squared*u_optimal(1:d*(number_cycles+1),p+1) + equilibrium_term_linear'*u_optimal(1:d*(number_cycles+1),p+1) + lambda_4*(e'*e);
    cost_function(p + 1) = cost_function_1(p + 1) + cost_function_2(p + 1) + cost_function_4(p + 1) + cost_function_3(p + 1);
    
    if strcmp(symmetry,'asymmetrical') == 1
        y_pred_full = G_line*u_optimal(1:d*(number_cycles+1),p + 1)+ F_line*x_0;
        cost_function_5(p + 1) = lambda_5*(y_pred_full'*Qf*y_pred_full);
        %cost_function(p + 1) = cost_function(p + 1) + cost_function_5(p + 1);
    end
   
end
[~,P] = min(cost_function); % find best p
% figure (11)
% plot(30:10:320,cost_function_1)
% hold on
% plot(30:10:320,cost_function_2)
% hold on
% plot(30:10:320,cost_function_3)
% hold on
% plot(30:10:320,cost_function)
% hold on
% scatter((minimum_saccade_duration+(P-1)*Tc)*1000,cost_function(P),'MarkerEdgeColor',[0 0 0])
% legend('J_A','J_E','J_D','J_{AED}');
% xlabel('p')
% ylabel('J')


optimal_input = timeseries();
K = round((minimum_saccade_duration + (P-1)*Tc)/Tc);
for j=1:d*round(duration/Tc)
    if j<=K
        optimal_input = addsample(optimal_input,'Data',u_optimal(d*(j-1)+1:d*(j-1)+d,P),'Time',(j-1)*Tc);
    else
        optimal_input = addsample(optimal_input,'Data',u_optimal(d*K+1:d*K+d,P),'Time',(j-1)*Tc);
        %simin = addsample(simin,'Data',u_inf,'Time',(j-1)*Tc);
    end
end

saccade_duration = minimum_saccade_duration+(P-1)*Tc;


end

