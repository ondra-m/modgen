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

      def validate_parameters(params = {})
        params.stringify_keys!

        validated_parameters = {
          'path'  => {},
          'query' => {},
          'body'  => {}
        }

        @parameters.each do |key, value|
          param = params[key]

          # Required
          # --------------------------------------------------------------
          if param.nil? && value['required']
            raise Modgen::APIRequestError, "Parameter: #{key} is required"
          end
          if param.nil?
            next
          end



          # Type
          # --------------------------------------------------------------
          case value['type']
            when 'integer'
              if !param.is_a?(Integer)
                raise Modgen::APIRequestError, "Parameter: #{key} must be Integer"
              end
            when 'float'
              if !param.is_a?(Integer) && !param.is_a?(Float)
                raise Modgen::APIRequestError, "Parameter: #{key} must be Float"
              end
            when 'string'
              if !param.is_a?(String)
                raise Modgen::APIRequestError, "Parameter: #{key} must be String"
              end
            when 'hash'
              if !param.is_a?(Hash)
                raise Modgen::APIRequestError, "Parameter: #{key} must be Hash"
              end
            when 'file'
          end



          # Format
          # --------------------------------------------------------------
          if value['format']
            unless param =~ /#{value['format']}/
              raise Modgen::APIRequestError, "Parameter: #{key} doesnt have required format (#{value['format']})"
            end
          end



          # Location
          # --------------------------------------------------------------
          validated_parameters[value['location']][key] = params.delete(key)



          # Unknow parameters
          # --------------------------------------------------------------
          if !params.empty?
            raise Modgen::APIRequestError, "Parameters: #{params.to_s} are unknow"
          end
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
