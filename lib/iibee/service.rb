require 'faraday'
require 'oga'

module Iibee
  class Service
    class Properties
      attr_reader :processId, :traceLevel, :soapNodesUseEmbeddedListener, :compiledXPathCacheSizeEntries, :consoleMode, :httpNodesUseEmbeddedListener, :inactiveUserExitList, :activeUserExitList, :traceNodeLevel, :userTraceLevel
      def initialize(document)
        document.xpath('properties/advancedProperties/property').each do |advancedProperty|
          
          propertyName = advancedProperty.get('name')
          propertyValue = advancedProperty.get('value')
          instance_variable_set("@#{propertyName}", propertyValue)
        end
      end
    end
    CONTEXT_PATH = "/apiv1/executionGroups/"
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name
    
    def initialize(document)
      document.xpath('service/@*').each do |attribute|        
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
    end
    
    def properties
      response = Faraday.get("#{Iibee.configuration.base_url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::ExecutionGroup::Properties.new(document)
    end
    
    def self.all
      services = []
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/")
      document = Oga.parse_xml(response.body)
      document.xpath('services/service').each do |service|
          services << new(document)  
      end
    end
    
    def self.find_by_name(egName, name)
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{egName}/services/#{name}")
      document = Oga.parse_xml(response.body)
      new(document)        
    end
  end
end