module Helium
  module Struct
    class Undefined
      class << self
        def instance
          @instance ||= new
        end

        private :new
      end

      def to_s
        "`undefined`"
      end

      def inspect
        to_s
      end

      if defined? Helium::Console
        Helium::Console.define_formatter_for self do
          def call
            light_black("undefined")
          end
        end
      end
    end
  end
end
