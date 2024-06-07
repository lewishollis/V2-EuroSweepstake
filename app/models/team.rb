# app/models/team.rb
class Team < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :matches_as_home_team, class_name: 'Match', foreign_key: 'home_team_id'
  has_many :matches_as_away_team, class_name: 'Match', foreign_key: 'away_team_id'


  def update_points(points)
    self.points = (self.points || 0) + points
    save!
  end
end
