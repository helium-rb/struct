require "helium/console" rescue :optional_dependency
require "helium/struct/version"
require "helium/struct/dependencies"
# require "helium/struct/hooks"
# require "helium/struct/use"
require "helium/struct/attributes"
require "helium/struct/value"


module Helium
  module Struct
    def self.included(mod)
      # mod.include Use
      mod.include Dependencies

      mod.include Attributes
      # mod.include Hooks
    end

    if defined? Helium::Console
      Helium::Console.define_formatter_for self do
        def call
          table = Helium::Console::Table.new format_keys: false, runner: '| '

          object.class.attributes.each do |attr|
            table.row light_blue("#{attr}:"), object.send(attr)
          end

          [ "# #{light_yellow object.class.name}",
            format(table)
          ].join($/)
        end
      end
    end
  end
end
