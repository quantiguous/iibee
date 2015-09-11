$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'iibee'

require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures"
  c.hook_into :webmock
  c.default_cassette_options = {:record => :new_episodes}
end

class Minitest::Test
  @@broker_spec = {:scheme => 'http', :host => '10.211.55.7', :port => 4424, :user => 'wmbadmin1', :password => 'wmbadmin1pw'}
end