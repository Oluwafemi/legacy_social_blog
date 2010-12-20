
#require 'development_mail_interceptor'

#ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :domain => "mac-up.net",
#  :user_name => "corporate@mac-up.net",
#  :password => "godisgood",
#  :authentication => 'plain',
#  :enable_starttls_auto => true 
#}
#ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? 
