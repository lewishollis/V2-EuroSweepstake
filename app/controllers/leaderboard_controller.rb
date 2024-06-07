class LeaderboardController < ApplicationController
  def index
    @leaderboard = Group.includes(:friend).map do |group|
      {
        name: group.friend.name,
        total_points: group.total_points
      }
    end.sort_by { |entry| -entry[:total_points] }
  end
end
