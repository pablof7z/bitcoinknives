class LastMmTweetIdService
  def self.fetch
    last_mm_tweet = REDIS.get('last_mm_tweet')

    if !last_mm_tweet
      client = Twitter::REST::Client.new do |config|
        config.consumer_key    = Rails.application.credentials.twitter[:key]
        config.consumer_secret = Rails.application.credentials.twitter[:secret]
      end

      last_mm_tweet = client.user_timeline(
        'TIPMayerMultple',
        count: 1,
        tweet_mode: 'extended'
      )[0].full_text

      REDIS.set('last_mm_tweet', last_mm_tweet)
      REDIS.expire('last_mm_tweet', 1.hour)
    end

    last_mm_tweet
  end
end
