module Modgen
  module API
    class Request

      attr_reader :api_method, :http_method, :path, :query, :body, :files, :uri

      def initialize(api_method, params)
        @api_method = api_method
        
        @http_method = @api_method.http_method.downcase.to_sym

        @path  = params['path']
        @query = params['query']
        @body  = params['body']
        @files = params['files']

        @uri  = @api_method.full_path.to_s.gsub(/:([a-z][a-z0-9_]*)/) { @path[$1] }
        @uri += "?" + @query.to_param
      end

      def response
        @response ||= _response
      end

      private

        def _response
          response = Faraday.send(@http_method, @uri)

          Modgen::API::Response.new(response, self)
        end
      
    end
  end
end
