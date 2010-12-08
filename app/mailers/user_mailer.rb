class UserMailer < ActionMailer::Base
  default :from => "admin@localhost.com"
  default_url_options[:host] = "localhost:3000"

  def signup_confirmation(user)
    @user = user
    @url = user_url(user)
    attachments["welcome.png"] = File.read("#{Rails.root}/public/images/thank_you.png")
    mail(:to => user.email, :subject => 
                              "Thank you for signing up")
  end
end
