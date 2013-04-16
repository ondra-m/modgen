module Modgen
  module API
    class Request

      attr_reader :origin_url, :url, :http_method, :data

      def initialize(url, data = {}, http_method = :get)

        @origin_url = url
        @url = url.to_s.gsub(/:([a-z][a-z0-9_]*)/) { data['path'][$1] }

        @data        = data
        @http_method = http_method.to_sym
      end
      
      def response
        @response ||= _response
      end

      private

        def _response
          conn = Faraday.new(url: @url)

          response = conn.send(@http_method, @data['params']) { |req|
            req.body = @data['body']
          }

          Modgen::API::Response.new(response, self)
        end

    end
  end
end
