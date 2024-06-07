class TeamsController < ApplicationController
  def index
    @teams = Team.order(points: :desc)
    # Optionally, you can calculate the scores here if they're not stored directly in the database
    @teams.each do |team|
      team.calculate_score # Assuming you have a method to calculate the score for each team
    end
  end
end
