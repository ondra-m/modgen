module Modgen
  module API
    class Response

      attr_reader :data, :request, :content_type, :body, :status

      def initialize(data, request)
        @data    = data
        @request = request

        @status       = data.status
        @content_type = data.headers['content-type']
        @body         = _parse_body
      end

      def error?
        @status != 200 && @status != 201
      end

      def error_message
        if error? && @body
          @body['error']
        end
      end

      def inspect
        %{#<Modgen::API::Response::0x#{object_id} URL:"#{@request.url}" STATUS_CODE:"#{@status}" BODY:"#{@body}">}
      end

      private

        def _parse_body
          case @content_type
            when 'application/json'
              return MultiJson.load(@data.body)
          end
        end
      
    end
  end
end
