module Modgen
  module API
    class Method

      attr_reader :name, :path, :url, :http_method, :description, :parameters
      
      def initialize(name, values)
        @name   = name
        @values = values

        @path        = values['path']
        @url         = URI.join(API_BASE_PATH, "#{Modgen::API.api.version}/", @path)
        @http_method = values['http_method']
        @description = values['description']
        @parameters  = values['parameters']
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
            raise Modgen::APIRequestError, "Parameter #{param} is required."
          end

          return 'next'
        end

        case spec['type']
          when 'integer'; check_type(param, value, Integer)
          when 'float';   check_type(param, value, Integer, Float)
          when 'string';  check_type(param, value, String)
          when 'hash'
            check_type(param, value, Hash)
            validate_parameters(spec['attributes'], value)
          when 'file'
            if !File.file?(value)
              raise Modgen::APIRequestError, "File #{value} doesn't exists."
            end
        end

        if spec['format']
          unless value =~ /#{spec['format']}/
            raise Modgen::APIRequestError, "Parameter #{param} hasn't required format (#{spec['format']})."
          end
        end
      end

      def validate_parameters(attributes, params = {})
        params.stringify_keys!

        parameters_left = params.keys - attributes.keys
        if !parameters_left.empty?
          raise Modgen::APIRequestError, "Parameters: #{parameters_left} are unknow."
        end

        attributes.each do |param, spec|
          value = params[param]

          if validate_parameter(param, spec, value) == 'next'
            next
          end
        end
      end

      def build_parameters(params = {})
        result = {
          'path'  => {},
          'query' => {},
          'body'  => {},
          'files' => {}
        }

        params.each do |key, value|
          if @parameters[key]['type'] == 'file'
            result['files'][key] = value
          else
            type = @parameters[key]['location']
            result[type][key] = value
          end
        end

        result
      end

      def query(params)
        if !params.is_a?(Hash)
          raise Modgen::TypeError, "Parameters must be Hash. #{params.class.name} inserted."
        end

        validate_parameters(@parameters, params)

        params = build_parameters(params)
        Modgen::API::ApiRequest.new(self, params).response
      end

    end
  end
end
