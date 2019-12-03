if Rails.env.production?
  Raven.configure do |config|
    config.dsn = Rails.application.credentials.config.raven
  end
end
