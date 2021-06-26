module Helium
  module Struct
    class Attribute
      def initialize(**opts)
        @opts = opts
      end

      def default
        @opts[:default] || Undefined.instance
      end

      def initial_value
        @opts[:initial] || default
      end

      def self.value_class
        return @value_class if defined? @value_class

        base = superclass.respond_to?(:value_class) ? superclass.value_class : Attribute::Value
        @value_class ||= Class.new(base)
      end

      def process_value(value:, form:)
        value
      end
    end
  end
end
