# app/models/friend.rb
class Friend < ApplicationRecord
  belongs_to :group, optional: true # Allows Friend to be created without a group
  has_many :teams, through: :friends_group
end
