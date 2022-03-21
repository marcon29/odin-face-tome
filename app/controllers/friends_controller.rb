class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.friends.order(:last_name).order(:first_name)
  end

  def requests
    @recieved_friend_requests = current_user.pending_request_senders.order(:last_name).order(:first_name)
    @sent_friend_requests = current_user.pending_request_receivers.order(:last_name).order(:first_name)
    @sent_count = @sent_friend_requests.count
  end
  
  def create
    request = current_user.initialize_friend_request(@other_user)
    
    if request.save
      get_message_redirect(:add)
    else
      get_message_redirect(:failure)
    end
  end

  def update
    request = current_user.decide_friend_request(@other_user, params[:user][:friend_action])

    if params[:user][:friend_action] == @accept_values[:friend_action] && request.save
      get_message_redirect(:accept)
    elsif params[:user][:friend_action] == @reject_values[:friend_action] && request.save
      get_message_redirect(:reject)
    elsif params[:user][:friend_action] == @block_values[:friend_action] && request.save
      get_message_redirect(:block)
    else
      get_message_redirect(:failure)
    end
  end

  def destroy
    current_user.cancel_friendship_or_request(@other_user)
    
    if params[:user][:friend_action] == @cancel_values[:friend_action]
      get_message_redirect(:cancel)
    elsif params[:user][:friend_action] == @ignore_values[:friend_action]
      get_message_redirect(:ignore)
    elsif params[:user][:friend_action] == @unfriend_values[:friend_action]
      get_message_redirect(:unfriend)
    else
      get_message_redirect(:failure)
    end
  end

  private

  def get_message_redirect(friend_action)
    if friend_action == :failure
      flash[:notice] = "Something went wrong. Try your request again."
      redirect_back(fallback_location: root_path)
    else
      flash[:notice] = @friend_request_options[friend_action][:notice_text]
      redirect_to requests_friends_path
    end
  end

end
