class Group < ApplicationRecord
  has_many :friends
  has_and_belongs_to_many :teams
end
