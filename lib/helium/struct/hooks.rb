module Helium
  module Struct
    module Hooks
      def self.included(mod)
        mod.extend ClassMethods
        mod.prepend Initialization
      end

      module ClassMethods
        def on_change(attr_name, &block)
          hooks << [attr_name, :change, block]
        end

        def hooks
          @hooks ||= []
        end
      end

      module Initialization
        def initialize(*args, &block)
          self.class.hooks.each do |attr, type, hook|
            attributes[attr].register_hook(type, self, &hook)
          end
        end
      end
    end
  end
end
