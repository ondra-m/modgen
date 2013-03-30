class Object

  if !method_defined? :to_query
    def to_query(key)
      require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
      "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
    end
  end

end
