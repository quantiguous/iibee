require 'minitest_helper'

class TestExecutionGroup < Minitest::Test

  def test_it_gives_back_specific_executionGroup
    VCR.use_cassette('TestExecutionGroup_test_it_gives_back_specific_executionGroup') do
      executionGroup = Iibee::ExecutionGroup.find_by(name: 'aml', options: @@broker_spec)
      assert_equal Iibee::ExecutionGroup, executionGroup.class
      assert_equal "aml", executionGroup.name
    end
  end

  def test_it_gives_back_all_instances_of_an_executionGroup
    VCR.use_cassette('TestExecutionGroup_test_it_gives_back_all_instances_of_an_executionGroup') do
      executionGroups = Iibee::ExecutionGroup.where(name: 'aml', options: @@broker_spec)
      assert_equal 1, executionGroups.count
      assert_equal Iibee::ExecutionGroup, executionGroups.first.class
      assert_equal 'aml', executionGroups.first.name
    end
  end
  
  def test_it_gives_back_all_executionGroups
    VCR.use_cassette('TestExecutionGroup_test_it_gives_back_all_executionGroups') do
      expectedExecutionGroups = ["Mock", "aml", "Q"]

      executionGroups = Iibee::ExecutionGroup.all(options: @@broker_spec)
      executionGroups.each do |executionGroup|
        assert_equal Iibee::ExecutionGroup, executionGroup.class
        assert_includes expectedExecutionGroups, executionGroup.name
      end
      assert_operator expectedExecutionGroups.count, :<=, executionGroups.count
    end
  end 
   
  def test_it_gives_back_all_properties
    VCR.use_cassette('TestExecutionGroup_test_it_gives_back_all_properties') do
      executionGroup = Iibee::ExecutionGroup.find_by(name: 'aml', options: @@broker_spec).properties
      assert_equal 'aml', executionGroup.label
    end
  end

end