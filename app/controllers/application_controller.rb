class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_suggested_friends

    
    private    
    def set_suggested_friends
        @suggested_friends = User.all.where.not(id: current_user.id)
    end
    
    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
    end
end
