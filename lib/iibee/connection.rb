require 'faraday'

module Iibee
  class Connection
    def initialize(options: {})
      url = "#{options[:scheme]}://#{options[:host]}:#{options[:port]}".chomp(":")
      @conn = Faraday.new(url) do |f|
        f.response :logger
        f.adapter :net_http_persistent
      end
      @conn.basic_auth(options[:user], options[:password]) unless options[:user].nil? or options[:password].nil?
    end
    
    def get(url)
      @conn.get(url)
    end
    
    def put(url)
      @conn.put(url)
    end
  end
end