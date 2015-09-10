require 'faraday'
require 'oga'
require 'logger'

module Iibee
  class Broker
    CONTEXT_PATH  = "/apiv1/properties/"
    attr_reader :AdminSecurity, :version, :name, :runMode, :shortDesc, :longDesc, 
    :platformName, :FixpackCapability, :platformArchitecture, :platformVersion, :operationMode, :buildLevel, :AdminAgentPID, :queueManager 
    
    def initialize(document)
      document.xpath('properties/basicProperties/property').each do |basicProperty|
        
        propertyName = basicProperty.get('name')
        propertyValue = basicProperty.get('value')
        
        instance_variable_set("@#{propertyName}", propertyValue)
      end

      document.xpath('properties/advancedProperties/property').each do |advancedProperty|
        
        propertyName = advancedProperty.get('name')
        propertyValue = advancedProperty.get('value')
        
        instance_variable_set("@#{propertyName}", propertyValue)
      end
      
    end
    
    def self.find_by(options: {})
      url = "#{options[:scheme]}://#{options[:host]}:#{options[:port]}".chomp(":")
      response = Faraday.get("#{url}#{CONTEXT_PATH}")
      document = Oga.parse_xml(response.body)
      new(document)
    end 
  end
end
