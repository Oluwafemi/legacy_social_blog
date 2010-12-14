class UserMailer < ActionMailer::Base
  default :from => "mac-up.net"
  default_url_options[:host] = "mac-up.net"

  def signup_confirmation(user)
    @user = user
    @url = user_url(user)
    attachments["welcome.png"] = File.read("#{Rails.root}/public/images/thank_you.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => 
                              "Thank you for signing up")
  end
end
