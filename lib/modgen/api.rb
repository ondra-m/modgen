module Modgen
  module API
    
    autoload :SimpleRequest,  'modgen/api/simple_request'
    autoload :SimpleResponse, 'modgen/api/simple_response'

    autoload :Request,  'modgen/api/request'
    autoload :Response, 'modgen/api/response'

    autoload :Resource, 'modgen/discovery/resource'
    autoload :Method,   'modgen/discovery/method'

    @@api = nil
    @@api_methods = {}

    def self.api
      @@api || raise(Modgen::APIError, "API has not been discovered yet.")
    end

    def self.discovered?
      !@@api.nil?
    end

    def self.methods
      @@api_methods.methods
    end

    def self.method_missing(method, *args, &block)  
      @@api_methods.send(method, *args, &block)
    end

    protected

      def self._api(api)
        @@api = OpenStruct.new(api)
      end

      def self._api_methods(api)
        @@api_methods = api
      end

  end
end
