module Helium
  module Struct
    class Attribute
      HOOKS = %i[change]

      def initialize(**opts)
        @opts = opts
        @hooks = Hash.new {|h,k| h[k] = []}
      end

      attr_reader :hooks

      def default
        @opts[:default] || Undefined.instance
      end

      def initial_value
        @opts[:initial] || default
      end

      def build_value(form)
        value = Value.new(self)
        @hooks.each do |type, hooks|
          hooks.each {|hook| value.register_hook(type, form, &hook) }
        end
        value
      end

      def register_hook(name, &block)
        raise "Unknown attribute hook: #{name}" unless HOOKS.include?(name)

        @hooks[name] << block
      end

      class Value
        def initialize(attribute)
          @attribute = attribute
          @value = attribute.initial_value
          @hooks = Hash.new {|h,k| h[k] = [] }
        end

        def undefined?
          @value.is_a? Undefined
        end

        def value
          return @attribute.default if undefined?
          @value
        end

        def clear!
          self.value = Undefined.instance
        end

        def register_hook(type, struct_instance, &block)
          @hooks[type] << [struct_instance, block]
        end

        def value=(new_value)
          old_value = @value
          @value = new_value

          if old_value != new_value
            @hooks[:change].each do |instance, hook|
              instance.instance_exec(new_value, old_value, &hook)
            end
          end
        end
      end
    end
  end
end
