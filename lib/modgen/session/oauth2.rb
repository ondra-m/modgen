require 'oauth2'

module Modgen
  module Session
    class Oauth2
      
      # Start session
      #
      #
      def self.start
        config = Modgen.config

        client = Modgen::Session::Oauth2.new

        Modgen::Session.store(client)

        if config.oauth2.redirect_uri == nil
          get_authorize_code
        else
          client.authorize_url
        end
      end

      def self.authorize(auth_code)
        Modgen::Session.get.authorize(auth_code)
      end

      # Automaticaly open autorization url a waiting for callback.
      # Launchy gem is required
      #
      # Steps:
      # 1) create server
      # 2) launch browser and redirect to google api
      # 3) confirm and modgen redirect to localhost
      # 4) server get code and start session
      # 5) close server - you are login
      def self.get_authorize_code
        require "socket"  # tcp server

        uri = URI(Modgen::OAUTH2_REDIRECT_URI)
        
        webserver = TCPServer.new(uri.host, 0) # start webserver
                                               # port=0 - automatically choose free port

        uri.port = webserver.addr[1] # get choosen port

        Launchy.open(Modgen::Session.get.authorize_url)

        session = webserver.accept

        # parse header for query.
        request = session.gets.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
        request = Hash[URI.decode_www_form(URI(request).query)]

        # failure login
        to_return = false
        message   = "You have not been logged. Please try again."

        if Modgen::Session.get.authorize(request['code'])
          message   = "You have been successfully logged. Now you can close the browser."
          to_return = true
        end

        session.write(message)
        session.close

        return to_return
      end



      attr_reader :authorize_url

      def initialize
        @client = OAuth2::Client.new(client_id, client_secret, site: Modgen::SITE_URL)

        @authorize_url = client.auth_code.authorize_url(redirect_uri: redirect_uri)
      end

      def authorize(auth_code)
        @auth_code = auth_code

        @token = @client.auth_code.get_token(auth_code)
      end

      def execute(request)
        
      end

    end
  end
end
