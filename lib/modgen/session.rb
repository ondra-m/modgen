module Modgen
  module Session

    autoload :Oauth2, 'modgen/session/oauth2'
    autoload :APIKey, 'modgen/session/api_key'

    @@session = nil
    
    def self.oauth2
      Modgen::Session::Oauth2
    end

    def self.api_key
      Modgen::Session::APIKey
    end

    def self.store(client)
      @@session = client
    end

    def self.get
      @@session
    end
    
  end
end
