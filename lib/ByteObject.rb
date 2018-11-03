module ByteObject

  def self.included(base)
    base.extend ByteAttributes
  end

  module ByteAttributes
    def attr_byte(key, size, signed)
      attr_reader(key)
      
      bytesize = (2**size)
      min = signed ? -bytesize/2 : 0
      max = signed ? (bytesize/2) - 1 : bytesize - 1
    
      define_method("#{key}=") do |val|
        instance_variable_set("@#{key}", val.clamp(min, max))
      end
    end
  
    [8, 16, 32, 64].each do |size|
      define_method("attr_ubyte#{size}") do |*keys|
        keys.each{|key| attr_byte(key, size, false)}
      end
    
      define_method("attr_sbyte#{size}") do |*keys|
        keys.each{|key| attr_byte(key, size, true)}
      end
    end
  end


  def load_from_hash(hash)
    hash.each do |key, value|
      if methods.include?("#{key}=".to_sym)
        send("#{key}=", value)
      else
        instance_variable_set("@#{key}", value)
      end
    end
  end
  
  
end