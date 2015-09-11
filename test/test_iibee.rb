require 'minitest_helper'

class TestIibee < Minitest::Test
  
  def test_that_it_has_a_version_number
    refute_nil ::Iibee::VERSION
  end

  def test_it_gives_back_a_single_broker
    VCR.use_cassette('TestIibee_test_it_gives_back_a_single_broker') do
      broker = Iibee::Broker.find_by(options: @@broker_spec)
      assert_equal Iibee::Broker, broker.class
    end
  end
end
