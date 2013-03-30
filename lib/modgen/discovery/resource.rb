module Modgen
  module API
    class Resource
      
      attr_reader :name

      def initialize(name, values)
        @name    = name
        @values  = values
        @methods = []

        build_resources
      end

      def methods
        @methods
      end

      private

        def build_resources
          @values.each do |key, value|
            if key == 'methods'
              build_methods(value)
            else
              build_resource(key, value)
            end
          end
        end

        def build_resource(name, values)
          resource = Modgen::API::Resource.new(name, values)

          @methods << name.to_sym
          
          self.class.send(:define_method, name) { resource }
        end

        def build_methods(value)
          value.each do |key, value|
            method = Modgen::API::Method.new(key, value)

            @methods << key.to_sym

            self.class.send(:define_method, key) { |params=nil| method.send(:call, params) }
          end
        end

    end
  end
end
