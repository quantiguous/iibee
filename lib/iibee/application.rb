require 'faraday'
require 'oga'

module Iibee
  class Application
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
      url = "#{options[:scheme]}://#{options[:host]}:#{options[:port]}".chomp(":")
      response = Faraday.get("#{url}/#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::Application::Properties.new(document)
    end
    
    def self.find_by(executionGroupName: nil, name: nil, options: {})
      where(executionGroupName: executionGroupName, name: name, options: options).first
    end
    
    def self.where(executionGroupName: nil, name: nil, options: {}) 
      applications = []

      url = "#{options[:scheme]}://#{options[:host]}:#{options[:port]}".chomp(":")
      
      unless executionGroupName.nil?
        application_url = "/#{CONTEXT_PATH}/#{executionGroupName}/?depth=2"
      else
        application_url = "/#{CONTEXT_PATH}/?depth=3"
      end
      
      response = Faraday.get(url+application_url)
      document = Oga.parse_xml(response.body)
      
      document.xpath("//application[@name='#{name}']").each do |application|
        applications << new(application, application.parent.parent.get('name'), options)
      end
      
      return applications
    end
    
  end
end