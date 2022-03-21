class RegistrationsController < Devise::RegistrationsController
    skip_before_action :redirect_if_not_signed_in, only: [:new, :create]

    def create
        super
        RegistrationMailer.welcome_email(@user).deliver_now if @user.id
    end
end