module Helium
  module Struct
    class Attribute
      def initialize(default:, **opts)
        @value = @default = default
        @opts = opts
      end

      attr_accessor :value
    end
  end
end
