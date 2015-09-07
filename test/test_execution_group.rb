require 'minitest_helper'

class TestExecutionGroup < Minitest::Test
  def test_it_gives_back_all_properties
    VCR.use_cassette('eg_aml', :record => :all) do
      eg = Iibee::ExecutionGroup.find_by_name('aml')
      assert_equal Iibee::ExecutionGroup, eg.class
    end
  end
end
