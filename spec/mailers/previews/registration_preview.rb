# Preview all emails at http://localhost:3000/rails/mailers/registration
class RegistrationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/registration/welcome_email
  def welcome_email
    RegistrationMailer.welcome_email(User.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/registration/password_reset_email
  def password_reset_email
    RegistrationMailer.password_reset_email(User.first)
  end

end
