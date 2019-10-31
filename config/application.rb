require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BitcoinknivesCom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

if Rails.env.production?
  Raven.configure do |config|
    config.dsn = 'https://5961ebea66ba4935ae1eb73c763a388b:f93e99a86faf487ca3d1b90c3403992d@sentry.io/1803835'
  end
end
