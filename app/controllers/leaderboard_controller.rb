class LeaderboardController < ApplicationController
  def index
    @groups = Group.includes(:teams, :friend).all
  end

  def update_team_progress
    team = Team.find(params[:id])
    team.update(progressed: !team.progressed?)
    redirect_to leaderboard_index_path
  end
end
