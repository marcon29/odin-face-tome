class FriendsController < ApplicationController
  def index
    # @friends = User.all.order(:last_name)
    @friends = current_user.friends.order(:last_name).order(:first_name)
  end

  def requests
    @recieved_friend_requests = current_user.pending_request_senders.order(:last_name).order(:first_name)
    @sent_friend_requests = current_user.pending_request_receivers.order(:last_name).order(:first_name)
    @sent_count = @sent_friend_requests.count
  end

  

  def new
  end

  def create
    receiver = User.find(params[:user][:id])
    request = current_user.initialize_friend_request(receiver)
    
    if request.save
      flash[:notice] = "Your friend request has been sent."
      redirect_to user_path(receiver)
    else
      flash[:notice] = "Something went wrong. Try your request again."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
  end



  
end
