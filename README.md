A Ruby Module that adds attribute methods and other useful methods to make
working with exact byte-lengths easier and quicker.

## Installation
```
gem install byteobject
```

## Usage
```ruby
class MyClass
  #This gives you all of the attribute methods and other features.
  include ByteObject

  #They work like normal attr_ methods, taking single symbols...
  attr_u8bit :id

  #... or multiple.
  attr_s16bit :hp, :mp, :strength

end
```
There are 8 total attribute methods, two each for 8-, 16-, 32-, and 64-bit values.
One method makes attributes for unsigned values, and the other for signed values.

The writer method created by these will automatically clamp any value outside of the
byte's range. So if you try to write `1000` to an `attr_s8bit`-generated attribute,
it'll write `127` instead.
