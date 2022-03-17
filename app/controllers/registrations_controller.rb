class RegistrationsController < Devise::RegistrationsController
    # skip_before_filter :verify_authenticity_token, only: :create

    def create
        super
        RegistrationMailer.welcome_email(@user).deliver_now if @user.id
    end

    # holding this as commented for creating a confirmation email
    # def destroy
    #     super
    # end
end