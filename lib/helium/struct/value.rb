require 'helium/struct/undefined'

module Helium
  module Struct
    class Value
      def initialize
        clear!
      end

      def value
        @value
      end

      def clear!
        self.value = nil
      end

      def value=(new_value)
        @value = new_value
      end

      def inspect
        value.inspect
      end

      def to_format
        value
      end

      if defined? Helium::Console
        Helium::Console.define_formatter_for self do
          def call
            format(object.to_format)
          end
        end
      end
    end
  end
end
