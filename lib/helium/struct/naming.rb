module Helium
  module Struct
    module Naming
      def self.included(mod)
        mod.dependency(:struct_name) { self.class.name }
      end
    end
  end
end
