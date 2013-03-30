class Hash

  if !method_defined? :stringify_keys
    def stringify_keys
      dup.stringify_keys!
    end
  end

  if !method_defined? :stringify_keys!
    def stringify_keys!
      keys.each do |key|
        self[key.to_s] = delete(key)
      end
      self
    end
  end

  if !method_defined? :symbolize_keys
    def symbolize_keys
      dup.symbolize_keys!
    end
  end

  if !method_defined? :symbolize_keys!
    def symbolize_keys!
      keys.each do |key|
        self[(key.to_sym rescue key) || key] = delete(key)
      end
      self
    end
  end

  if !method_defined? :to_param
    def to_param(namespace = nil)
      collect do |key, value|
        value.to_query(namespace ? "#{namespace}[#{key}]" : key)
      end.sort * '&'
    end
  end

end
