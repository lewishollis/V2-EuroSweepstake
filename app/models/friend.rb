# app/models/friend.rb
class Friend < ApplicationRecord
  belongs_to :group
  has_one :friends_group
  has_many :teams, through: :friends_group
end
