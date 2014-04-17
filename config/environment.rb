# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Uhoused2::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: 'donotreply@uhoused.com',
  password: 'uhousedbrogiraffe',
  authentication: 'plain',
  enable_starttls_auto: true
}