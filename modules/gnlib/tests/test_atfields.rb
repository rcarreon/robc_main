require 'test/unit'
require File.dirname(__FILE__) + '/../lib/facter/atfields.rb'

    class TestAtFields < Test::Unit::TestCase
      # def setup
      # end

      # def teardown
      # end

      def test_net_post_request()
        assert_nothing_raised{ net_post_request("/REST/1.0/asset/1") }
      end

     def test_get_assetid()
       assert_nothing_raised{ get_assetid("deploy.gnmedia.net") }

       assert_nil get_assetid("fake-server")
     end

     def test_get_rt_data()
       assert_nothing_raised{ get_rt_data("deploy.gnmedia.net") }

       assert_nil get_rt_data("fake-server")

       asset_data = get_rt_data("deploy.gnmedia.net")
       
       if asset_data # if we got a successful response from RT
         assert(asset_data.has_key?("AT_CPU"))
         assert(asset_data.has_key?("AT_Memory"))
         assert(asset_data.has_key?("AT_Manufacturer"))
         assert(asset_data.has_key?("AT_Model"))
         assert(asset_data.has_key?("AT_SerialNumber"))
         assert(asset_data.has_key?("AT_Console"))
    	   assert(asset_data.has_key?("AT_Network"))
    	   assert(asset_data.has_key?("AT_OS"))
    	   assert(asset_data.has_key?("AT_OSVersion"))
    	   assert(asset_data.has_key?("AT_Site"))
    	   assert(asset_data.has_key?("AT_Silo"))
    	   assert(asset_data.has_key?("AT_RackPosition"))
    	   assert(asset_data.has_key?("AT_RackNumber"))
    	   assert(asset_data.has_key?("AT_PuppetVersion"))
    	   assert(asset_data.has_key?("AT_ServerStatus"))
	     end
     end

    end

