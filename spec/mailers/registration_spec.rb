require "rails_helper"

RSpec.describe RegistrationMailer, type: :mailer do
  describe "welcome_email" do
    let(:mail) { RegistrationMailer.welcome_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_reset_email" do
    let(:mail) { RegistrationMailer.password_reset_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
