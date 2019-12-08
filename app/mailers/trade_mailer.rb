class TradeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trade_mailer.new_trade_notification.subject
  #
  def new_trade_notification(trade)
    @trade = trade

    mail to: @trade.user_email
  end
end
