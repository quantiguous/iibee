require 'minitest_helper'

class TestService < Minitest::Test
  @@broker_spec = {:scheme => 'http', :host => '10.211.55.4', :port => 4414}

  def test_it_gives_back_specific_executionGroup
    VCR.use_cassette('test_it_gives_back_specific_executionGroups') do
      executionGroup = Iibee::ExecutionGroup.find_by(name: 'aml', options: @@broker_spec)
      assert_equal Iibee::ExecutionGroup, executionGroup.class
      assert_equal "aml", executionGroup.name
    end
  end

  def test_it_gives_back_all_instances_of_an_executionGroup
    VCR.use_cassette('test_it_gives_back_all_instances_of_an_executionGroups') do
      executionGroups = Iibee::ExecutionGroup.where(name: 'aml', options: @@broker_spec)
      assert_equal 1, executionGroups.count
      assert_equal Iibee::ExecutionGroup, executionGroups.first.class
      assert_equal 'aml', executionGroups.first.name
    end
  end
  
  def test_it_gives_back_all_executionGroups
    VCR.use_cassette('test_it_gives_back_all_executionGroups') do
      expectedExecutionGroups = ["Mock", "aml"]

      executionGroups = Iibee::ExecutionGroup.all(options: @@broker_spec)
      executionGroups.each_with_index do |executionGroup, index|
        assert_equal Iibee::ExecutionGroup, executionGroup.class
        assert_equal expectedExecutionGroups[index], executionGroup.name
      end
      assert_equal expectedExecutionGroups.count, executionGroups.count
    end
  end 
   
  def test_it_gives_back_all_properties
    VCR.use_cassette('test_it_gives_back_all_executionGroups') do
      executionGroup = Iibee::ExecutionGroup.find_by(name: 'aml', options: @@broker_spec).properties
      assert_equal 'aml', executionGroup.label
    end
  end

end