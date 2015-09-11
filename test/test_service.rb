require 'minitest_helper'

class TestService < Minitest::Test

  def test_it_gives_back_specific_service
    VCR.use_cassette('TestService_test_it_gives_back_specific_service') do
      service = Iibee::Service.find_by(executionGroupName: 'aml', name: 'SocialBankingService', options: @@broker_spec)
      assert_equal Iibee::Service, service.class
      assert_equal "SocialBankingService", service.name
      assert_equal "aml", service.executionGroupName
      assert_equal "aml", service.executionGroup.name
    end
  end

  def test_it_gives_back_one_instance_of_the_service
    VCR.use_cassette('TestService_test_it_gives_back_one_instance_of_the_service') do
      service = Iibee::Service.find_by(executionGroupName: 'aml', name: 'SocialBankingService', options: @@broker_spec)
      assert_equal Iibee::Service, service.class
      assert_equal "SocialBankingService", service.name
      assert_equal "aml", service.executionGroupName
    end
  end

  def test_it_gives_back_all_instances_of_a_service
    VCR.use_cassette('TestService_test_it_gives_back_all_instances_of_a_service') do
      services = Iibee::Service.where(name: 'SocialBankingService', options: @@broker_spec)
      executionGroups = ["Mock", "aml"]
      services.each do |service|
        assert_equal Iibee::Service, service.class
        assert_equal "SocialBankingService", service.name
        assert_includes executionGroups, service.executionGroupName
      end
      assert_equal executionGroups.count, services.count
    end
  end

end