class Group < ApplicationRecord
  has_and_belongs_to_many :teams
  belongs_to :friend, optional: true

  def total_points
    teams.sum(:points) * multiplier
  end

  def calculate_score
    self.score = total_points
  end
end
