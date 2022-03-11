class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # weird to simply make one instance variable equal to another
    # but leaving in case I figure out how ot make all non-contacted users
    # different from suggested ones (which they should be)
    @users = @suggested_friends.limit(20)
  end

  def show
    @user = User.find(params[:id])
  end

end
