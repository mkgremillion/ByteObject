##
# The ByteObject module adds several attribute methods to any class that includes it, to aid in writing programs that
# require manipulating bytes of specific size. It also has helper methods to make working with binary files easier.
module ByteObject

  # @!visibility private
  def self.included(base)
    base.extend ByteAttributes
  end

  ##
  # Whenever ByteObject is included into a class, it also extends that class with the ByteAttributes module. This is
  # the module that bestows the byte-specific attribute methods.
  module ByteAttributes

    ##
    # @!method attr_u8bit(*keys)
    # Creates an 8-bit unsigned attribute reader and writer.

    # @!method attr_s8bit(*keys)
    # Creates an 8-bit signed attribute reader and writer.

    # @!method attr_u16bit(*keys)
    # Creates a 16-bit unsigned attribute reader and writer.

    # @!method attr_s16bit(*keys)
    # Creates an 16-bit signed attribute reader and writer.

    # @!method attr_u32bit(*keys)
    # Creates an 32-bit unsigned attribute reader and writer.

    # @!method attr_s32bit(*keys)
    # Creates an 32-bit signed attribute reader and writer.

    # @!method attr_u64bit(*keys)
    # Creates an 64-bit unsigned attribute reader and writer.
    
    # @!method attr_s64bit(*keys)
    # Creates an 64-bit signed attribute reader and writer.

    ##
    # This method creates an ordinary attribute reader and a specialized attribute writer for the given key. The writer
    # will clamp any values passed to the new attribute based on its size and whether or not it is signed.
    # Under normal circumstances, you will not need to call this method yourself. It is used by this module to generate
    # the attribute methods given to any extended classes.
    # @param key [Symbol] The name of the attribute.
    # @param size [Integer] The size, in *bits*, of the attribute.
    # @param signed [Boolean] Whether or not the attribute can be negative.
    # @return [void]
    def attr_byte(key, size, signed)
      attr_reader(key)

      bytesize = (2**size)
      min = signed ? -bytesize/2 : 0
      max = signed ? (bytesize/2) - 1 : bytesize - 1

      define_method("#{key}=") do |val|
        instance_variable_set("@#{key}", val.clamp(min, max))
      end
    end

    # @!visibility private
    [8, 16, 32, 64].each do |size|
      define_method("attr_u#{size}bit") do |*keys|
        keys.each{|key| attr_byte(key, size, false)}
      end

      define_method("attr_s#{size}bit") do |*keys|
        keys.each{|key| attr_byte(key, size, true)}
      end
    end

  end

  ##
  # Takes a hash (or hash-like object whose #each method yields a key-value pair) and assigns the values of its keys to
  # instance variables with the same names. If there is an attribute writer method, it will attempt to use that;
  # otherwise it will set the instance variable directly (much to the chagrin of whoever wrote the official Ruby
  # documentation).
  #
  # As the bang might suggest, this method is dangerous and modifies the calling object.
  # @param hash
  def from_hash!(hash)
    hash.each do |key, value|
      if methods.include?("#{key}=".to_sym)
        send("#{key}=", value)
      else
        instance_variable_set("@#{key}", value)
      end
    end
  end


end
