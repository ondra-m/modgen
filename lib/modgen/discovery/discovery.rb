module Modgen
  module Discovery

    def self.config
      Modgen.config
    end

    # Download all version and return prefferd version.
    # If there is not preffered, return nil
    #
    def self.preffered_version
      versions.body['versions'].each do |version, details|
        if details['preffered']
          return version
        end
      end

      nil
    end

    # All available version on the server
    #
    def self.versions
      Modgen::API::Request.new(config.api.discovery_versions_url).response
    end

    # Details of one specific version
    # If id=nil, client take preffered
    #
    def self.version(id = :auto)
      if id == :auto
        id = preffered_version
      end

      params = {'path' => {'id' => id}}

      response = Modgen::API::Request.new(config.api.discovery_version_url, params).response

      if response.error?
        raise Modgen::APIError, response.error_message
      end

      response
    end

    # Discover selected API
    # If id=nil, client take preffered
    #
    def self.discover(id = :auto)
      
      data = version(id).body

      api = {
        name:        data['name'],
        description: data['description'],
        version:     data['version'],
        created_at:  data['created_at'],
        updated_at:  data['updated_at'],
        base_url:    data['base_url']
      }
      Modgen::API.set_api(api)

      resources = Modgen::API::Resource.new('resources', data['resources'])

      Modgen::API.set_api_methods(resources)

      nil
    end

  end
end
