# Preview all emails at http://localhost:3000/rails/mailers/registration
class RegistrationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/registration/welcome_email
  def welcome_email
    RegistrationMailer.welcome_email(User.first)
  end

end
