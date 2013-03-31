module Modgen
  module API
    class Response

      attr_reader :response, :request, :status, :content_type, :body

      def initialize(response, request)
        @response = response
        @request  = request

        @status       = response.status
        @content_type = response.headers['content-type']
        @body         = _parse_body
      end

      def error?
        @response.status != 200 && @response.status != 201
      end

      def error_message
        if error?
          @body['error']
        end
      end

      # def methods
      #   [:request, :response, :status]
      # end

      private

        def _parse_body
          case @content_type
            when 'application/json'
              return MultiJson.load(@response.body)
          end
        end
      
    end
  end
end
