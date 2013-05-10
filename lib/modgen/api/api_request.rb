module Modgen
  module API
    class ApiRequest < Request
      
      attr_reader :api_method

      def initialize(api_method, data)
        @api_method = api_method

        super(@api_method.url, data, @api_method.http_method.downcase)
      end

      private

        def _response
          response = Modgen::Session.get.execute(self)
          
          Modgen::API::Response.new(response, self)
        end

    end
  end
end
