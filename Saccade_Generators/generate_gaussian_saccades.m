function [ all_goals_origin, all_goals_sequence ] = generate_gaussian_saccades( std_dev, numb)
%GENERATE_GAUSSIAN_SACCADES Summary of this function goes here
%   Detailed explanation goes here

all_goals = [zeros(1,numb); normrnd(0,std_dev,[2,numb])];

all_goals_origin = all_goals;

old_position = [0;0;0];
for i=1:size(all_goals,2)
    goal = all_goals(:,i);
    d_u = (goal-old_position)/(norm(goal-old_position));
    goal_ = old_position + d_u*norm(goal);
    %     if norm(goal_) > 0.3 %33 degrees
    %         goal_ = 0.3*goal_/norm(goal_);
    %     end
    old_position = goal_;
    all_goals(:,i) = goal_;
end 

all_goals_sequence = all_goals;

end



