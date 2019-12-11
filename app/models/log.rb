class Log < ApplicationRecord
  class << self
    def exception(e)
      Log.create(message: e.message, backtrace: e.backtrace.join("\n"), severity: 'EXCEPTION')
    end

    def error(msg, args={})
      log = Log.new(message: msg)
      log.update(args)
    end
  end
end
