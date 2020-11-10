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
      address: 'mail.nic.ru',
      #address: 'smtp.catelecom.ru',
      #use_ssl: true,
      port: 25,
      domain: 'mail.nic.ru',
      #authentication: 'plain',
      #enable_starttls_auto: true,
      user_name: "sendertab@catelecom.ru",
      password: 'jc39vI71'
  }
end

# Initialize the Rails application.
Rails.application.initialize!
