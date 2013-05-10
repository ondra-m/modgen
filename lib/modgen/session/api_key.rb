module Modgen
  module Session
    class APIKey

      def self.config
        Modgen.config
      end
      
      def self.start
        if config.api_key.key == nil
          raise Modgen::ConfigurationError, "Api key cannot be nil."
        end

        client = Modgen::Session::APIKey.new

        Modgen::Session.store(client)
      end

      def initialize
        @key = Modgen.config.api_key.key
      end

      def execute(request)
        conn = Faraday.new(url: request.url)

        if request.data['body'] && request.data['body'].empty?
          response = conn.send(request.http_method, "", request.data['params']) { |req|
            req.headers['Api-Key'] = @key
          }
        else
          response = conn.send(@http_method, "") { |req|
            req.headers['Api-Key'] = @key
            req.body = request.data['body']
          }
        end

        response
      end

    end
  end
end
