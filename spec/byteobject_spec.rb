require_relative "../lib/byte_object.rb"

describe ByteObject do
  let(:test_class) do
    Class.new do
      include ByteObject
    end
  end

  context "when ByteObject is included, it" do
    it "extends the internal ByteAttributes module", :fundamentals do
      expect(test_class.singleton_class.included_modules).to include(ByteObject::ByteAttributes)
    end

    ByteObject::BIT_LENGTHS.each do |size|
      it "creates an attribute method for unsigned #{size}-bit values", :attr do
        expect(test_class).to respond_to("attr_u#{size}bit")
      end

      it "creates an attribute method for signed #{size}-bit values", :attr do
        expect(test_class).to respond_to("attr_s#{size}bit")
      end

      it "creates an attribute method for #{size}-bit bitsets", :attr do
        expect(test_class).to respond_to("attr_#{size}bitset")
      end
    end

    it "creates an attribute method for strings", :attr do
      expect(test_class).to respond_to("attr_string")
    end

  end

  ByteObject::BIT_LENGTHS.each do |size|
    context "when #{size}-bit byte attributes are defined, ", :attr_creation do
      ["u","s"].each do |signed|
        context "when the attribute is #{signed == 'u' ? 'unsigned' : 'signed'}, it" do
          let(:test_object) do
            test_object = test_class.new
            test_object.class.send("attr_#{signed}#{size}bit", :test_value)
            test_object.class.send("attr_#{signed}#{size}bit", :test_value1, :test_value2)
            test_object
          end

          it "creates an attribute reader method for a single argument" do
            expect(test_object).to respond_to(:test_value)
          end

          it "creates an attribute reader method for multiple arguments" do
            expect(test_object).to respond_to(:test_value1, :test_value2)
          end

          it "creates an attribute writer method for a single argument" do
            expect(test_object).to respond_to(:test_value=)
          end

          it "creates an attribute writer method for multiple arguments" do
            expect(test_object).to respond_to(:test_value1=, :test_value2=)
          end
        end # context "when the attribute is"
      end # ["u","s"].each do
    end # context "when #{size}-bit attributes are defined, "

    context "when #{size}-bit bitset attributes are defined, it", :attr_creation do
      let(:test_object) do
        test_object = test_class.new
        test_object.class.send("attr_#{size}bitset", :test_value)
        test_object.class.send("attr_#{size}bitset", :test_value1, :test_value2)
        test_object
      end

      it "creates an attribute reader method for a single argument" do
        expect(test_object).to respond_to(:test_value)
      end

      it "creates an attribute reader method for multiple arguments" do
        expect(test_object).to respond_to(:test_value1, :test_value2)
      end

      it "creates an attribute writer method for a single argument" do
        expect(test_object).to respond_to(:test_value=)
      end

      it "creates an attribute writer method for multiple arguments" do
        expect(test_object).to respond_to(:test_value1=, :test_value2=)
      end
    end # context "when #{size}-bit bitset attributes are defined"
  end # ByteObject::BIT_LENGTHS.each do

end

=begin
attr_u8bit  :u8bit
attr_u16bit :u16bit
attr_u32bit :u32bit
attr_u64bit :u64bit

attr_s8bit  :s8bit
attr_s16bit :s16bit
attr_s32bit :s32bit
attr_s64bit :s64bit

attr_8bitset  :bitset8
attr_16bitset :bitset16
attr_32bitset :bitset32
attr_
=end
