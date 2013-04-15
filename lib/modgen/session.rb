module Modgen
  module Session

    autoload :Oauth2, 'modgen/session/oauth2'

    @@session = nil
    
    def self.oauth2
      Modgen::Session::Oauth2
    end

    def store(client)
      @@session = client
    end

    def get
      @@session
    end
    
  end
end
