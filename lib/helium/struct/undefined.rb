module Helium
  module Struct
    module Undefined
      def self.included(mod)
        mod.value_class.prepend(ValueExtension)
      end

      class UndefinedObject
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

      def defined?(name)
        self[name].defined?
      end

      UNDEFINED = UndefinedObject.instance

      module ValueExtension
        def value
          @value unless @value == UNDEFINED
        end

        def clear!
          @value = UNDEFINED
        end

        def to_format
          @value
        end

        def undefined?
          @value == UNDEFINED
        end
      end
    end
  end
end
