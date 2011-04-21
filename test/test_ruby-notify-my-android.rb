require 'helper'

class TestRubyNotifyMyAndroid < Test::Unit::TestCase

  def setup
    @api_endpoint = "https://nma.usk.bz/publicapi/"
    @good_apikey = "9d0538ab7b52360e906e0e766f34501b69edde92fe3409e9"
    @bad_apikey = "9d0538ab7b52360e906e0e766f34501b69edde92fe3409e0"
    # verify endpoints and stubs
    good_verify_endpoint = @api_endpoint + "verify?apikey=" + @good_apikey
    bad_verify_endpoint = @api_endpoint + "verify?apikey=" + @bad_apikey
    good_verify_return = '<?xml version="1.0" encoding="UTF-8"?><nma><success code="200" remaining="799" resettimer="60" /></nma>'
    bad_verify_return = '<?xml version="1.0" encoding="UTF-8"?><nma><error code="401" >The API key is not valid.</error></nma>'
    stub_request(:get, good_verify_endpoint).
                      with(:headers => {'Accept'=>'*/*'}).
                      to_return(:body => good_verify_return, :status => 200)
    stub_request(:get, bad_verify_endpoint).
                      with(:headers => {'Accept'=>'*/*'}).
                      to_return(:body => bad_verify_return, :status => 200)
    # notify endpoints and stubs
    default_notify_params = "&application=NMA&description=This%20is%20the%20default%20description&event=NMA%20is%20working!!&priority=0"
    important_notify_params = "&application=NMA&description=This%20is%20the%20default%20description&event=NMA%20is%20working!!&priority=" + NMA::Priority::EMERGENCY.to_s
    good_notify_endpoint = @api_endpoint + "notify?apikey=" + @good_apikey + default_notify_params
    dbl_good_notify_endpoint = @api_endpoint + "notify?apikey=" + @good_apikey + "," + @good_apikey + default_notify_params
    bad_notify_endpoint = @api_endpoint + "notify?apikey=" + @bad_apikey + default_notify_params
    important_notify_endpoint = @api_endpoint + "notify?apikey=" + @good_apikey + important_notify_params
    good_notify_return = '<?xml version="1.0" encoding="UTF-8"?><nma><success code="200" remaining="790" resettimer="43" /></nma>'
    bad_notify_return = '<?xml version="1.0" encoding="UTF-8"?><nma><error code="401" >None of the API keys provided were valid.</error></nma>'
    stub_request(:get, good_notify_endpoint).
                    with(:headers => {'Accept'=>'*/*'}).
                    to_return(:status => 200, :body => good_notify_return, :headers => {})
    stub_request(:get, dbl_good_notify_endpoint).
                    with(:headers => {'Accept'=>'*/*'}).
                    to_return(:status => 200, :body => good_notify_return, :headers => {})
    stub_request(:get, bad_notify_endpoint).
                    with(:headers => {'Accept'=>'*/*'}).
                    to_return(:status => 200, :body => bad_notify_return, :headers => {})
    stub_request(:get, important_notify_endpoint).
                    with(:headers => {'Accept'=>'*/*'}).
                    to_return(:status => 200, :body => good_notify_return, :headers => {})
  end

  def test_should_verify_good_key
    result = NMA.verify(@good_apikey)
    assert_equal(true, result.succeeded?)
    assert_equal("200", result.code)
    assert_equal("799", result.response["remaining"])
    assert_equal("200", result.response["code"])
    assert_equal("60", result.response["resettimer"])
  end
  
  def test_should_verify_bad_but_valid_size_apikey
    result = NMA.verify(@bad_apikey)
    assert_equal("200", result.code)
    assert_equal("401", result.response["code"])
    assert_equal("The API key is not valid.", result.response["content"])
  end

  def test_should_notify
    result = NMA.notify do |n|
      n.apikey = @good_apikey
    end
    assert_equal("200", result.code)
    assert_equal("790", result.response["remaining"])
    assert_equal("200", result.response["code"])
    assert_equal("43", result.response["resettimer"])
  end

  def test_should_notify_with_multiple_keys
    result = NMA.notify do |n|
      n.apikey = [@good_apikey, @good_apikey]
    end
    assert_equal("200", result.code)
    assert_equal("790", result.response["remaining"])
    assert_equal("200", result.response["code"])
    assert_equal("43", result.response["resettimer"])
  end

  def test_should_not_notify_with_bad_apikey
    result = NMA.notify do |n|
      n.apikey = @bad_apikey
    end
    assert_equal("200", result.code)
    assert_equal("401", result.response["code"])
    assert_equal("None of the API keys provided were valid.", result.response["content"])
  end
  
  def test_should_not_notify_with_good_apikey
    result = NMA.notify do |n|
      n.apikey = @good_apikey
      n.priority = NMA::Priority::EMERGENCY
    end
    assert_equal("200", result.code)
  end

  def test_should_show_remaining_calls
    result = NMA.remaining_calls(@good_apikey)
    assert_equal(799, result)
  end

  def test_should_not_show_remaining_calls_with_bad_apikey
    result = NMA.remaining_calls(@bad_apikey)
    assert_equal("The API key is not valid.", result)
  end


  def test_for_valid_key
    assert_equal(true, NMA.valid_key?(@good_apikey))
  end

  def test_for_invalid_key
    assert_equal(false, NMA.valid_key?(@bad_apikey))
  end

  def test_version
    v = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
    assert_equal(v, NMA.version)
    assert_equal(NMA.version, NMA::VERSION)
  end

end
