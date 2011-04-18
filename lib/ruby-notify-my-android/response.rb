# require 'xmlsimple'

module NMA

  # A wrapper around the API response.
  class Response

    # The response body.
    attr_accessor :body

    # The HTTP status code of the response.
    attr_accessor :code

    def initialize(response)
      self.body = response.body
      self.code = response.code
    end

    def to_hash
      # Hash.from_xml(xml)
      XmlSimple.xml_in(xml)
    end

    def valid?
      code == 200
    end

    def xml
      @xml ||= Document.new(self.body)
    end
  end
end