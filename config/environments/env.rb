config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "MyElectOne.mail",
  :user_name => "favourfield@gmail.com",
  :password => "vi90bility",
  :authentication => 'plain',
  :enable_starttls_auto => true 
}
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? 
