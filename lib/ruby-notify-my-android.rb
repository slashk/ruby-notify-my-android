require 'ruby-notify-my-andoid/call'
require 'ruby-notify-my-andoid/response'

# This is the main Notify My Andoid module
#

module NMA
  
  extend self
  
  def notify(notification = Notification.new)
    yield notification if block_given?
    call.call Interface::Command::NOTIFY, notification.to_params
  end

  def verify(apikey)
    call.call Interface::Command::VERIFY, "apikey=#{apikey}"
  end

  def valid_key?(key)
    result = verify(key)
    result.succeeded?
  end
  
  def remaining_calls(key)
    result = verify(key)
    return result.remaining if result.succeeded?
    result.message
  end
  
  def version
    File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
  end
  
end