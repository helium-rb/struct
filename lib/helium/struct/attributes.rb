require "helium/struct/undefined"
require "helium/struct/attribute"

module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.singleton_class.include(ClassMethods)
      end

      def self.defaults
        {
          default: Undefined.instance
        }
      end

      def defined?(attr_name)
        !@attributes[attr_name].value.instance_of? Undefined
      end

    private

      def build_attributes
        @attributes = {}
        self.class.schema.each do |key, options|
          @attributes[key] = Attribute.new(**options)
        end
      end

      module ClassMethods
        def attributes
          schema.keys
        end

        def attribute(name, **opts)
          schema[name] = Attributes.defaults.merge(opts)

          define_method name do
            value = @attributes[name].value
            value unless value.instance_of? Undefined
          end

          define_method "#{name}=" do |value|
            @attributes[name].value = value
          end

          name
        end

        # TODO: Whould we abstract this?
        def new(*args, &block)
          allocate.tap do |instance|
            instance.send :build_attributes
            instance.send :initialize, *args, &block
          end
        end

        def schema
          @schema ||= {}
        end
      end
    end
  end
end
