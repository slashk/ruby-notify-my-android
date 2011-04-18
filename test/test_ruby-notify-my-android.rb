require 'helper'

class TestRubyNotifyMyAndroid < Test::Unit::TestCase

  def test_should_verify_good_key
    flunk "hey buddy, you should probably rename this file and start testing for real"
  end
  
  def test_should_verify_bad_but_valid_size_apikey
    flunk("not apikey size")
  end

  def test_should_not_call_for_verify_on_bad_apikey_size
    flunk("apikey size no call")
  end

  def test_should_notify
    flunk("notify test")
  end

  def test_should_not_notify_without_apikey
    flunk("not notify test")
  end
  
  def test_parse_response_correctly
    flunk("parsing")
  end

end
