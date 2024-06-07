class FriendsGroup < ApplicationRecord
  belongs_to :friend
  has_many :friend_group_teams
  has_many :teams, through: :friend_group_teams
end
