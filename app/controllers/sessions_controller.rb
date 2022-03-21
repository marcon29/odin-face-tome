class SessionsController < Devise::SessionsController
    skip_before_action :redirect_if_not_signed_in, only: [:new, :create]
    
    # def new
    #     super
    # end
end