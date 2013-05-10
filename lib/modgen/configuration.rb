module Modgen
  class Configuration

    DEFAULT = {}

    def initialize(config, use_default = true)

      if use_default
        config = DEFAULT.merge(config)
      end

      config.each do |key, value|
        eval <<-METHOD
          def #{key}(value = nil, &block)
            if block_given?
              @#{key}.instance_eval(&block)
            end

            if value.nil?
              if @#{key}.is_a?(Proc)
                return @#{key}.call
              end
              return @#{key}
            end

            self.#{key} = value
          end

          def #{key}=(value)
            @#{key} = value
          end
        METHOD

        self.send("#{key}=", value)
      end
    end

    def configure(&block)
      if block_given?
        yield self
      end

      self
    end
    
  end
end
