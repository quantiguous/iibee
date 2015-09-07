require 'faraday'
require 'oga'

module Iibee
  class ExecutionGroup
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
    
    CONTEXT_PATH = "/apiv1/executiongroups/"
    
    attr_reader :isRunning, :runMode, :isRestricted, :hasChildren, :uri, :propertiesUri, :uuid, :name, :properties
  
    def initialize(document)
      document.xpath('executionGroup/@*').each do |attribute|
        instance_variable_set("@#{attribute.name}", cast_value(attribute.name, attribute.value))
      end
    end
    
    def properties
      response = Faraday.get("#{Iibee.configuration.base_url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::ExecutionGroup::Properties.new(document)
    end
    
    def self.all
      egs = []
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/")
      document = Oga.parse_xml(response.body)
      document.xpath('executionGroups/executionGroup').each do |eg|
          egs << new(document)  
      end
    end
    
    def self.find_by_name(name)
      response = Faraday.get("#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{name}")
      document = Oga.parse_xml(response.body)
      new(document)        
    end
    
    protected
    def cast_value(attrName, attrValue)
      if [:isRunning].include? attrName 
        if attrValue == "true"
          return true
        else 
          return false
        end
      end
      # if [:someInteger].include? attrName
#         return attrValue.to_i
#       end
      return attrValue      
    end
    
  end
end