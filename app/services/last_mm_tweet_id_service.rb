class LastMmTweetIdService
  def self.fetch
    last_mm_tweet_id = REDIS.get('last_mm_tweet_id')

    if !last_mm_tweet_id
      client = Twitter::REST::Client.new do |config|
        config.consumer_key    = Rails.application.credentials.twitter[:key]
        config.consumer_secret = Rails.application.credentials.twitter[:secret]
      end

      last_mm_tweet_id = client.user_timeline('TIPMayerMultple', count: 1)[0].id

      REDIS.set('last_mm_tweet_id', last_mm_tweet_id)
      REDIS.expire('last_mm_tweet_id', 1.hour)
    end

    last_mm_tweet_id
  end
end
