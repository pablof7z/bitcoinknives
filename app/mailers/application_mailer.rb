class ApplicationMailer < ActionMailer::Base
  default from: 'pablof7z <pablo@tx.bitcoinknives.com>'
  default reply_to: 'pablof7z <pfer@me.com>'
  layout 'mailer'
end
