module Modgen
  
  # Errors in API
  #
  # e.g. API was not discovered
  class APIError < StandardError
  end

  # Error during request such as missing parameters
  class APIRequestError < StandardError
  end

  # Type error
  class TypeError < StandardError
  end

  # Configuration error
  class ConfigurationError < StandardError
  end

end
