require 'oga'

module Iibee
  class Service
    class Properties
      attr_reader :version, :label, :runMode, :uuid, :isRunning, :shortDesc, :longDesc, :processId, :traceLevel, :soapNodesUseEmbeddedListener, 
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
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name, :propertiesUri, :executionGroupName, :options
    
    def initialize(document, executionGroupName, options)
      document.xpath('@*').each do |attribute|        
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
      @executionGroupName = executionGroupName
      @options = options
    end
    
    def executionGroup
      Iibee::ExecutionGroup.find_by(name: executionGroupName, options: @options)
    end
    
    def properties
      response = Iibee::Connection.new(options: options).get("#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::Service::Properties.new(document)
    end
    
    def self.find_by(executionGroupName: nil, name: nil, options: {})
      where(executionGroupName: executionGroupName, name: name, options: options).first
    end
    
    def self.where(executionGroupName: nil, name: nil, options: {}) 
      services = []
      
      unless executionGroupName.nil?
        service_url = "/#{CONTEXT_PATH}/#{executionGroupName}/?depth=2"
      else
        service_url = "/#{CONTEXT_PATH}/?depth=3"
      end
      
      response = Iibee::Connection.new(options: options).get(service_url)
      document = Oga.parse_xml(response.body)
      
      document.xpath("//service[@name='#{name}']").each do |service|
        services << new(service, service.parent.parent.get('name'), options)
      end
      
      return services
    end
    
    def perform(action)
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/services/#{name}?action=#{action}")
    end
    
    def start
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/services/#{name}?action=start")
    end
    
    def stop
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/services/#{name}?action=stop")
    end
  end
end