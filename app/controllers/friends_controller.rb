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
    other_user = User.find(params[:user][:id])
    request = current_user.initialize_friend_request(other_user)
    
    if request.save
      flash[:notice] = "Your friend request has been sent."
      redirect_to user_path(other_user)
    else
      flash[:notice] = "Something went wrong. Try your request again."
      redirect_back(fallback_location: root_path)
    end
  end

  # accept or reject request when current_user is receiver
  def update
    other_user = User.find(params[:user][:id])
    request = current_user.decide_friend_request(other_user, params[:user][:friend_action])

    if params[:user][:friend_action] == "accepted" && request.save
      flash[:notice] = "You and #{other_user.full_name} are now friends. Yay friends!!!"
      redirect_to requests_friends_path      
    elsif params[:user][:friend_action] == "rejected" && request.save
      flash[:notice] = "You have rejected #{other_user.full_name}'s friend request. Probably a good call."
      redirect_to requests_friends_path
    else
      flash[:notice] = "Something went wrong. Try your request again."
      redirect_back(fallback_location: root_path)
    end

  end

  # cancel request when current_user is sender, unfriend process by current_user
  def destroy
    other_user = User.find(params[:user][:id])

    current_user.cancel_friendship_or_request(other_user)
    # current_user.find_friendship_or_request(other_user)

    if params[:user][:friend_action] == "cancel"
      flash[:notice] = "Friend request to #{other_user.full_name} was cancelled."
      redirect_to requests_friends_path
    elsif params[:user][:friend_action] == "unfriend"
        flash[:notice] = "Your friendship with #{other_user.full_name} was ended."
        redirect_to root_path
    else
      flash[:notice] = "Something went wrong. Try your request again."
      redirect_back(fallback_location: root_path)
    end

  end



  
end
