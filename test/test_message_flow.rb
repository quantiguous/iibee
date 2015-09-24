require 'minitest_helper'

class TestMessageFlow < Minitest::Test

  def test_it_gives_back_specific_message_flow
    VCR.use_cassette('TestMessageFlow_test_it_gives_back_specific_message_flow') do
      msg_flow = Iibee::MessageFlow.find_by(executionGroupName: 'Mock', name: @@msg_flow_name, options: @@broker_spec)
      assert_equal Iibee::MessageFlow, msg_flow.class
      assert_equal @@msg_flow_name, msg_flow.name
      assert_equal "Mock", msg_flow.executionGroupName
      assert_equal "Mock", msg_flow.executionGroup.name
    end
  end

  def test_it_gives_back_one_instance_of_the_msg_flow
    VCR.use_cassette('TestMessageFlow_test_it_gives_back_one_instance_of_the_message_flow') do
      msg_flow = Iibee::MessageFlow.find_by(executionGroupName: 'Mock', name: @@msg_flow_name, options: @@broker_spec)
      assert_equal Iibee::MessageFlow, msg_flow.class
      assert_equal @@msg_flow_name, msg_flow.name
      assert_equal "Mock", msg_flow.executionGroupName
    end
  end

  def test_it_gives_back_all_instances_of_a_msg_flow
    VCR.use_cassette('TestMessageFlow_test_it_gives_back_all_instances_of_a_message_flow') do
      msg_flows = Iibee::MessageFlow.where(name: @@msg_flow_name, options: @@broker_spec)
      executionGroups = ["Mock", "aml"]
      msg_flows.each do |msg_flow|
        assert_equal Iibee::MessageFlow, msg_flow.class
        assert_equal @@msg_flow_name, msg_flow.name
        assert_includes executionGroups, msg_flow.executionGroupName
      end
      assert_equal executionGroups.count, msg_flows.count
    end
  end

end