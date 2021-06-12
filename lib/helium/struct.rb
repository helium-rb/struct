require "helium/console" rescue :optional_dependency
require "helium/struct/version"
require "helium/struct/attributes"

module Helium
  module Struct
    def self.included(mod)
      mod.include Attributes
    end
  end
end
