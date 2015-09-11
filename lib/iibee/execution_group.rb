require 'oga'

module Iibee
  class ExecutionGroup
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
    
    CONTEXT_PATH = "/apiv1/executiongroups/"
    
    attr_reader :isRunning, :runMode, :isRestricted, :hasChildren, :uri, :propertiesUri, :uuid, :name, :options
  
    def initialize(document, options)
      document.xpath('@*').each do |attribute|
        instance_variable_set("@#{attribute.name}", cast_value(attribute.name, attribute.value))
      end
      @options = options
    end
    
    def properties
      response = Iibee::Connection.new(options: options).get("#{self.propertiesUri}")
      document = Oga.parse_xml(response.body)
      @properties = Iibee::ExecutionGroup::Properties.new(document)
    end
    
    def self.all(options: {})      
      egs = []
      response = Iibee::Connection.new(options: options).get(CONTEXT_PATH)
      document = Oga.parse_xml(response.body)
      document.xpath('executionGroups/executionGroup').each do |eg|
        egs << new(eg, options)  
      end
      return egs
    end
    
    def self.find_by(name: nil, options: {})
      where(name: name, options: options).first
    end
    
    def self.where(name: nil, options: {})
      egs = []
      unless name.nil?
        response = Iibee::Connection.new(options: options).get("#{CONTEXT_PATH}/#{name}")
        document = Oga.parse_xml(response.body)
        document.xpath("//executionGroup[@name='#{name}']").each do |eg|
          egs << new(eg, options)  
        end
      end
      return egs
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