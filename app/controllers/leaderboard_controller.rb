# app/controllers/leaderboard_controller.rb
class LeaderboardController < ApplicationController
  def index
    @friends = Friend.includes(friends_group: { teams: :home_matches }).all

    @leaderboard = @friends.map do |friend|
      {
        name: friend.name,
        total_points: friend.friends_group.total_points
      }
    end.sort_by { |entry| -entry[:total_points] }
  end
end
