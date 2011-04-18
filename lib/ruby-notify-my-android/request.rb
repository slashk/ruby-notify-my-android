require 'net/https'
require 'singleton'

module NMA
  
  class Request
  
    include Singleton
    
    def initialize
      @url = "https://nma.usk.bz/publicapi/"
    end
    
    ## Make the actual call to the api
    def call(command, params)
      @command = command
      request = Net::HTTP::Get.new(uri.request_uri + "?" + params)
      response = http.request(request)
      Response.new(response)
    end
          
    private
    def http
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def uri
      URI.parse("#{@url}/#{@command}")
    end        
            
    module Command
      NOTIFY  = "notify"
      VERIFY  = "verify"
    end
    
  end

end