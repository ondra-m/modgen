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

      def validate_require(key, value, required)
        if value.nil? && required
          raise Modgen::APIRequestError, "Parameter: #{key} is required"
        end
      end

      def validate_type(value, type)
        case type
          when 'integer'
            if !value.is_a?(Integer)
              raise Modgen::APIRequestError, "Parameter: #{key} must be Integer"
            end
          when 'float'
            if !value.is_a?(Integer) && !value.is_a?(Float)
              raise Modgen::APIRequestError, "Parameter: #{key} must be Float"
            end
          when 'string'
            if !value.is_a?(String)
              raise Modgen::APIRequestError, "Parameter: #{key} must be String"
            end
          when 'hash'
            if !value.is_a?(Hash)
              raise Modgen::APIRequestError, "Parameter: #{key} must be Hash"
            end
          when 'file'
        end
      end

      def validate_format(key, value, format)
        if format
          unless value =~ /#{format}/
            raise Modgen::APIRequestError, "Parameter: #{key} doesnt have required format (#{format})"
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

        @parameters.each do |key, value|
          param = params[key]

          validate_require(key, param, value['required'])

          if param.nil?
            next
          end

          validate_type(param, value['type'])
          validate_format(key, param, value['format'])

          validated_parameters[value['location']][key] = params.delete(key)
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
