require "uri"

module Modgen
  API_BASE_PATH = URI('http://localhost:9292/api/')

  API_DISCOVERY_VERSIONS = URI.join(API_BASE_PATH, 'discovery/versions')
  API_DISCOVERY_VERSION  = URI.join(API_BASE_PATH, 'discovery/version/:id')

  # Global configuration
  DEFAULT_CONFIGURATION = {
    client_id: nil,
    client_secret: nil
  }
end
