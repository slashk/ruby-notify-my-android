require 'cgi'

module NMA

  class Notification

    ## EXCEPTIONS
    class NoAPIKeyGiven < RuntimeError; end
    class NoDescriptionGiven < RuntimeError; end
    class NoApplicationNameGiven < RuntimeError; end

    attr_accessor :application, :description
    attr_accessor :providerkey, :priority, :event, :url
    attr_writer :apikey

    def apikey
      if @apikey.is_a? Array
        @apikey.join(',')
      else
        @apikey
      end
    end

    def initialize(params = {})
      @apikey = params[:apikey]
      @application  = params[:application]  || "NMA"
      @event        = params[:event]        || "NMA is working!!"
      @description  = params[:description]  || "This is the default description"
      @priority     = params[:priority]     || Priority::NORMAL
      @url          = params[:url]          || nil
    end

    def to_params
      raise NoAPIKeyGiven if apikey.nil?
      raise NoApplicationNameGiven if @application.nil?
      raise NoDescriptionGiven if @description.nil?
      params.join('&')
    end

    private
    def params
      attributes = []
      instance_variables.each do |var|
        raw_attr = "#{var.to_s.sub('@','')}"
        value = send("#{raw_attr}")
        next if value.nil?
        attributes << "#{raw_attr}=" + CGI.escape(value.to_s)
      end
      attributes.sort
    end

  end

  class Priority
     VERY_LOW  = -2
     MODERATE  = -1
     NORMAL    = 0
     HIGH      = 1
     EMERGENCY = 2
  end
  
end
