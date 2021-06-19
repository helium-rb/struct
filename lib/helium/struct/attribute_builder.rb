module Helium
  module Struct
    class AttributeBuilder
      def initialize(attribute)
        @attribute = attribute
      end

      def change(&block)
        @attribute.register_hook(:change, &block)
      end
    end
  end
end
