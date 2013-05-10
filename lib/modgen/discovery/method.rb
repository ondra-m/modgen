module Modgen
  module API
    class Method

      attr_reader :name, :path, :url, :http_method, :description, :method_parameters
      
      def initialize(name, values)
        @name   = name
        @values = values

        @path               = values['path']
        @url                = URI.join(Modgen.config.api.base_url, "#{Modgen::API.api.version}/", @path)
        @http_method        = values['http_method']
        @description        = values['description']
        @method_parameters  = values['parameters']
      end

      def call(params)
        # if params == nil
        #   return self
        # end

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
        if !attributes
          return nil
        end

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

      def build_file(path)
        mime = MimeMagic.by_path(path)
        Faraday::UploadIO.new(path, mime)
      end

      def build_request_data(params = {})
        result = {
          'path'   => {},
          'params' => {},
          'body'   => {}
        }

        params.each do |key, value|
          case @method_parameters[key]['location']
            when 'path'; result['path'][key] = value
            when 'body'; result['body'][key] = value
            else
              if @method_parameters[key]['type'] == 'file'
                result['params'][key] = build_file(value)
              else
                result['params'][key] = value
              end
          end
        end

        result
      end

      def query(params)
        request_data = {}

        if !params.is_a?(Hash)
          raise Modgen::TypeError, "Parameters must be Hash. #{params.class.name} inserted."
        end

        validate_parameters(@method_parameters, params)
        request_data = build_request_data(params)

        Modgen::API::ApiRequest.new(self, request_data).response
      end

    end
  end
end
