class RegistrationMailer < ApplicationMailer
  
  def welcome_email(user)
    @greeting = "Hi, #{user.first_name}"
    @user = user

    recipient = user.email
    subject = "Welcome #{user.first_name}! You Successfully Signed Up With FaceTOME"

    mail to: recipient, subject: subject
  end

end
