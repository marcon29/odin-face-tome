class FriendsController < ApplicationController

  # list all friends for current_user
  def index
    # @friends = User.all.order(:last_name)
    @friends = current_user.friends.order(:last_name).order(:first_name)
  end

  # list all requests where current_user is either sender or receiver
  def requests
    @recieved_friend_requests = current_user.pending_request_senders.order(:last_name).order(:first_name)
    @sent_friend_requests = current_user.pending_request_receivers.order(:last_name).order(:first_name)
    @sent_count = @sent_friend_requests.count
  end
  
  # initiate requests by current_user as sender (add-friend process)
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

  # accept or reject request when current_user is receiver
  def update
  end

  # cancel request when current_user is sender, unfriend process by current_user
  def destroy
  end



  
end
