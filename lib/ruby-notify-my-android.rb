require 'ruby-notify-my-android/request'
require 'ruby-notify-my-android/response'
require 'ruby-notify-my-android/notification'

# This is the main Notify My Andoid module

module NMA
  
  extend self
  
  def notify(notification = Notification.new)
    yield notification if block_given?
    Request.instance.call Request::Command::NOTIFY, notification.to_params
  end

  def verify(apikey)
    Request.instance.call Request::Command::VERIFY, "apikey=#{apikey}"
  end

  def valid_key?(key)
    result = verify(key)
    result.succeeded?
  end

  def remaining_calls(key)
    result = verify(key)
    return result.response["remaining"].to_i if result.succeeded?
    result.response["content"]
  end

  def version
    File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
  end
  
  VERSION = self.version

end