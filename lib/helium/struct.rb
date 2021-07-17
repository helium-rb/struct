require "helium/console" rescue :optional_dependency
require "helium/struct/version"
require "helium/struct/attributes"

module Helium
  module Struct
    def self.included(mod)
      mod.include Features

      mod.feature Initialization
      mod.feature Dependency

      mod.feature Attributes
      mod.feature Hooks
      mod.feature Use
    end


    if defined? Helium::Console
      Helium::Console.define_formatter_for self do
        def call
          table = Helium::Console::Table.new format_keys: false, runner: '| '

          object.class.attributes.each do |attr|
            table.row light_blue("#{attr}:"), object.send(:values)[attr]
          end

          [ "# #{light_yellow object.class.name}",
            format(table)
          ].join($/)
        end
      end
    end
  end
end
