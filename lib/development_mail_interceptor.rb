class DevelopmentMailInterceptor

  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "favourfield@gmail.com"
  end
end
