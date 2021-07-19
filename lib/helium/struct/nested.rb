require 'helium/struct/nested/collection_proxy'
require 'helium/struct/nested/single_proxy'

module Helium
  module Struct
    module Nested
      def self.included(mod)
        mod.extend ClassMethods
        mod.before_initialize do
          @nested = self.class.nested_structs.map do |name, (struct, options)|
            proxy_class = options[:collection] ? CollectionProxy : SingleProxy
            [
              name,
              proxy_class.new(self, struct,
                value_class: value_class,
                struct_name: "#{struct_name}.#{name}",
                **options
              )
            ]
          end.to_h
        end
      end

      private

      attr_reader :nested

      module ClassMethods
        def nested(name, struct_class = nil, **options, &block)
          if struct_class && block
            raise "Both block and struct class specified for nested struct: #{name} of #{self.name}"
          end

          features = self.struct_features
          struct_class ||= Class.new do
            include Features
            features.each { |feat| feature feat }
            class_eval(&block)
          end

          nested_structs[name] = [struct_class, options]

          define_method(name) do
            @nested[name]
          end
        end

        def nested_structs
          @nested_structs ||= {}
        end
      end
    end
  end
end
