require 'faraday'
require 'oga'

module Iibee
  class Application
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
    CONTEXT_PATH = "apiv1/executiongroups"
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name, :propertiesUri
    
    def initialize(document)
      document.xpath('application/@*').each do |attribute|        
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
    end
    
    def properties
      response = Faraday.get("#{Iibee.configuration.base_url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::Application::Properties.new(document)
    end
    
    def self.all(egName)
      applications = []
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{egName}/applications/")
      document = Oga.parse_xml(response.body)
      document.xpath('applications/application').each do |application|
          applications << new(document)  
      end
    end
    
    def self.find_by_name(egName, name)
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{egName}/applications/#{name}")
      document = Oga.parse_xml(response.body)
      new(document)        
    end
  end
end