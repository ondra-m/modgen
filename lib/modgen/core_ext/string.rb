class String
  
  if !method_defined? :to_param
    def to_param
      to_s
    end
  end

end