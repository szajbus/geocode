require 'open-uri'
require 'cgi'

module Geocode
  class Request
    
    cattr_reader   :last_request_at
    cattr_accessor :gmaps_url, :headers
    @@gmaps_url = "http://maps.google.com/maps/geo"
    
    attr_reader :query, :params, :headers
    
    def initialize(*args)
      options = args.extract_options!
      
      @query   = options.delete(:query)
      @params  = options
      @headers = (@@headers || {}).update(options[:headers] || {})
    end
    
    def url
      params = @params.to_a.inject(["q=#{escape(query)}"]) { |params, pair| params << pair.join("=") }.join("&")
      "#{@@gmaps_url}?#{params}"
    end
    
    def escape(string)
      CGI::escape(string)
    end

    def execute!
      # sleep after request to prevent being accused of DoS attack
      sleep(1) unless @@last_request_at.nil? || (Time.now - @@last_request_at >= 1)
      @@last_request_at = Time.now
      if Geocode.logger
        Geocode.logger.info "Geocoding URL: #{url}"
      end
      open(URI.parse(url), headers).read
    end
    
  end
end