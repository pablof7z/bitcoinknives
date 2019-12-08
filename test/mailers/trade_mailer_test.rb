require 'test_helper'

class TradeMailerTest < ActionMailer::TestCase
  test "new_trade_notification" do
    mail = TradeMailer.new_trade_notification
    assert_equal "New trade notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
