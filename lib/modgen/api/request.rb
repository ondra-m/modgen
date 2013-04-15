module Modgen
  module API
    class Request

      attr_reader :url, :http_method, :params

      def initialize(url, params = {}, http_method = :get)

        @url  = url.to_s.gsub(/:([a-z][a-z0-9_]*)/) { params['path'][$1] }
        @url += "?" + params['query'].to_param if params['query']

        @params      = params
        @http_method = http_method.to_sym

        @files = _files
      end
      
      def response
        @response ||= _response
      end

      private

        def _files
          files = {}

          @params['files'].each do |name, path|
            mime = MimeMagic.by_path(path)
            files[name] = Faraday::UploadIO.new(path, mime)
          end

          files
        end

        def _response
          response = Faraday.send(@http_method, @url, @files)
          Modgen::API::Response.new(response, self)
        end

    end
  end
end
