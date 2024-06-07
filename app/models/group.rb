class Group < ApplicationRecord
  belongs_to :friend
  has_and_belongs_to_many :teams

  def total_points
    teams.sum(:points) * multiplier
  end
end
