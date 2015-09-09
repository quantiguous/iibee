require 'faraday'
require 'oga'

module Iibee
  class Service
    class Properties
      attr_reader :label, :runMode, :uuid, :isRunning, :shortDesc, :longDesc, :processId, :traceLevel, :soapNodesUseEmbeddedListener, 
                  :compiledXPathCacheSizeEntries, :consoleMode, :httpNodesUseEmbeddedListener, :inactiveUserExitList, :activeUserExitList, 
                  :traceNodeLevel, :userTraceLevel, :modifyTime, :deployTime, :barFileName
      def initialize(document)        
        document.xpath('properties/*/property').each do |property|
          
          propertyName = property.get('name')
          propertyValue = property.get('value')
          instance_variable_set("@#{propertyName}", propertyValue)
        end 
      end
    end
    CONTEXT_PATH = "apiv1/executiongroups"
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name, :propertiesUri, :executionGroupName
    attr_accessor :uuid, :name
    
    def initialize(document, executionGroupName)
      document.xpath('@*').each do |attribute|        
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
      @executionGroupName = executionGroupName
    end
    
    def executionGroup
      Iibee::ExecutionGroup.find_by(name: executionGroupName)
    end
    
    def properties
      response = Faraday.get("#{Iibee.configuration.base_url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::Service::Properties.new(document)
    end
    
    def self.find_by(executionGroupName: nil, name: nil)
      where(executionGroupName: executionGroupName, name: name).first
    end
    
    def self.where(executionGroupName: nil, name: nil) 
      services = []
      
      unless executionGroupName.nil?
        service_url = "#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/#{executionGroupName}/?depth=2"
      else
        service_url = "#{Iibee.configuration.base_url}/#{CONTEXT_PATH}/?depth=3"
      end
      
      response = Faraday.get(service_url)
      document = Oga.parse_xml(response.body)

      document.xpath("//service[@name='#{name}']").each do |service|
        services << new(service, document.at_xpath("//executionGroup[services/service/@uuid = '#{service.get('uuid')}']").get('name'))
      end
      
      return services
    end
  end
end