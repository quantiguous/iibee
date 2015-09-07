require "iibee/version"
require "iibee/configuration"
require "iibee/broker"
require "iibee/execution_group"
require "iibee/service"
require "iibee/application"

module Iibee
  class << self
    attr_writer :configuration
  end
  
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
