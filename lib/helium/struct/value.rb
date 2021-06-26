require 'helium/struct/undefined'

module Helium
  module Struct
    class Value
      def initialize
        @value = Undefined.instance
      end

      def undefined?
        @value.is_a? Undefined
      end

      def value
        @value
      end

      def clear!
        self.value = Undefined.instance
      end

      def value=(new_value)
        @value = new_value
      end
    end
  end
end
