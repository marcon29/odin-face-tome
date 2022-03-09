class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :logged_in?

    # this is just to get some variables working for main layout until models are set up
    def logged_in?
        false
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
    end
end
