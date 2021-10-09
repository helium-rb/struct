module Helium
  module Struct
    module Nested
      class CollectionProxy
        def initialize(owner, struct_class, value_class:, struct_name:, index_by: nil, **options)
          @owner = owner
          @struct_class = struct_class
          @value_class = value_class
          @struct_name = struct_name
          @index_by = index_by
          @options = options

          @structs = []
        end

        def build
          struct = @struct_class.new(
            value_class: @value_class,
            struct_name: @struct_name
          )

          @structs << struct

          struct
        end

        def method_missing(name, *args, &block)
          @structs.send(name, *args, &block)
        end

        def respond_to_missing?(name, private = false)
          @structs.respond_to?(name, true)
        end

        def indexed_structs
          return @structs.each.with_index.to_a.map(&:reverse).to_h unless @index_by

          @structs.index_by(@index_by)
        end


        if defined? Helium::Console
          Helium::Console.define_formatter_for self do
            def render_partial
              struct_name = object.instance_variable_get(:@struct_name)

              if object.indexed_structs.none?

                return [
                  (light_yellow(struct_name) if options.fetch(:name, true)),
                  light_black("none")
                ].compact.join(" ")
              end

              yield_lines do |y|
                y << "# #{light_yellow(struct_name)}" if options.fetch(:name, true)

                object.indexed_structs.each do |key, object|
                  y << "# #{light_black("[#{key.to_s}]")}"
                  format(object, name: false).lines.each { |line| y << line }
                end
              end
            end
          end
        end
      end
    end
  end
end
