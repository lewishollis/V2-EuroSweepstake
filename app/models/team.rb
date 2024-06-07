# app/models/team.rb
class Team < ApplicationRecord
  has_many :home_matches, class_name: 'Match', foreign_key: 'home_team_id'
  has_many :away_matches, class_name: 'Match', foreign_key: 'away_team_id'
  has_and_belongs_to_many :groups

  before_save :update_group_scores, if: :will_save_change_to_points?

  private

  def update_group_scores
    groups.each do |group|
      group.calculate_score
      group.save!
    end
  end
end
