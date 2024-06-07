class FriendsGroup < ApplicationRecord

  has_many :friend_group_teams
  has_many :teams, through: :friend_group_teams
  belongs_to :friend
end
