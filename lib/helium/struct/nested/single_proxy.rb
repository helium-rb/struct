module Helium
  module Struct
    module Nested
      class SingleProxy
        def initialize(owner, struct_class, value_class:, struct_name:, **options)
          @owner = owner
          @struct_class = struct_class
          @options = options

          @struct = struct_class.new(
            value_class: value_class,
            struct_name: struct_name
          )
        end

        def method_missing(name, *args, &block)
          @struct.send(name, *args, &block)
        end

        def respond_to_missing?(name, private = false)
          @struct.respond_to?(name, true)
        end

        if defined? Helium::Console
          Helium::Console.define_formatter_for self do
            def render_partial
              format object.instance_variable_get(:@struct)
            end
          end
        end
      end
    end
  end
end
