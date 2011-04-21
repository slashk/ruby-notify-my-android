begin
  require 'xmlsimple'
rescue LoadError
  STDERR.puts "No valid xml-simple library detected, please install one of 'xml-simple'."
  exit -2
end


module NMA

  # A wrapper around the API response.
  class Response

    # The response body.
    attr_accessor :raw

    # The HTTP status code of the response.
    attr_accessor :code

    # A hash of the returned XML response
    attr_accessor :body

    # A hash of the cooked XML
    attr_accessor :response

    def initialize(response)
      self.raw = response.body
      self.code = response.code
      self.body = XmlSimple.xml_in(response.body)
      self.response = self.body[self.body.keys.first].first
    end

    def succeeded?
      self.response["code"] == "200"
    end

  end

end