class UserMailer < ActionMailer::Base
  default from: "Charity Map <team@charity-map.org>"

  def send_auth_token(user)
    @user = user
    mail(to: @user.email, subject: "Thông tin tài khỏan của bạn tại charity-map.org")
  end
end
