require 'faraday'
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
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name, :propertiesUri, :executionGroupName
    
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
      url = "#{self.options[:scheme]}://#{self.options[:host]}:#{self.options[:port]}".chomp(":")
      response = Faraday.get("#{url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::Service::Properties.new(document)
    end
    
    def self.find_by(executionGroupName: nil, name: nil, options: {})
      where(executionGroupName: executionGroupName, name: name, options: options).first
    end
    
    def self.where(executionGroupName: nil, name: nil, options: {}) 
      services = []

      url = "#{options[:scheme]}://#{options[:host]}:#{options[:port]}".chomp(":")
      
      unless executionGroupName.nil?
        service_url = "/#{CONTEXT_PATH}/#{executionGroupName}/?depth=2"
      else
        service_url = "/#{CONTEXT_PATH}/?depth=3"
      end
      
      response = Faraday.get(url+service_url)
      document = Oga.parse_xml(response.body)
      
      document.xpath("//service[@name='#{name}']").each do |service|
        services << new(service, document.at_xpath("//executionGroup[services/service/@uuid = '#{service.get('uuid')}']").get('name'), options)
      end
      
      return services
    end
  end
end