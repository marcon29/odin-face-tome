class RegistrationsController < Devise::RegistrationsController
    
    def create
        super
        RegistrationMailer.welcome_email(@user).deliver_now
    end

    # def destroy
    #     super
    # end
end