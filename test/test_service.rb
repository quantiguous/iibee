require 'minitest_helper'

class TestService < Minitest::Test
  def test_it_gives_back_all_properties
    VCR.use_cassette('eg_aml', :record => :all) do
      eg = Iibee::Service.find_by_name('aml','test')
      assert_equal Iibee::Service, eg.class
    end
  end
  
  def test_it_gives_back_all_services
    VCR.use_cassette('eg_aml', :record => :all) do
      services = Iibee::Service.all('aml')
      services.each do |service|
        assert_equal Iibee::Service, service.class
      end
    end
  end
end