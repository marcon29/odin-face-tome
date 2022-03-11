class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?    
    before_action :set_suggested_friends, :request_count
    
    def set_suggested_friends
        @suggested_friends = current_user.non_contacted_users.limit(6).order(:last_name).order(:first_name) if user_signed_in?
    end

    def request_count
        @request_count = current_user.pending_request_senders.count if user_signed_in?
    end
    
    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
    end
end
