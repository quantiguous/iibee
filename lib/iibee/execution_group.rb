require 'faraday'
require 'oga'

module Iibee
  class ExecutionGroup
    CONTEXT_PATH = "/executiongroups/"
    PROPERTIES_PATH = "/properties/"
    
    attr_reader :label, :runMode, :uuid
    
    def initialize(document)
      document.xpath('properties/basicProperties/property').each do |basicProperty|
        
        propertyName = basicProperty.get('name')
        propertyValue = basicProperty.get('value')
        
        instance_variable_set("@#{propertyName}", propertyValue)
      end
    end
    
    def self.all
    end
    
    def self.find_by_name(name)
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{name}/#{PROPERTIES_PATH}")
      document = Oga.parse_xml(response.body)
      new(document)        
    end
  end
end