# Preview all emails at http://localhost:3000/rails/mailers/trade_mailer
class TradeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/trade_mailer/new_trade_notification
  def new_trade_notification
    TradeMailer.new_trade_notification(Trade.last)
  end

end
