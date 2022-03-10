class RegistrationsController < Devise::RegistrationsController
    
    def create
        super
        RegistrationMailer.welcome_email(@user).deliver_now if @user.id
    end

    # def destroy
    #     super
    # end
end