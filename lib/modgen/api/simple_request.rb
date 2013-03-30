module Modgen
  module API
    class SimpleRequest

      attr_reader :url, :http_method

      def initialize(url, http_method = :get)
        @url         = url
        @http_method = http_method.to_sym
      end

      def response
        data = Faraday.send @http_method, @url
        Modgen::API::SimpleResponse.new(data, self)
      end
      
    end
  end
end