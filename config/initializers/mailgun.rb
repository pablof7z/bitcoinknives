Mailgun.configure do |config|
  config.api_key = Rails.application.credentials.mailgun
  api_host = 'api.eu.mailgun.net'
end
