class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_suggested_friends, :request_count, :friend_request_form_options
    before_action :get_friend_action_values

    # ################ Post/Comment/Like Methods  ####################



    # ################ User/Registration/Session/Friend Methods  ####################
    def set_suggested_friends
        @suggested_friends = current_user.non_contacted_users.limit(6).order(:last_name).order(:first_name) if user_signed_in?
    end

    def request_count
        @request_count = current_user.pending_request_senders.count if user_signed_in?
    end

    def set_other_user
        @other_user = User.find(params[:user][:id]) if params[:user] && params[:user][:id]
    end

    def friend_request_form_options
        set_other_user

        @friend_request_options = {
            add:      { friend_action: "add",      method_verb: "post",   button_text: "Add Friend"            }, 
            accept:   { friend_action: "accepted", method_verb: "patch",  button_text: "Accept Friend Request" }, 
            reject:   { friend_action: "rejected", method_verb: "patch",  button_text: "Reject & Block"        }, 
            block:    { friend_action: "rejected", method_verb: "patch",  button_text: "Block"                 }, 
            cancel:   { friend_action: "cancel",   method_verb: "delete", button_text: "Cancel Friend Request" }, 
            ignore:   { friend_action: "ignore",   method_verb: "delete", button_text: "Ignore Request"        }, 
            unfriend: { friend_action: "unfriend", method_verb: "delete", button_text: "Unfriend"              }  
        }

        if @other_user
            @friend_request_options[:add][:notice_text]      = "Your friend request has been sent."
            @friend_request_options[:accept][:notice_text]   = "You and #{@other_user.full_name} are now friends. Yay friends!!!"
            @friend_request_options[:reject][:notice_text]   = "You've rejected and blocked #{@other_user.full_name}. Good call. I heard they were trouble."
            @friend_request_options[:block][:notice_text]    = "You've blocked #{@other_user.full_name}. It's for the best. You don't need people like that."
            @friend_request_options[:cancel][:notice_text]   = "Friend request to #{@other_user.full_name} was cancelled. You're right. It wasn't worth it."
            @friend_request_options[:ignore][:notice_text]   = "You've ignored #{@other_user.full_name}'s friend request. Maybe some other day."
            @friend_request_options[:unfriend][:notice_text] = "Your friendship with #{@other_user.full_name} was ended. They were a jerk anyways."
        end
    end

    def get_friend_action_values
        @add_values = @friend_request_options[:add]
        @accept_values = @friend_request_options[:accept]
        @reject_values = @friend_request_options[:reject]
        @block_values = @friend_request_options[:block]
        @cancel_values = @friend_request_options[:cancel]
        @ignore_values = @friend_request_options[:ignore]
        @unfriend_values = @friend_request_options[:unfriend]
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
    end
end
