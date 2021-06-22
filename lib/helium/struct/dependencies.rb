module Helium
  module Struct
    module Dependencies
      def self.included(mod)
        mod.extend ClassMethods
        mod.prepend Initialization
      end

      module ClassMethods
        def dependency(name, private: true, &block)
          dependencies[name] = block

          define_method name do
            @_dependencies[name]
          end

          private(name) if private
        end

        def dependencies
          @dependencies ||= {}
        end
      end

      module Initialization
        def initialize(*args, **kwargs, &block)
          @_dependencies = self.class.dependencies.map do |name, default_block|
            [name, kwargs.key?(name) ? kwargs.delete(name) : instance_exec(&default_block)]
          end.to_h

          if kwargs.any?
            super(*args, **kwargs, &block)
          else
            super(*args, &block)
          end
        end
      end
    end
  end
end
