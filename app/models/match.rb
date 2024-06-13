# app/models/match.rb
class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  validates :match_id, uniqueness: true
  attr_accessor :home_friend_name, :away_friend_name
end
