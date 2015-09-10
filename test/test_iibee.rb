require 'minitest_helper'

class TestIibee < Minitest::Test
  @@broker_spec = {:scheme => 'http', :host => '10.211.55.4', :port => 4414}
  
  def test_that_it_has_a_version_number
    refute_nil ::Iibee::VERSION
  end

  def test_it_gives_back_a_single_broker
    VCR.use_cassette('broker') do
      broker = Iibee::Broker.find_by(options: @@broker_spec)
      assert_equal Iibee::Broker, broker.class
    end
  end
end
