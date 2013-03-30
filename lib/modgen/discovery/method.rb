module Modgen
  module API
    class Method

      attr_reader :name, :path, :full_path, :http_method, :description, :parameters
      
      def initialize(name, values)
        @name   = name
        @values = values

        @path        = values['path']
        @full_path   = URI.join(API_BASE_PATH, "#{Modgen::API.api.version}/", @path)
        @http_method = values['http_method']
        @description = values['description']
        @parameters  = values['parameters']

        build_method
      end

      def call(params)
        if params == nil
          return self
        end

        query(params)
      end

      def check_type(param, value, *types)
        types.each do |type|
          return(true) if value.is_a?(type)
        end

        raise Modgen::APIRequestError, "Parameter #{param} has invalid type. Must be #{types.join(' or ')}."
      end

      def validate_parameter(param, spec, value)
        if value.nil?
          if spec['required']
            raise Modgen::APIRequestError, "Parameter: #{param} is required."
          end

          return 'next'
        end

        case spec['type']
          when 'integer'; check_type(param, value, Integer)
          when 'float';   check_type(param, value, Integer, Float)
          when 'string';  check_type(param, value, String)
          when 'hash'
            check_type(param, value, Hash)

            value.stringify_keys!

            spec['attributes'].each do |k, v|
              param_value = value[k]

              if validate_parameter(k, v, param_value) == 'next'
                next
              end
            end
          when 'file'
        end

        if spec['format']
          unless value =~ /#{spec['format']}/
            raise Modgen::APIRequestError, "Parameter #{param} hasn't required format (#{spec['format']})."
          end
        end
      end

      def validate_parameters(params = {})
        params.stringify_keys!

        validated_parameters = {
          'path'  => {},
          'query' => {},
          'body'  => {}
        }

        @parameters.each do |param, spec|
          value = params[param]

          if validate_parameter(param, spec, value) == 'next'
            next
          end

          validated_parameters[spec['location']][param] = params.delete(param)
        end

        # Unknow parameters
        # --------------------------------------------------------------
        if !params.empty?
          raise Modgen::APIRequestError, "Parameters: #{params.to_s} are unknow"
        end

        validated_parameters
      end

      def query(params)
        if !params.is_a?(Hash)
          raise Modgen::TypeError, "Hash is required (#{params.class.name} inserted)"
        end

        params = validate_parameters(params)
        Modgen::API::Request.new(self, params).response
      end

      private

        def build_method
          
        end

    end
  end
end
