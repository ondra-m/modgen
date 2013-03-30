module Modgen
  module API
    class Request

      def initialize(method, params)
        @method = method
        
        @path  = params['path']
        @query = params['query']
        @body  = params['body']

        @uri  = @method.full_path.to_s.gsub(/:([a-z][a-z0-9_]*)/) { @path[$1] }
        @uri += "?" + @query.to_param
      end

      def response
        Faraday.send @method.http_method.downcase.to_sym, @uri
      end
      
    end
  end
end
