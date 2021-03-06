require "uri"

module Modgen
  SITE_URL = 'http://modgen.net'

  OAUTH2_REDIRECT_URI = 'http://localhost/oauth2callback'

  API_CONFIGURATION = {
    base_url: 'http://modgen.net/api/',
    discovery_versions_url: -> { URI.join(Modgen.config.api.base_url, 'discovery/versions') },
    discovery_version_url:  -> { URI.join(Modgen.config.api.base_url, 'discovery/version/:id') },
  }

  APIKEY_CONFIGURATION = {
    key: nil
  }

  OAUTH2_CONFIGURATION = {
    client_id: nil,
    client_secret: nil,
    redirect_uri: nil
  }
  
  DEFAULT_CONFIGURATION = {
    api:     Modgen::Configuration.new(API_CONFIGURATION),
    api_key: Modgen::Configuration.new(APIKEY_CONFIGURATION),
    oauth2:  Modgen::Configuration.new(OAUTH2_CONFIGURATION)
  }
end
