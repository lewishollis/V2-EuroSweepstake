class FriendsController < ApplicationController
  def index
    @friends = Friend.all
  end

  def profile_picture_url(friend_id)
    friend = Friend.find_by(id: friend_id)
    if friend
      friend.profile_picture_url
    else
      # Handle case where friend with given ID doesn't exist
      nil
    end

end
