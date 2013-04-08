require "uri"

module Modgen
  SITE_URL = 'http://modgen.net'

  API_BASE_PATH = URI('http://localhost:9292/api/')

  API_DISCOVERY_VERSIONS = URI.join(API_BASE_PATH, 'discovery/versions')
  API_DISCOVERY_VERSION  = URI.join(API_BASE_PATH, 'discovery/version/:id')

  OAUTH2_REDIRECT_URI = 'http://localhost/oauth2callback'

  OAUTH2_CONFIGURATION = {
    client_id: nil,
    client_secret: nil,
    redirect_uri: nil
  }
  
  DEFAULT_CONFIGURATION = {
    oauth2: Modgen::Configuration.new(OAUTH2_CONFIGURATION)
  }
end
