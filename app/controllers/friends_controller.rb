class FriendsController < ApplicationController
  def index
    @friends = User.all.order(:last_name)
    # @friends = current_user.friends.order(:last_name)
  end

  def new
  end

  def create
  end

  def destroy
  end


  
end
