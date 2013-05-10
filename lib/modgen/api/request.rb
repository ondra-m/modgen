module Modgen
  module API
    class Request

      attr_reader :origin_url, :url, :http_method, :data

      def initialize(url, data = {}, http_method = :get)

        @origin_url = url
        @url = url
        
        if data['path']
          @url = url.to_s.gsub(/:([a-z][a-z0-9_]*)/) { data['path'][$1] }
        end

        @data        = data
        @http_method = http_method.to_sym
      end
      
      def response
        @response ||= _response
      end

      private

        def _response
          conn = Faraday.new(url: @url)

          if @data['body'] && @data['body'].empty?
            response = conn.send(@http_method, "", @data['params'])
          else
            response = conn.send(@http_method, "") { |req| req.body = @data['body'] }
          end

          Modgen::API::Response.new(response, self)
        end

    end
  end
end
