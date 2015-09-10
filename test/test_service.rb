require 'minitest_helper'

class TestService < Minitest::Test
  @@broker_spec = {:scheme => 'http', :host => '10.211.55.4', :port => 4414}
  def test_it_gives_back_specific_service
    VCR.use_cassette('test_it_gives_back_specific_service') do
      service = Iibee::Service.find_by(executionGroupName: 'aml', name: 'test', options: @@broker_spec)
      assert_equal Iibee::Service, service.class
      assert_equal "test", service.name
      assert_equal "aml", service.executionGroupName
      assert_equal "aml", service.executionGroup.name
    end
  end

  def test_it_gives_back_one_instance_of_the_service
    VCR.use_cassette('test_it_gives_back_one_instance_of_the_service') do
      service = Iibee::Service.find_by(executionGroupName: 'aml', name: 'test', options: @@broker_spec)
      assert_equal Iibee::Service, service.class
      assert_equal "test", service.name
      assert_equal "aml", service.executionGroupName
    end
  end

  def test_it_gives_back_all_instances_of_a_service
    VCR.use_cassette('test_it_gives_back_all_instances_of_a_service') do
      services = Iibee::Service.where(name: 'test', options: @@broker_spec)
      executionGroups = ["Mock", "aml"]
      services.each_with_index do |service, index|
        assert_equal Iibee::Service, service.class
        assert_equal "test", service.name
        assert_equal executionGroups[index], service.executionGroupName
      end
      assert_equal executionGroups.count, services.count
    end
  end

end