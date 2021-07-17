
module Helium
  module Struct
    module Hooks
      HOOKS = %i[change]

      def self.included(mod)
        mod.extend(ClassMethods)
        mod.attribute_class.prepend(AttributeClass)
        mod.value_class.prepend(ValueClass)
      end

      module ClassMethods
        def on_change(attr, &block)
          schema[attr].register_hook(:change, &block)
        end
      end

      module AttributeClass
        def register_hook(name, &block)
          hooks[name] << block
        end

        def process_value(value:, form:)
          value = super
          return value unless value.respond_to?(:register_hook)

          hooks.each do |type, hooks|
            hooks.each { |hook| value.register_hook(type, form, &hook) }
          end

          value
        end

        private

        def hooks
          @hooks ||= Hash.new do |h, k|
            raise "Unknown attribute hook: #{k}" unless HOOKS.include?(k)
            h[k] = []
          end
        end
      end

      module ValueClass
        def hooks
          @hooks ||= Hash.new {|h,k| h[k] = [] }
        end

        def register_hook(type, struct_instance, &block)
          hooks[type] << [struct_instance, block]
        end

        def value=(new_value)
          old_value = @value

          super

          if old_value != new_value
            hooks[:change].each do |instance, hook|
              instance.instance_exec(new_value, old_value, &hook)
            end
          end
        end
      end
    end
  end
end
