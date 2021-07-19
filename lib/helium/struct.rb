require "helium/console" rescue :optional_dependency
require "helium/struct/version"
require "helium/struct/attributes"
require "helium/struct/hooks"
require "helium/struct/use"
require "helium/struct/nested"
require "helium/struct/formattable"
require "helium/struct/naming"

module Helium
  module Struct
    def self.included(mod)
      mod.include Features

      mod.feature Initialization
      mod.feature Dependency

      mod.feature Attributes
      mod.feature Hooks
      mod.feature Use
      mod.feature Nested
      mod.feature Naming
      mod.feature Formattable
    end
  end
end
