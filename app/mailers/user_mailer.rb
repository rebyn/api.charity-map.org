class UserMailer < ActionMailer::Base
  default from: "no-reply@charity-map.org"

  def send_auth_token(user)
    @user = user
    mail(to: @user.email, subject: "Your Authentication Token At Chaity-Map.Org")
  end
end
