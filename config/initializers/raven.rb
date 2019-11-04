if Rails.env.production?
  puts "Empty RAVEN_URL environmental variable" if ENV['RAVEN_URL'].empty?

  Raven.configure do |config|
    config.dsn = ENV['RAVEN_URL']
  end
end
