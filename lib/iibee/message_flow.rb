require 'oga'

module Iibee
  class MessageFlow
    class Properties
      attr_reader :version, :label, :runMode, :uuid, :isRunning, :commitCount, :traceLevel, :additionalInstances, :startMode,
                  :coordinatedTransaction, :commitInterval, :userTraceLevel, :modifyTime, :deployTime, :barFileName
      def initialize(document)        
        document.xpath('properties/*/property').each do |property|
          
          propertyName = property.get('name')
          propertyValue = property.get('value')
          instance_variable_set("@#{propertyName}", propertyValue)
        end 
      end
    end
    CONTEXT_PATH = "apiv1/executiongroups"
    
    attr_reader :type, :isRunning, :runMode, :startMode, :hasChildren, :uuid, :name, :propertiesUri, :executionGroupName, :options, :parentType, :parentName
    
    def initialize(document, parentType, parentName, executionGroupName, options)
      document.xpath('@*').each do |attribute|        
        instance_variable_set("@#{attribute.name}", attribute.value)
      end
      @executionGroupName = executionGroupName
      @parentType = parentType
      @parentName = parentName
      @options = options
    end
    
    def executionGroup
      Iibee::ExecutionGroup.find_by(name: executionGroupName, options: @options)
    end
    
    def properties
      response = Iibee::Connection.new(options: options).get("#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::MessageFlow::Properties.new(document)
    end
    
    def self.find_by(executionGroupName: nil, name: nil, options: {})
      where(executionGroupName: executionGroupName, name: name, options: options).first
    end
    
    def self.where(executionGroupName: nil, name: nil, options: {}) 
      msg_flows = []
      
      unless executionGroupName.nil?
        msg_flow_url = "/#{CONTEXT_PATH}/#{executionGroupName}/?depth=4"
      else
        msg_flow_url = "/#{CONTEXT_PATH}/?depth=5"
      end
      
      response = Iibee::Connection.new(options: options).get(msg_flow_url)
      document = Oga.parse_xml(response.body)
      
      document.xpath("//messageflow[@name='#{name}']").each do |msg_flow|
        msg_flows << new(msg_flow, msg_flow.parent.parent.parent.get('type'), msg_flow.parent.parent.get('name'), msg_flow.parent.parent.parent.parent.get('name'), options)
      end
      
      return msg_flows
    end
    
    def perform(action)
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/#{parentType}/#{parentName}/messageflows/#{name}?action=#{action}")
    end
    
    def start
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/#{parentType}/#{parentName}/messageflows/#{name}?action=start")
    end
    
    def stop
      response = Iibee::Connection.new(options: options).put("#{CONTEXT_PATH}/#{executionGroupName}/#{parentType}/#{parentName}/messageflows/#{name}?action=stop")
    end
  end
end