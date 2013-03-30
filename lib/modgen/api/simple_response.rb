module Modgen
  module API
    class SimpleResponse

      attr_reader :full_response, :request, :body, :status

      def initialize(full_response, request)
        @full_response = full_response
        @request       = request

        @status       = full_response.status
        @content_type = full_response.headers['content-type']
        @body         = _parse_body
      end

      def error?
        @status != 200 && @status != 201
      end

      def error_message
        if error?
          @body['error']
        else
          nil
        end
      end

      def inspect
        %{#<Modgen::API::SimpleResponse::0x#{object_id} URL:"#{@request.url}" STATUS_CODE:"#{@status}" BODY:"#{@body}">}
      end

      private

        def _parse_body
          case @content_type
            when 'application/json'
              return MultiJson.load(@full_response.body)
          end
        end
      
    end
  end
end