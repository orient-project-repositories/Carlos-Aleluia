function [ all_goals ] = generate_uniform_saccades( range, steps, sequence )
%GENERATE_UNIFORM_SACCADES Summary of this function goes here
%   Detailed explanation goes here

delta_angle = range/steps;
all_goals=[];
for i=-steps:steps
    for j=-steps:steps
        %j = 0;
        if abs(i*delta_angle) == 0 && abs(j*delta_angle) == 0

        else
            %all_goals = [all_goals; 0 delta_angle*j delta_angle*i];
            all_goals=[all_goals;0 normrnd(0,10) normrnd(0,10)];
        end
    end
end

all_goals = all_goals(randperm(length(all_goals)),:)';


end

