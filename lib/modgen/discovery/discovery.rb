module Modgen
  module Discovery

    autoload :Build, 'modgen/discovery/build'

    def self.versions
      Modgen::API::Request.new(Modgen::API_DISCOVERY_VERSIONS).response
    end

    def self.version(id = :auto)
      if id == :auto
        versions.body['versions'].each do |version, details|
          if details['preffered']
            id = version
            break
          end
        end
      end

      params = {'path' => {'id' => id}}

      response = Modgen::API::Request.new(Modgen::API_DISCOVERY_VERSION, params).response

      if response.error?
        raise Modgen::APIError, response.error_message
      end

      response
    end

    def self.discover(id = :auto)
      if Modgen::API.discovered?
        return nil
      end

      data = version(id).body

      api = {
        name:        data['name'],
        description: data['description'],
        version:     data['version'],
        created_at:  data['created_at'],
        updated_at:  data['updated_at'],
        base_url:    data['base_url']
      }
      Modgen::API._api(api)

      resources = Modgen::API::Resource.new('resources', data['resources'])

      Modgen::API._api_methods(resources)
    end

  end
end
