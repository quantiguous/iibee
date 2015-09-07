module Iibee
  class Configuration
    attr_reader :base_url
    
    def base_url=(base_url)
      @base_url = base_url.chomp("/")
    end
  end
end