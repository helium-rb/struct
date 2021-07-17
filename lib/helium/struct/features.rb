module Helium
  module Struct
    module Features
      def self.included(mod)
        mod.extend ClassMethods
      end

      module ClassMethods
        def feature(mod)
          include mod
          struct_features << mod unless struct_features.include? mod
        end

        def struct_features
          @struct_features ||= []
        end
      end
    end
  end
end
