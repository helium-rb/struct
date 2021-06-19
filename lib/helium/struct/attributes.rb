require "helium/struct/undefined"
require "helium/struct/attribute"
require "helium/struct/attribute_builder"

module Helium
  module Struct
    module Attributes
      def self.included(mod)
        mod.singleton_class.include(ClassMethods)
      end

      def undefined?(attr_name)
        @attributes[attr_name].undefined?
      end

      def defined?(attr_name)
        !undefined?(attr_name)
      end

      def delete(attr_name)
        @attributes[attr_name].clear!
      end

    private

      def build_attributes
        @attributes = {}
        self.class.schema.each do |key, attribute|
          @attributes[key] = attribute.build_value
        end
      end

      module ClassMethods
        def attributes
          schema.keys
        end

        def attribute(name, **opts, &block)
          schema[name] = Attribute.new(**opts)

          if block
            builder = AttributeBuilder.new(schema[name])
            builder.instance_exec(&block)
          end

          define_method name do
            @attributes[name].value
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
