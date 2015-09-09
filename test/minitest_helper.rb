$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
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

Iibee.configure do |config|
  config.base_url = "http://10.211.55.4:4414/"
end