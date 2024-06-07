class GroupsController < ApplicationController
  def show
    @group = Group.find(params[:id])
    # Logic to show details of a specific group
  end

  def update
    @group = Group.find(params[:id])
    # Logic to update a group
  end

  def calculate_score
    @group = Group.find(params[:id])
    team_scores = @group.teams.sum(:points)
    @group_score = team_scores * @group.multiplier
  end


  def index
    @groups = Group.all
    # Logic to display a list of groups
  end
end
