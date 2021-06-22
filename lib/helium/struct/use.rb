module Helium
  module Struct
    module Use
      def self.included(mod)
        mod.extend(ClassMethods)
        mod.prepend(Initialization)
      end

      module ClassMethods
        def use(struct_class, **opts)
          used_structs << [struct_class, opts]

          struct_class.schema.each do |name, attribute|
            attribute name
          end

          if opts[:as]
            define_method opts[:as] do
              @used_structs[opts[:as]]
            end
          end
        end

        def used_structs
          @used_structs ||= []
        end
      end

      module Initialization
        def initialize(*args)
          @used_structs = {}
          self.class.used_structs.each do |struct_class, opts|
            instance = struct_class.new(attributes: attributes)

            @used_structs[opts[:as]] = instance
          end

          super
        end
      end
    end
  end
end