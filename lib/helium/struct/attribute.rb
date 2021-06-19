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

      def build_value
        Value.new(self)
      end

      def register_hook(name, &block)
        raise "Unknown attribute hook: #{name}" unless HOOKS.include?(name)

        @hooks[name] << block
      end

      class Value
        def initialize(attribute)
          @attribute = attribute
          @value = attribute.initial_value
        end

        def undefined?
          @value.is_a? Undefined
        end

        def valuee
          return attribute.default if undefined?
          @value
        end

        def clear!
          self.value = Undefined.instance
        end

        def value=(new_value)
          old_value = @value
          @value = new_value

          if old_value != new_value
            @attribute.hooks[:change].each do |hook|
              hook.call(new_value, old_value)
            end
          end
        end
      end
    end
  end
end
