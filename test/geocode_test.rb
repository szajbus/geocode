require 'test_helper'

class GeocodeTest < ActiveSupport::TestCase
  
  context "with default country set" do
    setup { Geocode.country = "Polska" }

    should "append country" do
      assert_equal "Warszawa, Polska", Geocode.append_country("Warszawa")
    end
  end
  
  context "with default country not set" do
    setup { Geocode.country = nil }

    should "not append country" do
      assert_equal "Warszawa", Geocode.append_country("Warszawa")
    end
  end
  
  context "when requesting coords for location" do
    setup do
      Geocode.stubs(:append_country).returns("Warszawa, Woronicza 1, Polska")
      request = Geocode::Request.new(:query => "Warszawa, Woronicza 1, Polska")
      Geocode::Request.stubs(:new).returns(request)
      Geocode::Request.stubs(:execute!).returns(nil)
      Geocode.coords("Warszawa, Woronicza 1")
    end

    should "try to append country" do
      assert_received(Geocode, :append_country) { |expect| expect.with("Warszawa, Woronicza 1") }
    end
    
    should "build correct request" do
      assert_received(Geocode::Request, :new) { |expect| expect.with(:query => Geocode.append_country("Warszawa, Woronicza 1, Polska"), :key => Geocode.gmaps_key, :sensor => false, :output => "csv") }
    end
  end
  
  context "when requesting state for city" do
    setup do
      Geocode.stubs(:append_country).returns("Warszawa, Polska")
      request = Geocode::Request.new(:query => "Warszawa, Polska")
      Geocode::Request.stubs(:new).returns(request)
      Geocode::Request.stubs(:execute!).returns(nil)
      Geocode.state("Warszawa")
    end

    should "try to append country" do
      assert_received(Geocode, :append_country) { |expect| expect.with("Warszawa") }
    end
    
    should "build correct request" do
      assert_received(Geocode::Request, :new) { |expect| expect.with(:query => Geocode.append_country("Warszawa, Polska"), :output => "json") }
    end
  end
  
end
