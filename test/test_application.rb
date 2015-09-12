require 'minitest_helper'

class TestApplication < Minitest::Test
  @@broker_spec = {:scheme => 'http', :host => '10.211.55.4', :port => 4414}
  def test_it_gives_back_specific_application
    VCR.use_cassette('TestApplication_test_it_gives_back_specific_application') do
      application = Iibee::Application.find_by(executionGroupName: 'aml', name: 'Example', options: @@broker_spec)
      assert_equal Iibee::Application, application.class
      assert_equal "Example", application.name
      assert_equal "aml", application.executionGroupName
      assert_equal "aml", application.executionGroup.name
    end
  end

  def test_it_gives_back_one_instance_of_the_application
    VCR.use_cassette('TestApplication_test_it_gives_back_one_instance_of_the_application') do
      application = Iibee::Application.find_by(executionGroupName: 'aml', name: 'Example', options: @@broker_spec)
      assert_equal Iibee::Application, application.class
      assert_equal "Example", application.name
      assert_equal "aml", application.executionGroupName
    end
  end

  def test_it_gives_back_all_instances_of_a_application
    VCR.use_cassette('TestApplication_test_it_gives_back_all_instances_of_a_application') do
      applications = Iibee::Application.where(name: 'Example', options: @@broker_spec)
      executionGroups = ["Mock", "aml"]
      applications.each_with_index do |application, index|
        assert_equal Iibee::Application, application.class
        assert_equal "Example", application.name
        assert_equal executionGroups[index], application.executionGroupName
      end
      assert_equal executionGroups.count, applications.count
    end
  end

end