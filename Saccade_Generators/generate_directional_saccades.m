function [ all_goals ] = generate_directional_saccades( direction, range, steps )
%GENERATE_DIRECTIONAL_SACCADES Summary of this function goes here
%   Detailed explanation goes here

% range = 30; % change if necessary
% steps = 25; % change if necessary
all_goals = zeros(3,steps);

for j=1:steps
    goal = [j*range/steps*direction(1); j*range/steps*direction(2)];
    if norm(goal)>=5
        all_goals(2:3,j) = goal;
    end
end

all_goals( :, ~any(all_goals,1) ) = [];  % remove zero collumns

end

