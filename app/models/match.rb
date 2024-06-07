# app/models/match.rb
class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  def update_team_points
    if winner == 'home'
      home_team.update_points(3)
      away_team.update_points(0)
    elsif winner == 'away'
      home_team.update_points(0)
      away_team.update_points(3)
    else
      home_team.update_points(1)
      away_team.update_points(1)
    end
  end
end
