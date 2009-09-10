require 'rubygems'
gem 'jferris-mocha', '0.9.5.0.1241126838'
require 'mocha'
require 'active_support'
require 'active_support/test_case'
require 'shoulda'
require 'geocode'

Geocode.gmaps_key = "test_gmaps_key"
Geocode.country = "Polska"
Geocode.unknown_state = "nieznane"
Geocode::Request.headers = { "Accept-Language" => "pl", "Accept-Charset" => "utf-8;q=0.7,*;q=0.7", "User-Agent" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; pl; rv:1.9.0.10) Gecko/2009042315 Firefox/3.0.10" }
