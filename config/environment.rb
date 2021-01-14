# Load the Rails application.
require File.expand_path('../application', __FILE__)
Vyplata::Application.configure do
  # config.action_mailer.delivery_method = :smtp
  #
  # config.action_mailer.smtp_setting = {
  #    address:              "smtp.gmail.com",
  #    port:                 587,
  #    domain:               "domain.of.sender.net",
  #    authentication:       "plain",
  #    user_name:            "@gmail.com",
  #    password:             "",
  #    enable_starttls_auto:  true
  # }
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: '',
      #address: '',
      #use_ssl: true,
      port: 25,
      domain: '',
      #authentication: 'plain',
      #enable_starttls_auto: true,
      user_name: "",
      password: ''
  }
end

# Initialize the Rails application.
Rails.application.initialize!
