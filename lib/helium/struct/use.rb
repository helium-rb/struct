module Helium
  module Struct
    module Use
      def self.included(mod)
        mod.extend(ClassMethods)

        mod.before_initialize do
          @used_structs = {}
          self.class.used_structs.each do |struct_class, opts|
            injected_values = opts[:map]
              .select {|original_name, new_name| new_name }
              .map { |original_name, new_name| [original_name, values[new_name]] }
              .to_h

            instance = struct_class.new(values: injected_values)
            # TODO: This means we will only reference one anonymous struct!
            @used_structs[opts[:as]] = instance
          end
        end
      end

      module ClassMethods
        def use(struct_class, **opts)
          opts[:map] = struct_class.attributes.map { |i| [i, i] }.to_h.merge(opts[:map])
          if (prefix = opts.delete(:prefix))
            opts[:map].transform_values! { |name| name && [prefix, name].join('_').to_sym }
          end

          used_structs << [struct_class, opts]

          opts[:map].each do |_, new_name|
            attribute new_name if new_name
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
    end
  end
end
