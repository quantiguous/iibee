require "iibee/version"
require "iibee/broker"
require "iibee/configuration"

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
