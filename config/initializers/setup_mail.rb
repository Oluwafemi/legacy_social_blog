
require 'development_mail_interceptor'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "abidaphotel.com",
  :user_name => "Oluwafemi@abidaphotel.com",
  :password => "gr8grace",
  :authentication => 'plain',
  :enable_starttls_auto => true 
}
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? 
