module Modgen
  module Session

    @@session = nil
    
    def self.oatuh2
      Modgen::Session::Oatuh2
    end

    protected

      def store(client)
        @@session = client
      end

      def get
        @@session
      end
    
  end
end
