require 'geocode/request'

module Geocode
  class << self
    
    mattr_accessor :country, :unknown_state, :gmaps_key, :logger
    
    # returns hash containing coordinates of the location
    def coords(location)
      location = append_country(location)
      request = Request.new(:query => location, :key => Geocode.gmaps_key, :sensor => false, :output => "csv")
      coords = { :response => request.execute! }
      coords[:http_status], coords[:accuracy], coords[:lat], coords[:lng] = coords[:response].split(",")
      coords
    end

    # returns name of the city's state
    def state(city)
      city = append_country(city)
      request = Request.new(:query => city, :output => "json")
      response = JSON.parse(request.execute!)
      if response["Status"]["code"] == 200
        response["Placemark"][0]["AddressDetails"]["Country"]["AdministrativeArea"]["AdministrativeAreaName"]
      else
        Geocode.unknown_state
      end
    rescue
      Geocode.unknown_state
    end
    
    def append_country(string)
      Geocode.country && !string.ends_with?(Geocode.country) ? "#{string}, #{Geocode.country}" : string
    end
  end
end