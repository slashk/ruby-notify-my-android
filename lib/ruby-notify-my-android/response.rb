require 'rubygems'
require 'xmlsimple'

module NMA

  # A wrapper around the API response.
  class Response

    # The response body.
    attr_accessor :raw

    # The HTTP status code of the response.
    attr_accessor :code

    # A hash of the returned XML response
    attr_accessor :body
    
    attr_accessor :remaining

    def initialize(response)
      self.raw = response.body
      self.code = response.code
      self.body = XmlSimple.xml_in(response.body)
      self.remaining = self.body.remaining
    end

    def to_hash
      XmlSimple.xml_in(xml)
    end

    def valid?
      code == 200
    end

    def succeeded?
      code == 200
    end

    def message
    end

    def xml
      @xml ||= self.body
    end
  end
end